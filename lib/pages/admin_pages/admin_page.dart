import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/home_appbar.dart';
import '../../components/my_menu_card.dart';
import '../../models/profil.dart';
import '../../services/auth_service.dart';
import '../../services/firestore.dart';
import 'forms/soal_kognitif_umum_formpage.dart';
import 'forms/soal_umum_formpage.dart';
import '../common_pages/home_page.dart';
import 'list_user_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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
    setState(() {
      isLoading = true;
    });
    // String name = await firestoreService.getFullName();
    // // setState(() {
    // //   fullName = name;
    // // });

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
        Center(child: CircularProgressIndicator(),)
      : Scaffold(
      appBar: HomeAppbar(profil: userSaatIni!,),
      backgroundColor: Color(0xFF00cfd6),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FormSoalPGUmum())), 
                    text: 'Buat Soal PG Umum', 
                    size: 140,
                    cardIcon: Icon(Icons.list, size: 60,),
                  ),
                  
            
                  // buat soal kognitif umum
                  MyMenuCard(
                    onTap: () => 
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FormSoalKognitifUmum())), 
                    text: 'Buat Soal Kognitif Umum',
                    size: 140,
                    cardIcon: Icon(Icons.article, size: 60,),
                  ),
              
            
                  // buat soal video umum
                  MyMenuCard(
                    onTap: () => {}, 
                    text: 'Buat Soal Video Umum', 
                    size: 140,
                    cardIcon: Icon(Icons.videocam, size: 60,),
                  ),
              
            
                  // List Data Evaluator
                  MyMenuCard(
                    onTap: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ListUserPage(tipe: 'Evaluator'))), 
                    text: 'List Data Evaluator', 
                    size: 140,
                    cardIcon: Icon(Icons.account_box, size: 60,),
                  ),
              
            
                  // List Data User
                  MyMenuCard(
                    onTap: () => 
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ListUserPage(tipe: 'User'))), 
                    text: 'List Data User', 
                    size: 140,
                    cardIcon: Icon(Icons.people, size: 60,),
                  ),
              
                  const SizedBox(height: 40),
              
                  // balik
                  MyMenuCard(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())), 
                    text: 'Kembali', 
                    size: 140,
                    cardIcon: Icon(Icons.backspace, size: 60,),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // floatingActionButton: Container(
      //   width: 100,
      //   height: 100,
      //   // decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      //   child: FloatingActionButton(
      //     onPressed: () {}, 
      //     child: Icon(Icons.auto_graph, size: 40, ), 
      //     shape: CircleBorder(),
      //     backgroundColor: Color(0xFF68F1F6),
      //     foregroundColor: Colors.white,
      //   )
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: BottomAppBar(
      //   elevation: 0,
      //   // notchMargin: 5.0,
      //   // shape: CircularNotchedRectangle(),
      //   color: Colors.white,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: [
      //       IconButton(
      //         onPressed: () {}, 
      //         icon: Icon(Icons.home),
      //         highlightColor: Color(0xFF68F1F6),
      //       ),

      //       IconButton(
      //         onPressed: () {}, 
      //         icon: Icon(Icons.person),
      //         highlightColor: Color(0xFF68F1F6),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}