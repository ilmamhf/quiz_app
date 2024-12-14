import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/home_appbar.dart';
import '../../components/my_menu_card.dart';
import '../../models/profil.dart';
import '../../services/auth_service.dart';
import '../admin_pages/forms/soal_kognitif_umum_formpage.dart';
import '../admin_pages/forms/soal_umum_formpage.dart';
import '../admin_pages/list_user_page.dart';
import '../common_pages/home_page.dart';
import 'pilih_user_page.dart';
import 'tambah_user_page.dart';

class EvaluatorPage extends StatefulWidget {
  final Profil? userTerpilih;// Objek Profil opsional
  
  EvaluatorPage({
    super.key,
    this.userTerpilih,
  });

  @override
  State<EvaluatorPage> createState() => _EvaluatorPageState();
}

class _EvaluatorPageState extends State<EvaluatorPage> {

  final AuthService authService = AuthService();
  bool adaUser = false;
  Profil? userSaatIni = null;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getProfil();
  }

  Future<void> getProfil() async {
    // String name = await firestoreService.getFullName();
    // // setState(() {
    // //   fullName = name;
    // // });
    setState(() {
      isLoading = true;
    });

    Profil? profil = await authService.getProfilByUsername(FirebaseAuth.instance.currentUser!.email!);
    setState(() {
      userSaatIni = profil;
      isLoading = false;
    });
  }

  Future<bool> cekUser() async {
    if (widget.userTerpilih == null) {
      adaUser = false;
      return false;
    } else {
      setState(() {
        adaUser = true;
      });
      return true;
    }
  }
  // -------

  @override
  Widget build(BuildContext context) {

    Profil? userTermonitor = widget.userTerpilih;

    return isLoading ? 
        const Center(child: CircularProgressIndicator(),)
      : Scaffold(
      appBar: HomeAppbar(
        profil: userSaatIni!,
        actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            onPressed: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PilihUserPage()));
            },
            child: Text(userTermonitor == null ? "Pilih User" : "Ganti User", 
              style: const TextStyle(color: Colors.black),
            )
          )
        ),
      ],
      ),

      backgroundColor: const Color(0xFF00cfd6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: // Tampilkan teks berdasarkan kondisi
                        userTermonitor == null
                          ? const Text(
                              "Saat ini anda belum memilih user untuk dimonitor, silahkan gunakan tombol 'Pilih User' di kanan atas layar untuk memilih user",
                              style: TextStyle(fontSize: 14),
                            )
                          : Text(
                              'User terpilih: ${userTermonitor.nama}',
                        style: const TextStyle(fontSize: 18, color: Colors.green),
                      ),
                    ),
                  ),

                  Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                  
                      // buat soal pg Khusus
                      MyMenuCard(
                        onTap: userTermonitor != null 
                        ? () => 
                        Navigator.push(context, MaterialPageRoute(builder: (context) => 
                          FormSoalPGUmum(khusus: true, userTerpilihID: userTermonitor.username)))
                        : () {}, 
                        text: 'Buat Soal PG Khusus', 
                        size: 140,
                        cardIcon: const Icon(Icons.list, size: 60,),
                      ),
                      
                              
                      // buat soal kognitif Khusus
                      MyMenuCard(
                        onTap: userTermonitor != null 
                        ? () => 
                        Navigator.push(context, MaterialPageRoute(builder: (context) => 
                          FormSoalKognitifUmum(khusus: true, userTerpilihID: userTermonitor.username)))
                        : () {}, 
                        text: 'Buat Soal Kognitif Khusus',
                        size: 140,
                        cardIcon: const Icon(Icons.article, size: 60,),
                      ),
                  
                              
                      // buat soal video Khusus
                      MyMenuCard(
                        onTap: () => {}, 
                        text: 'Buat Soal Video Khusus', 
                        size: 140,
                        cardIcon: const Icon(Icons.videocam, size: 60,),
                      ),
                  
                              
                      // Tambah user
                      MyMenuCard(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TambahUserPage())), 
                        text: 'Tambah User', 
                        size: 140,
                        cardIcon: const Icon(Icons.group_add, size: 60,),
                      ),
                  
                              
                      // List Data User
                      MyMenuCard(
                        onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ListUserPage(tipe: 'User' , evaluatorID: FirebaseAuth.instance.currentUser!.uid))), 
                        text: 'List Data User', 
                        size: 140,
                        cardIcon: const Icon(Icons.people, size: 60,),
                      ),
                  
                      const SizedBox(height: 40),
                  
                      // balik
                      MyMenuCard(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage())), 
                        text: 'Kembali', 
                        size: 140,
                        cardIcon: const Icon(Icons.backspace, size: 60,),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}