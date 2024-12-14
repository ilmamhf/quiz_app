import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/home_appbar.dart';
import '../../components/my_menu_card.dart';
import '../../models/profil.dart';
import '../../services/auth_service.dart';
import 'forms/soal_kognitif_umum_formpage.dart';
import 'forms/soal_umum_formpage.dart';
// import '../common_pages/home_page.dart';
import 'forms/soal_video_page.dart';
import 'list_user_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final AuthService authService = AuthService();
  bool adaUser = false;
  Profil? userSaatIni;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getProfil();
  }

  Future<void> getProfil() async {
    setState(() {
      isLoading = true;
    });

    Profil? profil = await authService.getProfilByUsername(FirebaseAuth.instance.currentUser!.email!);
    setState(() {
      userSaatIni = profil;
      isLoading = false;
    });
  }
  // -------
  

  @override
  Widget build(BuildContext context) {
    return isLoading ? 
        const Center(child: const CircularProgressIndicator(),)
      : Scaffold(
      appBar: HomeAppbar(profil: userSaatIni!,),
      backgroundColor: const Color(0xFF00cfd6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: [
              
                  // buat soal umum
                  MyMenuCard(
                    onTap: () => 
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FormSoalPGUmum())), 
                    text: 'Buat Soal PG Umum', 
                    size: 140,
                    cardIcon: const Icon(Icons.list, size: 60,),
                  ),
                  
            
                  // buat soal kognitif umum
                  MyMenuCard(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const FormSoalKognitifUmum()));
                    },
                    text: 'Buat Soal Kognitif Umum',
                    size: 140,
                    cardIcon: const Icon(Icons.article, size: 60,),
                  ),
              
            
                  // buat soal video umum
                  MyMenuCard(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const FormSoalVideoUmum()));
                    },
                    text: 'Buat Soal Video Umum', 
                    size: 140,
                    cardIcon: const Icon(Icons.videocam, size: 60,),
                  ),
              
            
                  // List Data Evaluator
                  MyMenuCard(
                    onTap: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ListUserPage(tipe: 'Evaluator'))), 
                    text: 'List Data Evaluator', 
                    size: 140,
                    cardIcon: const Icon(Icons.account_box, size: 60,),
                  ),
              
            
                  // List Data User
                  MyMenuCard(
                    onTap: () => 
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ListUserPage(tipe: 'User'))), 
                    text: 'List Data User', 
                    size: 140,
                    cardIcon: const Icon(Icons.people, size: 60,),
                  ),
              
                  const SizedBox(height: 40),
              
                  // balik
                  MyMenuCard(
                    // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage())), 
                    onTap: () async {
                      await AuthService().signout(context: context);
                    },
                    text: 'Log Out', 
                    size: 140,
                    cardIcon: const Icon(Icons.backspace, size: 60,),
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