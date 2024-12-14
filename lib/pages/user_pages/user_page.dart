import 'package:flutter/material.dart';

import '../../components/home_appbar.dart';
import '../../components/my_menu_card.dart';
import '../../models/profil.dart';
import '../../services/auth_service.dart';
import '../common_pages/login_page.dart';
import 'tests/soal_kognitif_quiz.dart';
import 'tests/soal_umum_quiz.dart';
import 'tests/soal_video_quiz.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

final AuthService authService = AuthService();

class _UserPageState extends State<UserPage> {

  @override
  Widget build(BuildContext context) {

    // Mengambil data yang dikirim melalui arguments
    final Profil? profil = ModalRoute.of(context)!.settings.arguments as Profil?;

    // Cek jika profil null dan arahkan ke halaman login
    if (profil == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
      return Container(); // Kembalikan widget kosong saat menunggu navigasi
    }
    
    return Scaffold(
      appBar: HomeAppbar(profil: profil,),
      backgroundColor: const Color(0xFF00cfd6),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                  
                      // soal pg umum
                      MyMenuCard(
                        onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SoalUmumQuiz())),
                        text: 'Soal PG Umum', 
                        size: 140,
                        cardIcon: const Icon(Icons.list, size: 60,),
                      ),
                      
                              
                      // soal kognitif umum
                      MyMenuCard(
                        onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SoalKognitifQuiz())),
                        text: 'Soal Kognitif Umum',
                        size: 140,
                        cardIcon: const Icon(Icons.article, size: 60,),
                      ),
                  
                              
                      // soal video umum
                      MyMenuCard(
                        onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SoalVideoQuiz())), 
                        text: 'Soal Video Umum', 
                        size: 140,
                        cardIcon: const Icon(Icons.videocam, size: 60,),
                      ),
                  
                              
                      // soal pg Khusus
                      MyMenuCard(
                        onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SoalUmumQuiz(currentUser: profil, khusus: true,))),
                        text: 'Soal PG Khusus', 
                        size: 140,
                        cardIcon: const Icon(Icons.list, size: 60,),
                      ),
                      
                              
                      // soal kognitif khusus
                      MyMenuCard(
                        onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SoalKognitifQuiz(currentUser: profil, khusus: true,))),
                        text: 'Soal Kognitif Khusus',
                        size: 140,
                        cardIcon: const Icon(Icons.article, size: 60,),
                      ),
                  
                              
                      // soal video khusus
                      MyMenuCard(
                        onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SoalVideoQuiz(currentUser: profil, khusus: true,))), 
                        text: 'Soal Video Khusus', 
                        size: 140,
                        cardIcon: const Icon(Icons.videocam, size: 60,),
                      ),
                  
                      // balik
                      MyMenuCard(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage())), 
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
    );
  }
}