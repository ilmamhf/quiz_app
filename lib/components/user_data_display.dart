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
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 136,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(text1, style: TextStyle(fontSize: 16.0),),
          ),

          Text(':'),
      
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Container(
              child: Text(text2, style: TextStyle(fontSize: 16.0),),
            ),
          ),
        ],
      ),
    );
  }
}