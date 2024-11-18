import 'package:flutter/material.dart';

class MyBigPopUp {
  static void showAlertDialog({
    required BuildContext context,
    required String teks,
    List<Widget>? additionalButtons, // Parameter opsional untuk tombol tambahan
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            teks,
            textAlign: TextAlign.center,
          ),
          actions: [
            if (additionalButtons != null && additionalButtons.isNotEmpty)
              ...additionalButtons // Menambahkan tombol tambahan jika ada
            else
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
          ],
        );
      },
    );
  }
}