import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../components/big_popup.dart';
import '../../components/date_picker.dart';
import '../../components/my_appbar.dart';
import '../../components/my_button.dart';
import '../../components/my_checkbox_row.dart';
import '../../components/my_form_row.dart';
import '../../components/my_textfield.dart';
import '../../components/small_popup.dart';
import '../../components/sub_judul.dart';
import '../../models/profil.dart';
import '../../services/firestore.dart';

class TambahUserPage extends StatelessWidget {
  const TambahUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final namaLengkapController = TextEditingController();
    final dateController = TextEditingController();

    // final jenisKelaminController = TextEditingController();
    List<String> jenisKelamin= ['Pria', 'Wanita'];
    // bool isChecked = false;
    ValueNotifier<int> selectedAnswerNotifier = ValueNotifier<int>(-1);
    
    final NoHPController = TextEditingController();

    // Future<bool> cekKetersediaanUsername(username) async {
    //   await firestoreService.cekKetersediaanUsername(usernameController.text);
    // }

    return Scaffold(
      backgroundColor: Color(0xFF00cfd6),

      appBar: MyAppBar(title: "Buat User Baru",),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                // border: Border.all(color: Colors.black),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // judul
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text('Silahkan buat akun baru untuk user'),
                    ),
                
                    const SizedBox(height: 20),

                    MySubJudul(text: 'Akun :',),

                    const SizedBox(height: 5),

                    // username
                    MyFormRow(
                      labelText: 'Username',
                      myWidget: MyTextField(
                        controller: usernameController,
                        hintText: 'Ketik username di sini',
                        obscureText: false,
                      ),
                    ),
                
                    const SizedBox(height: 5),
                
                    // password
                    MyFormRow(
                      labelText: 'Password',
                      myWidget: MyTextField(
                        controller: passwordController,
                        hintText: 'Ketik password di sini',
                        obscureText: true,
                      ),
                    ),
                
                    const SizedBox(height: 20),

                    MySubJudul(text: 'Profil :',),

                    const SizedBox(height: 5),

                    // Nama Lengkap
                    MyFormRow(
                      labelText: 'Nama Lengkap',
                      myWidget: MyTextField(
                        controller: namaLengkapController,
                        hintText: 'Ketik nama lengkap di sini',
                        obscureText: false,
                      ),
                    ),
                
                    const SizedBox(height: 5),

                    // Tanggal Lahir
                    MyFormRow(
                      labelText: 'Tanggal Lahir',
                      myWidget: DatePicker(
                        dateController: dateController,
                        text: 'Isi tanggal lahir di sini',
                        labelColor: Colors.grey,
                      )
                    ),
                
                    const SizedBox(height: 5),
                
                    // Jenis Kelamin
                
                    MyFormRow(
                      labelText: 'Jenis Kelamin',
                      myWidget: MyCheckboxRow(
                        abcd: jenisKelamin,
                        selectedAnswerNotifier: selectedAnswerNotifier,
                        enabled: true,
                      )
                    ),

                    const SizedBox(height: 5),

                    // No HP
                    MyFormRow(
                      labelText: 'No HP',
                      myWidget: MyTextField(
                        controller: NoHPController,
                        hintText: 'Ketik no hp di sini',
                        obscureText: false,
                      ),
                    ),
                
                    const SizedBox(height: 20),
                
                    // tombol Simpan soal

                    Row(
                      children: [
                        Expanded(
                          child: MyButton(
                            size: 5,
                            text: 'Tambah User',
                            paddingSize: 15,
                            onTap: () { 
                                              
                              // check apakah
                              if (
                                usernameController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty &&
                                namaLengkapController.text.isNotEmpty &&
                                dateController.text.isNotEmpty &&
                                NoHPController.text.isNotEmpty &&
                                selectedAnswerNotifier.value != -1
                                ) {
                                firestoreService.cekKetersediaanUsername(usernameController.text).then((isTersedia) {
                                  if (isTersedia) {
                                    // Ambil tanggal dari dateController
                                    final tglLahir = DateTime.parse(dateController.text);
                                    // Buat objek Timestamp dari combinedDateTime
                                    final timestamp = Timestamp.fromDate(tglLahir);
                                    
                                    Profil userBaru = Profil(
                                      username: usernameController.text,
                                      password: passwordController.text,
                                      nama: namaLengkapController.text,
                                      tglLahir: timestamp,
                                      jenisKelamin: jenisKelamin[selectedAnswerNotifier.value],
                                      noHP: NoHPController.text,
                                      role: 'User'
                                    );
                                                  
                                    // add to db
                                    print('uploading... ');
                                    firestoreService.addUserByEvaluator(userBaru, usernameController.text);
                                    print('user terupload');
                                    
                                    MyBigPopUp.showAlertDialog(
                                      teks : 'User baru berhasil dibuat!',
                                      context: context,
                                    );
                                  } else {
                                    MySmallPopUp.showToast(message: 'Username sudah terpakai!');
                                  }
                                });
                              } else {
                                MySmallPopUp.showToast(message: 'Akun tidak valid!');
                              }
                            },
                          ),
                        ),
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