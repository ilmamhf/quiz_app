import 'package:flutter/material.dart';

class MyFormRow extends StatelessWidget {
  final String labelText;
  Widget myWidget;
  
  MyFormRow({
    super.key, 
    required this.labelText,
    required this.myWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(left: 30),
            width: 120,
            child: Text(
              labelText, 
              textAlign: TextAlign.left,
            ),
          ),
      
          Expanded(
            child: myWidget,
          ),
        ],
      ),
    );
  }
}