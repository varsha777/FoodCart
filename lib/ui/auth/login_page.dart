import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodcart/ui/auth/phone_auth.dart';
import 'package:foodcart/ui/dashboard/dashboard_screen.dart';
import 'package:foodcart/utils/messages/MessagesFunctions.dart';
import 'package:foodcart/utils/storage/PreferenceUtils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:foodcart/utils/screen_utils/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 760, allowFontScaling: true);

    return Scaffold(
        key: _scaffoldKey,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Text(
                    "FOOD CART SIGN UP",
                    style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold, fontSize: 20.ssp),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.h,bottom: 10.h),
                  child: Image.asset(
                    'images/logo.png',
                    height: 100.h,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                IgnorePointer(
                  ignoring: isLoading,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: _signInButton(),
                  ),
                ),
                isLoading
                    ? Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: CircularProgressIndicator(strokeWidth: 2.w),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ));
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        setState(() {
          isLoading = true;
        });
        onGoogleSignIn(context);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.blue),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 7.h, 0, 7.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("images/google_logo.png"), height: 30.h),
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Text(
                'Sign in with google',
                style: TextStyle(
                  fontSize: 20.ssp,
                  color: Colors.blue,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onGoogleSignIn(BuildContext context) async {
    FirebaseUser user = await _handleSignIn();
    if (user != null) {
      await PreferenceUtils.setLogin(true);
      await PreferenceUtils.setUserName(user.displayName);
      await PreferenceUtils.setUserId(user.uid);
      await PreferenceUtils.setUserEmail(user.email);
      await PreferenceUtils.setUserImage(user.photoUrl);
      _scaffoldKey.currentState.showSnackBar(ErrorMessages.showErrorMessage("Login Success"));

      setState(() {
        isLoading = false;
      });


      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (BuildContext context) => PhoneAuth()));
    } else {
      setState(() {
        isLoading = false;
      });
      _scaffoldKey.currentState.showSnackBar(ErrorMessages.showErrorMessage("Failed to login"));
    }
  }

  Future<FirebaseUser> _handleSignIn() async {
    // hold the instance of the authenticated user
    FirebaseUser user; // flag to check whether we're signed in already
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      // if so, return the current user
      user = await _auth.currentUser();
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      if (googleUser == null || googleUser.authentication == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication; // get the credentials to (access / id token)
      // to sign in via Firebase Authentication
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      user = (await _auth.signInWithCredential(credential)).user;
    }
    return user;
  }
}
