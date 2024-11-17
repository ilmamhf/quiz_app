import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneField extends StatelessWidget {
  final phoneController;
  const PhoneField({
    super.key,
    required this.phoneController,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('No HP', textAlign: TextAlign.left,),

          SizedBox(height: 5,),
          IntlPhoneField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              // labelText: 'No HP',
              // labelStyle: TextStyle(color: Colors.grey[400]),
              enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              errorStyle: TextStyle(height: 0),
              fillColor: Colors.white,
              filled: true,
            ),
          
            keyboardType: TextInputType.numberWithOptions(decimal: false),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
          
            initialCountryCode: 'ID',
            onChanged: (phone) {
              phoneController.text = phone.completeNumber;
              print(phone.completeNumber);
            },
          ),
        ],
      ),
    );
  }
}