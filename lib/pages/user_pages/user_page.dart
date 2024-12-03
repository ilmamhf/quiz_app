import 'package:flutter/material.dart';

import '../../components/my_button.dart';
import '../../components/my_menu_card.dart';
import '../../models/profil.dart';
import '../../services/auth_service.dart';
import '../start_pages/home_page.dart';
import '../start_pages/login_page.dart';
import 'tests/soal_kognitif_quiz.dart';
import 'tests/soal_umum_quiz.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

final AuthService authService = AuthService();

// Future<void> _fetchProfil() async {
//   // ambil profil disini
//   Profil? profil = await authService.getProfilByUsername(username);
// }

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
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });
      return Container(); // Kembalikan widget kosong saat menunggu navigasi
    }
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00cfd6),
        toolbarHeight: 100,
        leadingWidth: 100,
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        // bottom: PreferredSize(
        //   preferredSize: const Size.fromHeight(4.0),
        //   child: Container(
        //       color: Color(0xAF00A8AD),
        //       height: 1.0,
        //   )),
        leading: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, size: 40,)),
        ),
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Halo👋', style: TextStyle(fontSize: 14),),

                const SizedBox(height: 5),

                Text(profil.nama, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)
              ],
            ),

            const SizedBox(width: 14),

            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                child: Text('User', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
              ),
              decoration: BoxDecoration(
                color: Color(0xFF99FCFF),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), offset: Offset(0, 0), blurRadius: 4, spreadRadius: 2)]
              ),
            )
          ],
        ),
      ),
      backgroundColor: Color(0xFF00cfd6),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SoalUmumQuiz())),
                        text: 'Soal PG Umum', 
                        size: 140,
                        cardIcon: Icon(Icons.list, size: 60,),
                      ),
                      
                              
                      // soal kognitif umum
                      MyMenuCard(
                        onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SoalKognitifQuiz())),
                        text: 'Soal Kognitif Umum',
                        size: 140,
                        cardIcon: Icon(Icons.article, size: 60,),
                      ),
                  
                              
                      // soal video umum
                      MyMenuCard(
                        onTap: () => {}, 
                        text: 'Soal Video Umum', 
                        size: 140,
                        cardIcon: Icon(Icons.videocam, size: 60,),
                      ),
                  
                              
                      // soal pg Khusus
                      MyMenuCard(
                        onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SoalUmumQuiz(currentUser: profil, khusus: true,))),
                        text: 'Soal PG Khusus', 
                        size: 140,
                        cardIcon: Icon(Icons.list, size: 60,),
                      ),
                      
                              
                      // soal kognitif umum
                      MyMenuCard(
                        onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SoalKognitifQuiz(currentUser: profil, khusus: true,))),
                        text: 'Soal Kognitif Khusus',
                        size: 140,
                        cardIcon: Icon(Icons.article, size: 60,),
                      ),
                  
                              
                      // soal video umum
                      MyMenuCard(
                        onTap: () => {}, 
                        text: 'Soal Video Khusus', 
                        size: 140,
                        cardIcon: Icon(Icons.videocam, size: 60,),
                      ),
                  
                      // balik
                      MyMenuCard(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())), 
                        text: 'Kembali', 
                        size: 140,
                        cardIcon: Icon(Icons.backspace, size: 60,),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      floatingActionButton: Container(
        width: 100,
        height: 100,
        // decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: FloatingActionButton(
          onPressed: () {}, 
          child: Icon(Icons.auto_graph, size: 40, ), 
          shape: CircleBorder(),
          backgroundColor: Color(0xFF68F1F6),
          foregroundColor: Colors.white,
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        // notchMargin: 5.0,
        // shape: CircularNotchedRectangle(),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {}, 
              icon: Icon(Icons.home),
              highlightColor: Color(0xFF68F1F6),
            ),

            IconButton(
              onPressed: () {}, 
              icon: Icon(Icons.person),
              highlightColor: Color(0xFF68F1F6),
            ),
          ],
        ),
      ),
    );
  }
}