import 'dart:convert';

import 'package:crediApp/global/models/user/user_model.dart';
import 'package:crediApp/global/models/user/user_response_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crediApp/global/util.dart';

class HelperFunctions {
  static String sharedPreferenceUserLoggedInKey = "isLoggedIn";
  static String sharedPreferenceUserInfoKey = "userInfo";
  static String sharedPreferenceUserIdKey = "userId";
  static String sharedPreferenceUserNameKey = "userName";
  static String sharedPreferenceUserEmailKey = "userEmail";
  static String sharedPreferenceUserToken = 'token';

  /// saving data
  static Future<bool> saveLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isLoggedIn);
  }

  static Future<bool?> getLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUserLoggedInKey);
  }

  // static Future<bool> saveUserInfo(User? userInfo) async {
  //   logger.i("save : ${userInfo.toString()}");
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return await prefs.setString(
  //       sharedPreferenceUserInfoKey, "${userInfo.toString()}");
  // }

  static Future<bool> saveUserDataInfo(UserResponseData userInfo) async {
    logger.i("save : ${userInfo.toString()}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
        sharedPreferenceUserInfoKey, "${userInfo.toString()}");
  }

  static Future<UserResponseData> getUserDataInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString(sharedPreferenceUserInfoKey));
    UserResponseData userData = UserResponseData.fromJson(
        jsonDecode(prefs.getString(sharedPreferenceUserInfoKey)!));
    return userData;
  }

  static Future<bool> saveUserInfo(User? userInfo) async {
    logger.i("save : ${userInfo.toString()}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
        sharedPreferenceUserInfoKey, "${userInfo.toString()}");
  }

  static Future<bool> saveUserId(int? userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (userId == null) {
      return prefs.remove(sharedPreferenceUserIdKey);
    } else {
      return await prefs.setInt(sharedPreferenceUserIdKey, userId);
    }
  }

  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserIdKey);
  }

  static Future<bool> saveUserEmail(String? userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (userEmail == null) {
      return prefs.remove(sharedPreferenceUserNameKey);
    } else {
      return await prefs.setString(sharedPreferenceUserNameKey, userEmail);
    }
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserNameKey);
  }

  static Future<String?> readToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(sharedPreferenceUserToken)) {
      return prefs.getString(sharedPreferenceUserToken)!;
    }
    return '';
  }

  static Future<void> writeToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = token;
    prefs.setString(sharedPreferenceUserToken, token);
  }

  static Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(sharedPreferenceUserToken)) {
      prefs.remove(sharedPreferenceUserToken);
    }
  }

  static logout() async {
    HelperFunctions.saveLoggedIn(false);
    HelperFunctions.saveUserInfo(null);
    HelperFunctions.saveUserEmail(null);
    HelperFunctions.saveUserId(null);
    try {
      await FlutterSecureStorage().deleteAll();
    } catch (e) {
      print(e);
    }
  }
}
