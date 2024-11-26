import 'package:flutter/material.dart';

class MyUserDataDisplay extends StatelessWidget {
  final String text1;
  final String text2;

  const MyUserDataDisplay({
    super.key,
    required this.text1,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              width: 136,
              padding: EdgeInsets.only(left: 30.0),
              child: Text(text1),
            ),
          ),
      
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Container(
              child: Text(text2),
            ),
          ),
        ],
      ),
    );
  }
}