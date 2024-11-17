import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropdownField extends StatefulWidget {
  final String hintText;
  final List<String> listString;
  String selectedItem;
  final Function(String?) onChange;
  final Color labelColor;

  DropdownField({
    super.key, 
    required this.hintText, 
    required this.listString,
    required this.selectedItem,
    required this.onChange,
    required this.labelColor,
  });

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  String _selectedItem = '';

  @override
  void initState() {
    _selectedItem = widget.selectedItem;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.hintText.isNotEmpty) ...[
            Text(
              widget.hintText, 
              textAlign: TextAlign.center,
              style: TextStyle(color: widget.labelColor),
            ),

            const SizedBox(height: 5),
          ],

          DropdownSearch<String>(
            autoValidateMode: AutovalidateMode.onUserInteraction,
            items: widget.listString,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                // labelText: widget.hintText,
                // labelStyle: TextStyle(color: Colors.grey[400]),
                enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              fillColor: Colors.white,
              filled: true,
              )
            ),
            validator: (String? item) {
              if (item == null)
                return "Tidak boleh kosong";
              else
                return null;
            },
            onChanged: (newValue) {
              setState(() {
                _selectedItem = newValue!;
              });
              widget.onChange(newValue);
            },
            selectedItem: _selectedItem,
            popupProps: PopupProps.menu(
              showSearchBox: false,
              fit: FlexFit.loose,
              itemBuilder: (context, item, isSelected) {
                return ListTile(
                  title: Text(item),
                  selected: isSelected,
              );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(DropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectedItem = widget.selectedItem; // Update _selectedItem when widget is updated
  }

}