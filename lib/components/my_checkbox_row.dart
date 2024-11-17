import 'package:flutter/material.dart';

class MyCheckboxRow extends StatelessWidget {
  List<String> abcd;
  final ValueNotifier<int> selectedAnswerNotifier;

  MyCheckboxRow({
    super.key,
    required this.abcd,
    required this.selectedAnswerNotifier,
  });

  // List<String> abcd = ['A', 'B', 'C', 'D'];
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedAnswerNotifier,
      builder: (context, selectedAnswerIndex, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              children: [
                for (int i = 0; i < 4; i++) ...[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 60, minHeight: 24.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Color(0xFF99FCFF),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 18.0,
                                height: 18.0,
                                color: Colors.white,
                                child: Checkbox(
                                  activeColor: Colors.green,
                                  value: selectedAnswerIndex == i,
                                  onChanged: (bool? value) {
                                    if (value == true) {
                                      selectedAnswerNotifier.value = i; // Update nilai ValueNotifier
                                    }
                                  },
                                ),
                              ),
                              Text(abcd[i]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          );
        },
    );
  }
}