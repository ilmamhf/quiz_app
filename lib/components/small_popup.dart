import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MySmallPopUp {
  static void showToast({
    required String message,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor = Colors.red,
    Color textColor = Colors.white,
    int duration = 3, // dalam detik
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
      timeInSecForIosWeb: duration,
    );
  }
}