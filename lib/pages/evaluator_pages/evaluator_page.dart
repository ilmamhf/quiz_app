import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/my_menu_card.dart';
import '../../models/profil.dart';
import '../../services/firestore.dart';
import '../admin_pages/forms/soal_kognitif_umum_formpage.dart';
import '../admin_pages/forms/soal_umum_formpage.dart';
import '../admin_pages/list_user_page.dart';
import '../start_pages/home_page.dart';
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

    // get nama----
  String fullName = 'loading..';
  final FirestoreService firestoreService = FirestoreService();
  bool adaUser = false;

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

  Future<bool> cekUser() async {
    if (widget.userTerpilih == null) {
      adaUser = false;
      return false;
    } else {
      setState(() {
        adaUser = true;
      });
      return true;
    };
  }
  // -------

  @override
  Widget build(BuildContext context) {

    Profil? userTermonitor = widget.userTerpilih;

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
                child: Text('Evaluator', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
              ),
              decoration: BoxDecoration(
                color: Color(0xFF99FCFF),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), offset: Offset(0, 0), blurRadius: 4, spreadRadius: 2)]
              ),
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
              onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PilihUserPage()));
              },
              child: Text(userTermonitor == null ? "Pilih User" : "Ganti User", 
                style: TextStyle(color: Colors.black),
              )
            )
          ),
        ],
      ),
      backgroundColor: Color(0xFF00cfd6),
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
                          ? Text(
                              "Saat ini anda belum memilih user untuk dimonitor, silahkan gunakan tombol 'Pilih User' di kanan atas layar untuk memilih user",
                              style: TextStyle(fontSize: 14),
                            )
                          : Text(
                              'User terpilih: ${userTermonitor.nama}',
                        style: TextStyle(fontSize: 18, color: Colors.green),
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
                        cardIcon: Icon(Icons.list, size: 60,),
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
                        cardIcon: Icon(Icons.article, size: 60,),
                      ),
                  
                              
                      // buat soal video Khusus
                      MyMenuCard(
                        onTap: () => {}, 
                        text: 'Buat Soal Video Khusus', 
                        size: 140,
                        cardIcon: Icon(Icons.videocam, size: 60,),
                      ),
                  
                              
                      // Tambah user
                      MyMenuCard(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TambahUserPage())), 
                        text: 'Tambah User', 
                        size: 140,
                        cardIcon: Icon(Icons.group_add, size: 60,),
                      ),
                  
                              
                      // List Data User
                      MyMenuCard(
                        onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ListUserPage(tipe: 'User' , evaluatorID: FirebaseAuth.instance.currentUser!.uid))), 
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