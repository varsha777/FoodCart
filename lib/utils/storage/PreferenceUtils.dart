import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';

class PreferenceUtils {
  static Future<SharedPreferences> getInstance() async {
    return await SharedPreferences.getInstance();
  }

  static Future<bool> isLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLogin') ?? false;
  }

  static Future<bool> setLogin(bool isLogin) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool('isLogin', isLogin);
  }

  static Future<bool> setPhoneNumber(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('USER_PHONE', phone);
  }

  static Future<String> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get("USER_PHONE");
  }

  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get("USER_NAME");
  }

  static Future<bool> setUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString("USER_NAME", userName);
  }

  static Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get("USER_ID");
  }

  static Future<bool> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString("USER_ID", userId);
  }

  static Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get("USER_EMAIL");
  }

  static Future<bool> setUserEmail(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString("USER_EMAIL", userEmail);
  }

  static Future<String> getUserImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get("USER_IMAGE");
  }

  static Future<bool> setUserImage(String userImage) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString("USER_IMAGE", userImage);
  }

  static Future<bool> makeLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("USER_IMAGE", "");
    prefs.setString("USER_ID", "");
    prefs.setString("USER_NAME", "");
    prefs.setString("USER_EMAIL", "");
    prefs.setString("USER_PHONE", "");
    prefs.setBool('isLogin', false);
    return true;
  }
}
