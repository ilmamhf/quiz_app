import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  final String text;
  final dateController;
  final Color labelColor;
  final bool enabled;
  
  const DatePicker({
    super.key, 
    required this.text, 
    required this.dateController,
    required this.labelColor,
    this.enabled = true,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  // FocusNode node = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            enabled: widget.enabled,
            controller: widget.dateController,
            decoration: InputDecoration(
              hintText: widget.text,
              hintStyle: TextStyle(fontSize: 14.0),
              fillColor: Colors.white,
              filled: true,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              // hintText: widget.text,
              // hintStyle: TextStyle(color: Colors.grey[400]),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)
              ),
              errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            errorStyle: TextStyle(height: 0),
            ),
            readOnly: true,
            onTap: () {_selectDate();},
          
            // focusNode: node,
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            // validator: (value) {
            //   if(node.hasFocus) return null;
            //   if (value!.isEmpty) return "";
            // return null;
            // },
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(1950), 
      lastDate: DateTime(2100),
    );

    if (_picked != null){
      String formattedDate = DateFormat('dd/MM/yyyy').format(_picked);
      setState(() {
        widget.dateController.text = formattedDate;
      });
    } 
    // else {
    //   setState(() {
    //     this.widget.dateController.text = widget.text;
    //   });
    // }
  }
}