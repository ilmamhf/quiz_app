import 'package:flutter/material.dart';

class LoadingDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Mencegah penutupan dialog dengan mengetuk di luar
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop(); // Menutup dialog loading
  }
}