import 'dart:async';

import 'package:bustracking/data/models/body/user_model.dart';
import 'package:bustracking/util/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.sharedPreferences});

// for  user ID
  Future saveUserData(
      String id, String username, String email, String password, String accountType, phone) async {
    await sharedPreferences.setString(AppConstants.USER_ID, id);
    await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
    await sharedPreferences.setString(AppConstants.USER_EMAIL, email);
    await sharedPreferences.setString(AppConstants.USER_NAME, username);
    await sharedPreferences.setString(AppConstants.PHONE, phone);
    await sharedPreferences.setString(
        AppConstants.USER_ACCOUNT_TYPE, accountType);
  }

  Future<bool> saveUserPhone(String phone) {
    return sharedPreferences.setString(AppConstants.USER_NUMBER, phone);
  }

  String getUserID() {
    return sharedPreferences.getString(AppConstants.USER_ID) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.USER_ID);
  }

  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.USER_NUMBER) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  String getUserEmail() {
    return sharedPreferences.getString(AppConstants.USER_EMAIL) ?? "";
  }

  String getUserAccountType() {
    return sharedPreferences.getString(AppConstants.USER_ACCOUNT_TYPE) ?? "";
  }

  Future<bool> clearUserInfo() async {
    await sharedPreferences.remove(AppConstants.USER_EMAIL);
    await sharedPreferences.remove(AppConstants.USER_ACCOUNT_TYPE);
    await sharedPreferences.remove(AppConstants.PHONE);
    await sharedPreferences.remove(AppConstants.USER_NAME);
    return await sharedPreferences.remove(AppConstants.USER_NUMBER);
  }

  Future getBuss() async {
    var buss;
    await FirebaseFirestore.instance.collection('bus').get().then((value) {
      buss = value.docs;
    });

    return buss;
  }

    String getUsername() {
    return sharedPreferences.getString(AppConstants.USER_NAME) ?? '';
  }
}
