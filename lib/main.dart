import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodcart/ui/auth/phone_auth.dart';
import 'package:foodcart/ui/dashboard/dashboard_screen.dart';
import 'package:foodcart/utils/screen_utils/flutter_screenutil.dart';
import 'package:foodcart/utils/storage/Database.dart';

import 'ui/auth/login_page.dart';
import 'utils/storage/PreferenceUtils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DB.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: Colors.orange,
        accentColor: Colors.orangeAccent,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, appNavigation);
  }

  void appNavigation() async {
    bool isLogin = await PreferenceUtils.isLogin();
    String phoneNumber = await PreferenceUtils.getPhoneNumber();

    if (isLogin) {
      if (phoneNumber == null || phoneNumber.isEmpty) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) => PhoneAuth()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(vsync: this, duration: new Duration(seconds: 2));
    animation = new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 760, allowFontScaling: true);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'images/logo.png',
                width: (animation.value * 250).w,
                height: (animation.value * 250).h,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
