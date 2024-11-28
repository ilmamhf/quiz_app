import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/profil.dart';
import '../../../models/soal.dart';
import '../../../services/auth_service.dart';
import '../../../services/firestore.dart';

class SoalUmumQuiz extends StatefulWidget {
  final Profil? currentUser; // objek user sekarang
  final bool khusus;

  const SoalUmumQuiz({
    super.key, 
    this.currentUser,
    this.khusus = false,
  });

  @override
  State<SoalUmumQuiz> createState() => _SoalUmumQuizState();
}

class _SoalUmumQuizState extends State<SoalUmumQuiz> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService authService = AuthService();
  
  List<SoalPG> soal = [
    // Soal(
    //   // gambar: '',
    //   soal: "1 + 2?",
    //   listJawaban: ["1", "2", "3", "4"],
    //   jawabanBenar: "3",
    // ),

    // Soal(
    //   // gambar: '',
    //   soal: "3 + 2?",
    //   listJawaban: ["1", "5", "3", "4"],
    //   jawabanBenar: "5",
    // )
  ];

  PageController _controller = PageController();

  Map<int, String> userAnswers = {};
  int currentPageIndex = 0;

  void cekJawaban(int index, String jawabanUser) {
    setState(() {
      userAnswers[index] = jawabanUser;
    });
  }

    // Fungsi untuk mengambil soal dari Firestore
  Future<void> _fetchSoalUmum() async {
    List<SoalPG> fetchedSoalUmum = [];

    if (widget.khusus == false) {
      fetchedSoalUmum = await _firestoreService.fetchSoalPGUmum('umum');
    } else {
      // String currentEvaluatorID = 'hQH32HaSw0WVAZGh6AEyeBULS1c2';
      // String? currentUserID = widget.currentUser!.username;
      // String combinedUserID = currentEvaluatorID + currentUserID!;
      fetchedSoalUmum = await _firestoreService.fetchSoalPGUmum('tes collection user');
    }
    
    setState(() {
      soal = fetchedSoalUmum;
    });
  }


  @override
  void initState() {
    super.initState();
    _fetchSoalUmum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00CFD6),
      appBar: AppBar(
        title: Text("Quiz Umum"),
      ),
      body: soal.isEmpty
        ? Center(child: CircularProgressIndicator()) 
        : SafeArea(
        child: Center(
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2.0),
              color: Colors.white,
              borderRadius: BorderRadius.circular(16)
              ),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: soal.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentPageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return buildSoalPage(soal[index], index);
                    }
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: currentPageIndex > 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _controller.previousPage(
                              duration: Duration(milliseconds: 300), 
                              curve: Curves.easeInOut,
                            );
                          }, child: Text("Soal sebelumnya"),
                        ),
                      ),
                    ),
            
                    Visibility(
                      visible: currentPageIndex < soal.length - 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _controller.nextPage(
                              duration: Duration(milliseconds: 300), 
                              curve: Curves.easeInOut,
                            );
                          }, child: Text("Soal selanjutnya"),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSoalPage(SoalPG soal, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2.0),
          color: Colors.white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                soal.soal,
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center,
              ),
            ),
            ...soal.listJawaban.map((String jawaban) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => cekJawaban(index, jawaban),
                  child: Text(jawaban),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: BorderSide(color: Colors.grey)),
                    backgroundColor: userAnswers[index] == jawaban
                      ? Color(0xFF00CFD6)
                      : Colors.white
                  ),
                ),
              );
            }).toList(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                userAnswers[index] == null
                  ? ""
                  : userAnswers[index] == soal.jawabanBenar
                    ? "Benar!"
                    : "Salah!",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}