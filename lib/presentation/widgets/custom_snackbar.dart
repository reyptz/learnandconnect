import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show(
      BuildContext context, {
        required String message,
        Color backgroundColor = Colors.blue,
        Color textColor = Colors.white,
        int durationInSeconds = 3,
      }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: durationInSeconds),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
