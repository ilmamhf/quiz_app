import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../components/my_appbar.dart';
import '../../components/my_form_row.dart';
import '../../components/my_textfield.dart';
import '../../components/sub_judul.dart';
import '../../components/user_data_display.dart';
import '../../models/profil.dart';
import '../../services/firestore.dart';

class ProfilPage extends StatefulWidget {
  // final String userID;
  final Profil profil;
  const ProfilPage({
    super.key,
    // required this.userID,
    required this.profil
  });

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  // final FirestoreService _firestoreService = FirestoreService();

  bool isLoading = false;
  TextEditingController namaController = TextEditingController();
  // Profil? user = profil;

  String dateFormatter(timestamp){
    DateTime date = timestamp.toDate(); // Konversi Timestamp ke DateTime
  return DateFormat('dd/MM/yyyy').format(date); // Format DateTime ke dd/MM/yyyy
  }

  //  // Fungsi untuk mengambil user dari Firestore
  // Future<void> _fetchListUser() async {

  //   setState(() {
  //     isLoading = true;
  //   });

  //   Profil? fetchedUser = await _firestoreService.fetchCurrentUserProfile(widget.userID);
    
  //   setState(() {
  //     user = fetchedUser;
  //     isLoading = false;
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchListUser();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Profil Akun', backButtonEnabled: false,),
      backgroundColor: Color(0xFF00cfd6),

      // isLoading
      //     ? Center(child: CircularProgressIndicator()) // Kondisi loading
      //   : user == null
      //     ? Center(child: Text("Cek ulang koneksi", style: TextStyle(color: Colors.white),),) // Kondisi kosong
      //   : 
      
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  // judul
                  // Text(
                  //   "User ${index + 1}",
                  //   style: TextStyle(fontSize: 60.0),
                  //   textAlign: TextAlign.center,
                  // ),
                
                  // SizedBox(height: 20.0,),
                
                  MySubJudul(text: 'Akun :',),
                
                  const SizedBox(height: 20),
                
                  // username
                  // nama
                  MyUserDataDisplay(
                    text1: 'Nama Akun',
                    text2: widget.profil.username!,
                  ),
                
                  // const SizedBox(height: 5),
                
                  // // password
                  // MyUserDataDisplay(
                  //   text1: 'Password',
                  //   text2: user!.password!
                  // ),
                
                  const SizedBox(height: 40),
                
                  MySubJudul(text: 'Profil :',),
                
                  const SizedBox(height: 20),
                    
                  // nama
                  MyUserDataDisplay(
                    text1: 'Nama Lengkap',
                    text2: widget.profil.nama,
                  ),

                  // nama
                  // Transform.scale(
                  //   scale: 1,
                  //   child: MyFormRow(
                  //     labelText: 'Nama',
                  //     myWidget: MyTextField(
                  //       controller: namaController,
                  //       hintText: widget.profil.nama,
                  //       obscureText: false,
                  //       enabled: false,
                  //     ),
                  //   ),
                  // ),
                    
                  const SizedBox(height: 20),
                
                  // tgl lahir
                  MyUserDataDisplay(
                    text1: 'Tanggal Lahir', 
                    text2: dateFormatter(widget.profil.tglLahir)
                  ),
                    
                  const SizedBox(height: 20),
                    
                  // Jenis Kelamin
                  MyUserDataDisplay(
                    text1: 'Jenis Kelamin', 
                    text2: widget.profil.jenisKelamin
                  ),
                    
                  const SizedBox(height: 20),
                    
                  // No HP
                  MyUserDataDisplay(
                    text1: 'No HP', 
                    text2: widget.profil.noHP
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