import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../components/my_appbar.dart';
import '../../components/my_button.dart';
import '../../components/my_form_row.dart';
import '../../components/my_textfield.dart';
import '../../components/sub_judul.dart';
import '../../components/user_data_display.dart';
import '../../models/profil.dart';
import '../../services/auth_service.dart';
import '../../services/firestore.dart';
import 'edit_profil_page.dart';

class ProfilPage extends StatefulWidget {
  // final bool userBiasa;
  final String userID;
  const ProfilPage(
      {super.key,
      // this.userBiasa = false,
      required this.userID});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final AuthService authService = AuthService();
  bool isLoading = false;

  String dateFormatter(timestamp) {
    DateTime date = timestamp.toDate(); // Konversi Timestamp ke DateTime
    return DateFormat('dd/MM/yyyy')
        .format(date); // Format DateTime ke dd/MM/yyyy
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Profil Akun',
        backButtonEnabled: false,
      ),
      backgroundColor: Color(0xFF00cfd6),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userID)
            .snapshots(),
        builder: (context, snapshot) {
          // Kondisi loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Kondisi jika data tidak ada
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return Center(
              child: Text(
                "Cek ulang koneksi",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          // Mendapatkan data pengguna
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          String nama = userData['Nama Lengkap'];
          String username =
              userData['userID']; // Pastikan field ini ada di Firestore
          Timestamp tglLahir =
              userData['Tanggal Lahir']; // Pastikan field ini ada di Firestore
          String jenisKelamin =
              userData['Jenis Kelamin']; // Pastikan field ini ada di Firestore
          String noHP =
              userData['No HP']; // Pastikan field ini ada di Firestore
          String role = userData['Role'];

          return SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MySubJudul(text: 'Akun :'),
                        const SizedBox(height: 20),
                        MyUserDataDisplay(
                          text1: 'Nama Akun',
                          text2: username,
                        ),
                        const SizedBox(height: 40),
                        MySubJudul(text: 'Profil :'),
                        const SizedBox(height: 20),
                        MyUserDataDisplay(
                          text1: 'Nama Lengkap',
                          text2: nama,
                        ),
                        const SizedBox(height: 20),
                        MyUserDataDisplay(
                          text1: 'Tanggal Lahir',
                          text2: dateFormatter(tglLahir), // Pastikan dateFormatter dapat menangani format yang benar
                        ),
                        const SizedBox(height: 20),
                        MyUserDataDisplay(
                          text1: 'Jenis Kelamin',
                          text2: jenisKelamin,
                        ),
                        const SizedBox(height: 20),
                        MyUserDataDisplay(
                          text1: 'No HP',
                          text2: noHP,
                        ),
                        const SizedBox(height: 20),
                        MyButton(
                          size: 5,
                          text: 'Edit profil',
                          onTap: () {
                            Profil userSaatIni = Profil(
                              nama: nama,
                              tglLahir: tglLahir,
                              jenisKelamin: jenisKelamin,
                              noHP: noHP,
                              role: role,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfilePage(
                                    profil:
                                        userSaatIni!), // Ganti dengan objek yang sesuai
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
