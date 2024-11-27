import 'package:flutter/material.dart';

import '../../components/my_menu_card.dart';
import '../../services/firestore.dart';
import 'forms/soal_kognitif_umum_formpage.dart';
import 'forms/soal_umum_formpage.dart';
import '../start_pages/home_page.dart';
import 'list_user_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // get nama----
  String fullName = 'loading..';
  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    getFullName();
  }

  Future<void> getFullName() async {
    String name = await firestoreService.getFullName();
    setState(() {
      fullName = name;
    });
  }
  // -------
  

  @override
  Widget build(BuildContext context) {
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

                Text(fullName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)
              ],
            ),

            const SizedBox(width: 14),

            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                child: Text('Admin', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
              ),
              decoration: BoxDecoration(
                color: Color(0xFF99FCFF),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), offset: Offset(0, 0), blurRadius: 4, spreadRadius: 2)]
              ),
            )
          ],
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(16.0),
        //     child: Container(
        //       decoration: BoxDecoration(
        //       color: Colors.white,
        //       shape: BoxShape.circle,
        //       boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), offset: Offset(0, 3), blurRadius: 4, spreadRadius: 1)],
        //     ),
        //       child: IconButton(
        //         color: Colors.white, 
        //         icon: Icon(Icons.notifications, color: Colors.black,), 
        //         onPressed: () {  },
        //         highlightColor: Colors.grey.withOpacity(0.2),
        //       ),
        //     ),
        //   ),
        // ],
      ),
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
                    onTap: () => {}, 
                    text: 'List Data Evaluator', 
                    size: 140,
                    cardIcon: Icon(Icons.account_box, size: 60,),
                  ),
              
            
                  // List Data User
                  MyMenuCard(
                    onTap: () => 
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ListUserPage())), 
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