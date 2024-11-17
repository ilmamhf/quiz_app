import 'package:flutter/material.dart';

import '../../components/my_button.dart';
import '../start_pages/home_page.dart';
import 'tests/soal_umum_quiz.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          
              // kerjakan soal umum
              MyButton(
                onTap: () => 
                Navigator.push(context, MaterialPageRoute(builder: (context) => SoalUmumQuiz())), 
                text: 'Kerjakan Soal Umum', 
                size: 10
              ),

              const SizedBox(height: 40),
          
              // balik
              MyButton(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())), 
                text: 'Kembali', 
                size: 10
              ),
            ],
          ),
        ),
      ),
    );
  }
}