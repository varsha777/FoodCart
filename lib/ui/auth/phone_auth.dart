import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodcart/ui/dashboard/dashboard_screen.dart';
import 'package:foodcart/utils/common_functions/UtilFunctions.dart';
import 'package:foodcart/utils/common_functions/loading_progress.dart';
import 'package:foodcart/utils/messages/MessagesFunctions.dart';
import 'package:foodcart/utils/screen_utils/flutter_screenutil.dart';
import 'package:foodcart/utils/storage/PreferenceUtils.dart';

class PhoneAuth extends StatefulWidget {
  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  String getOtpText = "\nGET OTP  ";
  bool _isInAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 760, allowFontScaling: true);

    return CustomLoadProgress(
      inAsyncCall: _isInAsyncCall,
      child: Scaffold(
        key: _scaffoldKey,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Verify Mobile Number",
                style: TextStyle(fontSize: 20.ssp, color: Theme.of(context).primaryColor),
              ),
              SizedBox(height: 20.h),
              Container(
                  margin: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: TextField(
                    controller: _mobileController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: new InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                        hintText: 'Enter phone number',
                        labelText: 'Phone Number',
                        prefixText: '+91  ',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _checkMobileValidation();
                          },
                          child: Text(
                            getOtpText,
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                        suffixStyle: TextStyle(color: Colors.green)),
                  )),
              Container(
                  margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
                  child: TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: new InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                        hintText: 'Enter OTP',
                        labelText: 'OTP',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _submitOtp();
                          },
                          child: Text(
                            "\nVerify  ",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                        suffixStyle: TextStyle(color: Colors.green)),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _checkMobileValidation() {
    if (_mobileController.text.length <= 0 || _mobileController.text.length > 10) {
      _scaffoldKey.currentState
          .showSnackBar(ErrorMessages.showErrorMessage("Enter valid phone number"));
    } else {
      _sendOtp("+91 ${_mobileController.text.toString().trim()}");
    }
  }

  String _status;
  AuthCredential _phoneAuthCredential;
  String _verificationId;
  int _code;

  void _sendOtp(String phone) {
    setState(() {
      _isInAsyncCall = true;
      if (getOtpText.contains("GET OTP")) {
        getOtpText = "\nResend  ";
      } else {
        getOtpText = "\nGET OTP  ";
      }
    });
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: _verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: _codeTimeOut);
  }

  void _verificationCompleted(AuthCredential phoneAuthCredential) async {
    this._phoneAuthCredential = phoneAuthCredential;
    print("---");
    setState(() {
      _isInAsyncCall = false;
    });
  }

  void verificationFailed(AuthException error) {
    setState(() {
      _isInAsyncCall = false;
    });
    _scaffoldKey.currentState.showSnackBar(ErrorMessages.showErrorMessage(error.message));
  }

  void codeSent(String verificationId, [int forceResendingToken]) {
    print('codeSent');
    FocusScope.of(context).requestFocus(FocusNode());
    this._verificationId = verificationId;
    this._code = forceResendingToken;
    _scaffoldKey.currentState
        .showSnackBar(ErrorMessages.showErrorMessage("Code Sent successfully"));
    setState(() {
      _isInAsyncCall = false;
    });
  }

  void _codeTimeOut(String verificationId) {}

  void _submitOtp() {
    String smsCode = _otpController.text.toString().trim();
    if (_mobileController.text.toString().trim().length == 10) {
      if (smsCode.length < 0 || smsCode.length > 6) {
        _scaffoldKey.currentState.showSnackBar(ErrorMessages.showErrorMessage("Enter valid otp"));
      } else {
        setState(() {
          _isInAsyncCall = true;
        });
        this._phoneAuthCredential =
            PhoneAuthProvider.getCredential(verificationId: this._verificationId, smsCode: smsCode);

        _auth.signInWithCredential(this._phoneAuthCredential).catchError((error) {
          _scaffoldKey.currentState.showSnackBar(
              ErrorMessages.showErrorMessage('Something has gone wrong, please try later'));
          setState(() {
            _isInAsyncCall = false;
          });
        }).then((AuthResult result) {

          if (result.user != null) {
            _navigateToDashBoard();
          } else {
            setState(() {
              _isInAsyncCall = false;
            });
            _scaffoldKey.currentState
                .showSnackBar(ErrorMessages.showErrorMessage("Some thing went wrong try again"));
          }
        });
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(ErrorMessages.showErrorMessage("Enter mobile number"));
    }
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _navigateToDashBoard() async {
    await PreferenceUtils.setPhoneNumber(_mobileController.text.toString().trim());
    setState(() {
      _isInAsyncCall = false;
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
  }
}
