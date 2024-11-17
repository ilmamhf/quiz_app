import 'package:flutter/material.dart';

class TextDisplay extends StatelessWidget {
  final String text;
  final String judul;

  const TextDisplay({
    super.key, 
    required this.text,
    required this.judul,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            judul, 
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.black),
          ),

          SizedBox(height: 5,),
          
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey)
            ),
            padding: const EdgeInsets.only(left: 15, bottom: 15, top: 15),
            // margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}