import 'package:demensia_app/components/small_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/my_button.dart';
import '../../components/my_checkbox_row.dart';
import '../../components/my_form_row.dart';
import '../../components/my_textfield.dart';
import '../../models/profil.dart';
import '../../services/auth_service.dart';
import 'forgot_password.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService authService = AuthService();

  // text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final passwordAdminController = TextEditingController();
  List<String> tipeAkun = ['Admin', 'Evaluator', 'User'];
  ValueNotifier<int> selectedAnswerNotifier = ValueNotifier<int>(-1);
  String tipeAkunTerpilih = '';

  // sign user method
  void signUserIn(String tipe, String username, String password) async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    bool rightAccountRole = await authService.cekRole(username, tipe);

    if (rightAccountRole) {
      if (tipe == 'User') {
        // cari akun user di firebase (bukan sign in)
        bool rightUsername = await authService.cekUsername(username);
        bool isSuccess = await authService.fakeSignIn(username, password);

        if (rightUsername) {
          if (isSuccess) {
            print('betul');
            // ambil profil disini
            Profil? profil = await authService.getProfilByUsername(username);
            
            Navigator.pop(context); // pop the loading circle
            // Jika login berhasil, navigasi ke halaman berikutnya
            Navigator.pushReplacementNamed(context, '/userpage', arguments: profil);
          } else {
            Navigator.pop(context); // pop the loading circle
            // Jika login gagal, tampilkan pesan kesalahan
            MySmallPopUp.showToast(message: 'Password salah');
          }
        } else {
          Navigator.pop(context); // pop the loading circle
          // Jika login gagal, tampilkan pesan kesalahan
          MySmallPopUp.showToast(message: 'User tidak ditemukan');
        }
      } else {
        // try sign in
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, 
          password: passwordController.text,
          );

          // ambil profil disini
          // Profil? profil = await authService.getProfilByUsername(username);
          // pop the loading circle
          Navigator.pop(context);

          // Jika login berhasil, navigasi ke halaman berikutnya
          // Navigator.pushReplacementNamed(context, '/verifypage', arguments: profil);
          Navigator.pushReplacementNamed(context, '/verifypage');

        } on FirebaseAuthException catch (e) {
          // pop the loading circle
          Navigator.pop(context);

          // show error message
          print(e.code);
          if (e.code == 'user-not-found') {
            MySmallPopUp.showToast(message: 'Akun tidak ditemukan');
          } else if (e.code == 'wrong-password') {
            MySmallPopUp.showToast(message: 'Password salah');
          } else if (e.code == 'invalid-email') {
            MySmallPopUp.showToast(message: 'Email tidak valid');
          } else if (e.code == 'too-many-requests') {
            MySmallPopUp.showToast(message: 'Terlalu banyak permintaan, silahkan coba nanti');
          }
        }
      }
    } else {
      MySmallPopUp.showToast(message: 'Akun tidak ditemukan!');
      // pop the loading circle
      Navigator.pop(context);
    }

    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    
  }

  @override
  void dispose() {
    // Bebaskan semua TextEditingController
    emailController.dispose();
    passwordController.dispose();
    passwordAdminController.dispose();
    // Bebaskan ValueNotifier
    selectedAnswerNotifier.dispose();
    super.dispose(); // Panggil super.dispose() di akhir
  }

  @override
  Widget build(BuildContext context) {

    // change page
    void changePage() {
      Navigator.pushNamed(context, '/registerpage');
    }

    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: Color(0xFF00cfd6),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 8.0),
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
                            
                    MyFormRow(
                      labelText: 'Kategori',
                      myWidget: MyCheckboxRow(
                        abcd: tipeAkun,
                        selectedAnswerNotifier: selectedAnswerNotifier,
                        enabled: true,
                      ),
                    ),
                            
                    const SizedBox(height: 10),
                  
                    // email
                    MyTextField(
                      controller: emailController,
                      hintText: 'Email/Username',
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
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => FormForgotPassword()));
                            },
                            child: Text(
                              'Lupa Password?',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
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
                  
                    // const SizedBox(height: 10),
                  
                    const SizedBox(height: 20),
                  
                    // sign in button
                    MyButton(
                      text: "Login",
                      onTap: () {
                        if (
                          emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty &&
                          selectedAnswerNotifier.value != -1
                          ) {
                          tipeAkunTerpilih = tipeAkun[selectedAnswerNotifier.value];
                          String accountName = emailController.text;
                          String password = passwordController.text;
              
                          if (tipeAkunTerpilih == 'Admin') {
                            if (passwordAdminController.text == 'admin') {
                              print('admin');
                              signUserIn('Admin', accountName, password);
                            } else {
                              MySmallPopUp.showToast(message: 'Password Admin Salah!');
                            }
                          } else if (tipeAkunTerpilih == 'Evaluator') {
                            print('evaluator');
                            signUserIn('Evaluator', accountName, password);
                          } else if (tipeAkunTerpilih == 'User') {
                            print('user');
                            signUserIn('User', accountName, password);
                          }
                        } else {
                          MySmallPopUp.showToast(message: 'Form Login Belum Terisi!');
                        }
                      },
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
            ),
          ),
        ),
      ),
    );
  }
}