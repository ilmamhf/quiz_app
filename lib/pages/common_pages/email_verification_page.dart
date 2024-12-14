import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../components/my_appbar.dart';
import '../admin_pages/admin_page.dart';
import '../evaluator_pages/evaluator_page.dart';
import 'home_page.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  
  bool isEmailVerified = false;
  // bool canResendEmail = false;
  Timer? timer;

  // error message popup
  void showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  @override
  void initState() {
    super.initState();

    // user harus sudah dibuat
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      isEmailVerified = currentUser.emailVerified;

      if (!isEmailVerified) {
        sendVerificationEmail();

        timer = Timer.periodic(
          Duration(seconds: 3),
          (_) => checkEmailVerified(),
        );
      }
    }
  }
  
  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
  // Periksa apakah pengguna masih terautentikasi
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    // Panggil reload() jika pengguna masih terautentikasi
    await user.reload();

    setState(() {
      isEmailVerified = user.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }
}

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

    } catch (e) {
      showErrorMessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil data yang dikirim melalui arguments
    final String tipe = ModalRoute.of(context)!.settings.arguments as String;

    if (isEmailVerified) {
      if (tipe == 'Admin') {
        return AdminPage();
      } else {
        return EvaluatorPage();
        // return HomePage();
      }
    } else {
      return Scaffold(
        appBar: MyAppBar(title: 'Verifikasi Email',),
        backgroundColor: const Color(0xFF00cfd6),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pesan verifikasi email anda telah dikirim, silahkan cek email anda',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  TextButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                    ),
                    child: Text('Batal', style: TextStyle(fontSize: 24)),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, "/loginpage");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
