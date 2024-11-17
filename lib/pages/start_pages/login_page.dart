import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/my_button.dart';
import '../../components/my_textfield.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  // sign user method
  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text, 
      password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);

      Navigator.pushReplacementNamed(context, '/verifypage');

    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);

      // show error message
      print(e.code);
      if (e.code == 'user-not-found') {
        showErrorMessage('Wrong email');
      } else if (e.code == 'wrong-password') {
        showErrorMessage('Wrong password');
      } else if (e.code == 'invalid-email') {
        showErrorMessage('Email is invalid');
      } else if (e.code == 'too-many-requests') {
        showErrorMessage('Too many requests, please try again later');
      }
    }

    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    
  }

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
  Widget build(BuildContext context) {

    // change page
    void changePage() {
      Navigator.pushReplacementNamed(context, '/registerpage');
    }

    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.blue[900],
      //   actions: const [
      //     SkipButton()
      //   ],
      // ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // logo
              Container(
                height: 160,
                color: Colors.blue[900],
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // judul
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Text("Login", 
                        style: TextStyle(
                          fontSize: 60,
                        ),
                      ),
                    ),
                
                    const SizedBox(height: 20),
                
                    // email
                    MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),
                
                    const SizedBox(height: 10),
                
                    // password
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                      
                    ),
                
                    const SizedBox(height: 10),
                
                    // forgot password?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => FormForgotPassword()));
                            },
                            child: Text(
                              'Lupa Password?',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
                
                    const SizedBox(height: 20),
                
                    // sign in button
                    MyButton(
                      text: "Login",
                      onTap: signUserIn,
                      size: 15,
                    ),
                
                    const SizedBox(height: 20,),
                
                    // register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Belum memiliki akun?"),
                        const SizedBox(width: 4,),
                        GestureDetector(
                          onTap: changePage,
                          child: const Text(
                            "Register sekarang",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}