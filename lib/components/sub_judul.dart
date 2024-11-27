import 'package:flutter/material.dart';

class MySubJudul extends StatelessWidget {
  final String text;

  const MySubJudul({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0),
        child: Container(
          // color: Colors.red,
          child: Text(
            text, style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}