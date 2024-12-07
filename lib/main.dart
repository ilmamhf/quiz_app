import 'package:demensia_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/admin_pages/admin_page.dart';
import 'pages/evaluator_pages/evaluator_page.dart';
import 'pages/common_pages/email_verification_page.dart';
import 'pages/common_pages/login_page.dart';
import 'pages/common_pages/register_page.dart';
import 'pages/user_pages/user_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // atur device vertikal
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    
  ]);

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
        "/evaluatorpage": (_) => EvaluatorPage(),
      },
    );
  }
}