import 'package:bustracking/util/app_constants.dart';
import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: AppConstants.mainColor,
  secondaryHeaderColor: Color(0xFF009f67),
  disabledColor: Color(0xffa2a7ad),
  backgroundColor: Color(0xFF343636),
  errorColor: AppConstants.mainColor,
  brightness: Brightness.dark,
  hintColor: Color(0xFFbebebe),
  cardColor: Colors.black,
  colorScheme: ColorScheme.dark(
      primary: AppConstants.mainColor, secondary: AppConstants.mainColor),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: AppConstants.mainColor)),
);
