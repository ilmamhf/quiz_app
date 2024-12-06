import 'package:flutter/material.dart';

class MyCheckboxRow extends StatelessWidget {
  final List<String> abcd;
  final ValueNotifier<int> selectedAnswerNotifier;
  final bool enabled;

  MyCheckboxRow({
    super.key,
    required this.abcd,
    required this.selectedAnswerNotifier,
    this.enabled = false,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return ValueListenableBuilder<int>(
      valueListenable: selectedAnswerNotifier,
      builder: (context, selectedAnswerIndex, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Row(
            children: [
              for (int i = 0; i < abcd.length; i++) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Container(
                    // Hapus batasan lebar maksimum
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Color(0xFF99FCFF),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Menyesuaikan ukuran berdasarkan konten
                        children: [
                          Container(
                            width: 18.0,
                            height: 18.0,
                            color: Colors.white,
                            child: Checkbox(
                              activeColor: Colors.green,
                              value: selectedAnswerIndex == i,
                              onChanged: enabled ? (bool? value) {
                                if (value == true) {
                                  selectedAnswerNotifier.value = i; // Update nilai ValueNotifier
                                }
                              } : null,
                            ),
                          ),
                          SizedBox(width: 4.0), // Tambahkan sedikit jarak antara checkbox dan teks
                          Text(
                            abcd[i],
                            style: TextStyle(fontSize: screenWidth * 0.035),
                          ),
                        ],
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