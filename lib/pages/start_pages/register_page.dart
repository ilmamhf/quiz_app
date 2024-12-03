import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/date_picker.dart';
import '../../components/my_button.dart';
import '../../components/my_dropdown.dart';
import '../../components/my_textfield.dart';

import '../../components/phone_field.dart';
import '../../models/profil.dart';
import '../../services/firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // final _formKey = GlobalKey<FormState>();

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final namaLengkapController = TextEditingController();
  final tglLahirController = TextEditingController();
  String kelaminController = '';
  final noHPController = TextEditingController();

  // sign user up method
  void signUserUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    // check if password is confirmed
    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);
      showErrorMessage("Passwords don't match!");
      return;
    } else {
      // try creating user
      try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, 
          password: passwordController.text,
          );

          // Ambil tanggal dari dateController
          final tglLahir = DateTime.parse(tglLahirController.text);
          // Buat objek Timestamp dari combinedDateTime
          final timestamp = Timestamp.fromDate(tglLahir);

          Profil userProfile = Profil(
            nama: namaLengkapController.text,
            tglLahir: timestamp,
            jenisKelamin: kelaminController,
            noHP: noHPController.text,
            role: 'Admin',
            username: emailController.text
          );

          FirestoreService().addAdmin(userProfile);
          
          // pop the loading circle
          Navigator.pop(context);

          Navigator.pushReplacementNamed(context, '/verifypage');

      } on FirebaseAuthException catch (e) {
          // pop the loading circle
          Navigator.pop(context);

          // show error message
          if (e.code == 'invalid-email') {
            showErrorMessage('Email is invalid');
          } else if (e.code == 'email-already-in-use') {
            showErrorMessage('The account already exists for that email.');
          }
      }
    }
  }

  // error message popup
  void showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
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
      Navigator.pushReplacementNamed(context, '/loginpage');
    }

    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   actions: const [
      //     SkipButton()
      //   ],
      // ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                        const SizedBox(height: 20),

                        // logo
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: Text("Register", 
                            style: TextStyle(
                              fontSize: 40,
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
                    
                        // confirm password
                        MyTextField(
                          controller: confirmPasswordController,
                          hintText: 'Konfirmasi Password',
                          obscureText: true,
                        ),
                    
                        const SizedBox(height: 30),
                    
                        // Nama lengkap
                        MyTextField(
                          controller: namaLengkapController,
                          hintText: 'Nama Lengkap',
                          obscureText: false,
                        ),
                    
                        const SizedBox(height: 10),
                    
                        // tanggal lahir
                        DatePicker(
                          dateController: tglLahirController,
                          text: 'Tanggal Lahir',
                          labelColor: Colors.black,
                          ),
                    
                        const SizedBox(height: 10),
                    
                        // jenis kelamin
                        DropdownField(
                          hintText: 'Jenis Kelamin',
                          labelColor: Colors.black,
                          listString: const [
                            'Pria',
                            'Wanita',
                          ],
                          selectedItem: kelaminController,
                          onChange: (newValue) {
                            setState(() {
                              kelaminController = newValue!;
                            });
                          },
                        ),
                    
                        const SizedBox(height: 10),
                    
                        // no hp
                        PhoneField(
                          phoneController: noHPController,
                        ),
                    
                        const SizedBox(height: 10),
                    
                        // sign up button
                        MyButton(
                          text: "Sign Up",
                          onTap: () {
                            // if (_formKey.currentState!.validate()) {
                            //   // cek field jenis kelamin dan no hp kosong apa tidak, kalo kosong showErrorMessage
                            //   if (kelaminController.isEmpty || noHPController.text.isEmpty) {
                            //     showErrorMessage("Tidak boleh ada yang kosong");
                            //   } else {
                            //     // Jika tidak kosong, lakukan pendaftaran
                            //     signUserUp();
                            //   }
                            // }
                    
                            // cek field jenis kelamin dan no hp kosong apa tidak, kalo kosong showErrorMessage
                              if (emailController.text.isEmpty ||
                                  passwordController.text.isEmpty ||
                                  confirmPasswordController.text.isEmpty ||
                                  namaLengkapController.text.isEmpty ||
                                  tglLahirController.text.isEmpty ||
                                  kelaminController.isEmpty ||
                                  noHPController.text.isEmpty) {
                                showErrorMessage("Tidak boleh ada yang kosong");
                              } else {
                                // Jika tidak kosong, lakukan pendaftaran
                                signUserUp();
                              }
                            
                          },
                          size: 25,
                        ),
                    
                        const SizedBox(height: 20,),
                    
                        // login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Sudah punya akun?"),
                            const SizedBox(width: 4,),
                            GestureDetector(
                              onTap: changePage,
                              child: const Text(
                                "Login sekarang",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 20),
                    
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}