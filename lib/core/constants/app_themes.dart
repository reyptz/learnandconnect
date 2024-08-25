import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    hintColor: AppColors.accentColor,
    backgroundColor: AppColors.backgroundColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    textTheme: TextTheme(
      headline1: TextStyle(color: AppColors.textColor, fontSize: 24, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(color: AppColors.textColor, fontSize: 16),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    appBarTheme: AppBarTheme(
      color: AppColors.primaryColor,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkGrey,
    hintColor: AppColors.accentColor,
    backgroundColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TextTheme(
      headline1: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(color: Colors.white, fontSize: 16),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.darkGrey,
      textTheme: ButtonTextTheme.primary,
    ),
    appBarTheme: AppBarTheme(
      color: AppColors.darkGrey,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
  );
}
