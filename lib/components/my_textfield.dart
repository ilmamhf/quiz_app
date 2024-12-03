import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  bool enabled;
  final bool digitOnly;

  MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.enabled = true,
    this.digitOnly = false
    });

  // FocusNode node = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (hintText.isNotEmpty) ...[
          //   Text(
          //     hintText, 
          //     textAlign: TextAlign.left,
          //   ),

          //   const SizedBox(height: 5),
          // ],

          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 100.0),
            child: TextFormField(
              enabled: enabled,
              
              controller: controller,
              obscureText: obscureText,
            
              keyboardType: digitOnly ? TextInputType.number : TextInputType.multiline,
              inputFormatters: digitOnly ? [FilteringTextInputFormatter.digitsOnly] : [],
              maxLines: obscureText ? 1 : null ,
              style: TextStyle(fontSize: 14),
            
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: hintText
              ),
            ),
          ),
        ],
      ),
    );
  }
}