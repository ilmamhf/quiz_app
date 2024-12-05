import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/date_picker.dart';
import '../../components/my_button.dart';
import '../../components/my_checkbox_row.dart';
import '../../components/my_dropdown.dart';
import '../../components/my_form_row.dart';
import '../../components/my_textfield.dart';

import '../../components/phone_field.dart';
import '../../components/small_popup.dart';
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
  String kelaminController = 'Jenis Kelamin';
  final noHPController = TextEditingController();
  final passwordAdminController = TextEditingController();

  List<String> tipeAkun = ['Admin', 'Evaluator', 'User'];
  ValueNotifier<int> selectedAnswerNotifier = ValueNotifier<int>(-1);
  String tipeAkunTerpilih = '';

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
      showErrorMessage("Passwords tidak sama!");
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
          tipeAkunTerpilih = tipeAkun[selectedAnswerNotifier.value];

          Profil userProfile = Profil(
            nama: namaLengkapController.text,
            tglLahir: timestamp,
            jenisKelamin: kelaminController,
            noHP: noHPController.text,
            role: tipeAkunTerpilih,
            username: emailController.text,
          );

          FirestoreService().addUser(userProfile);
          
          // pop the loading circle
          Navigator.pop(context);

          Navigator.pushReplacementNamed(context, '/verifypage', arguments: userProfile);

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF00cfd6),
      // backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text("Register", 
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    MyFormRow(
                      labelText: 'Kategori',
                      myWidget: MyCheckboxRow(
                        abcd: tipeAkun,
                        selectedAnswerNotifier: selectedAnswerNotifier,
                        enabled: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // jika memilih checkbox admin maka muncul textfield baru
                    // Cek apakah selectedAnswerNotifier.value valid
                    ValueListenableBuilder<int>(
                      valueListenable: selectedAnswerNotifier,
                      builder: (context, value, child) {
                        // Pastikan value tidak -1
                        if (value != -1 && tipeAkun[value] == 'Admin') {
                          return MyTextField(
                            controller: passwordAdminController,
                            hintText: 'Password Admin',
                            obscureText: true,
                          );
                        }
                        return SizedBox.shrink(); // Kembalikan widget kosong jika bukan Admin
                      },
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
                      hintText: '',
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
                
                    // // no hp
                    // PhoneField(
                    //   phoneController: noHPController,
                    // ),
                    // No HP
                    MyTextField(
                      controller: noHPController,
                      hintText: 'No HP',
                      obscureText: false,
                      digitOnly: true,
                    ),
                    const SizedBox(height: 20),
                    
                    ValueListenableBuilder<int>(
                      valueListenable: selectedAnswerNotifier,
                      builder: (context, value, child) {
                        // Pastikan value tidak -1
                        if (value != -1 && tipeAkun[value] == 'User') {
                          return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("User harus dibuatkan oleh evaluator"),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: changePage,
                              child: const Text(
                                "Kembali ke halaman login",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        );
                        } else {
                          return Column(
                            children: [
                              // sign up button
                              MyButton(
                                text: "Sign Up",
                                onTap: () {
                                  tipeAkunTerpilih = tipeAkun[selectedAnswerNotifier.value];

                                  if (emailController.text.isEmpty ||
                                      passwordController.text.isEmpty ||
                                      confirmPasswordController.text.isEmpty ||
                                      namaLengkapController.text.isEmpty ||
                                      tglLahirController.text.isEmpty ||
                                      kelaminController.isEmpty ||
                                      noHPController.text.isEmpty ||
                                      selectedAnswerNotifier.value == -1) {
                                    showErrorMessage("Tidak boleh ada yang kosong");
                                  } else {
                                    if (tipeAkunTerpilih == 'Admin') {
                                      if (passwordAdminController.text == 'admin') {
                                        signUserUp();
                                      } else {
                                        MySmallPopUp.showToast(message: 'Password admin salah');
                                      }
                                    }
                                    signUserUp();
                                  }
                                },
                                size: 25,
                              ),
                              const SizedBox(height: 20),
                              // login
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Sudah punya akun?"),
                                  const SizedBox(width: 4),
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
                              // const SizedBox(height: 20),
                            ],
                          );
                        }
                      },
                    ),

                    // // sign up button
                    // MyButton(
                    //   text: "Sign Up",
                    //   onTap: () {
                    //     tipeAkunTerpilih = tipeAkun[selectedAnswerNotifier.value];

                    //     if (emailController.text.isEmpty ||
                    //         passwordController.text.isEmpty ||
                    //         confirmPasswordController.text.isEmpty ||
                    //         namaLengkapController.text.isEmpty ||
                    //         tglLahirController.text.isEmpty ||
                    //         kelaminController.isEmpty ||
                    //         noHPController.text.isEmpty ||
                    //         selectedAnswerNotifier.value == -1) {
                    //       showErrorMessage("Tidak boleh ada yang kosong");
                    //     } else {
                    //       if (tipeAkunTerpilih == 'Admin') {
                    //         if (passwordAdminController.text == 'admin') {
                    //           signUserUp();
                    //         } else {
                    //           MySmallPopUp.showToast(message: 'Password admin salah');
                    //         }
                    //       }
                    //       signUserUp();
                    //     }
                    //   },
                    //   size: 25,
                    // ),
                    // const SizedBox(height: 20),
                    // // login
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     const Text("Sudah punya akun?"),
                    //     const SizedBox(width: 4),
                    //     GestureDetector(
                    //       onTap: changePage,
                    //       child: const Text(
                    //         "Login sekarang",
                    //         style: TextStyle(
                    //           color: Colors.black,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}