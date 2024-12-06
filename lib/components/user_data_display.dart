import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start, // Menjaga alignment vertikal
      children: [
        Container(
          width: 120,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            text1,
            style: TextStyle(fontSize: 14.0),
          ),
        ),
        Text(':'),
        Expanded( // Menggunakan Expanded untuk mengizinkan Container mengisi ruang yang tersisa
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Container(
              // Hapus batasan tinggi dan biarkan Container menyesuaikan tinggi
              child: Text(
                text2,
                style: TextStyle(fontSize: 14.0),
                maxLines: 2, // Biarkan teks menjadi multiline tanpa batasan
                softWrap: true, // Izinkan teks untuk membungkus
              ),
            ),
          ),
        ),
      ],
    );
  }
}