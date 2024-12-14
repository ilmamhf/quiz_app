import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class MyTextField extends StatefulWidget {
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

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  // FocusNode node = FocusNode();

  bool _passwordVisible = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _passwordVisible = false;
  // }

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
              enabled: widget.enabled,
              
              controller: widget.controller,
              obscureText: widget.obscureText ? !_passwordVisible : false, // Update this line
            
              keyboardType: widget.digitOnly ? TextInputType.number : TextInputType.multiline,
              inputFormatters: widget.digitOnly ? [FilteringTextInputFormatter.digitsOnly] : [],
              maxLines: widget.obscureText ? 1 : null ,
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
                hintText: widget.hintText,

                suffixIcon: widget.obscureText ? IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                    // color: Theme.of(context).primaryColorDark,
                    ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                        _passwordVisible = !_passwordVisible;
                    });
                  },
                ) : SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}