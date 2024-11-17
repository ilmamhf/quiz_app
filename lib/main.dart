import 'package:demensia_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/admin_pages/admin_page.dart';
import 'pages/start_pages/email_verification_page.dart';
import 'pages/start_pages/login_page.dart';
import 'pages/start_pages/register_page.dart';
import 'pages/user_pages/user_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(
      //   fontFamily: ''
      // ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        "/registerpage": (_) => RegisterPage(),
        "/loginpage": (_) => LoginPage(),
        "/verifypage": (_) => VerifyEmailPage(),
        "/adminpage": (_) => AdminPage(),
        "/userpage": (_) => UserPage(),
      },
    );
  }
}