import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodcart/main.dart';
import 'package:foodcart/utils/storage/PreferenceUtils.dart';

class Utils {
  static int next(int min, int max) {
    var _random = new Random();
    return min + _random.nextInt(max - min);
  }

  static void doLogout(BuildContext context) async {
    await PreferenceUtils.makeLogout();
//    await DB.deleteAllDepartments();
//    await DB.deleteAllFavourites();
//    await DB.deleteAllOrganization();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => SplashScreen()));
  }
}
