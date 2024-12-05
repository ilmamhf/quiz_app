import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../components/my_appbar.dart';
import '../../../models/profil.dart';
import '../../../models/soal.dart';
import '../../../services/auth_service.dart';
import '../../../services/firestore.dart';
import '../nilai_page.dart';

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

  bool isLoading = false;
  
  List<SoalPG> soal = [];

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
    setState(() {
      isLoading = true;
    });

    List<SoalPG> fetchedSoalUmum = [];

    if (widget.khusus == false) {
      fetchedSoalUmum = await _firestoreService.fetchSoalPGUmum('umum');
    } else {
      // String currentEvaluatorID = 'hQH32HaSw0WVAZGh6AEyeBULS1c2';
      // String? currentUserID = widget.currentUser!.username;
      // String combinedUserID = currentEvaluatorID + currentUserID!;
      fetchedSoalUmum = await _firestoreService.fetchSoalPGUmum(widget.currentUser!.evaluatorID! + widget.currentUser!.username!);
    }
    
    setState(() {
      soal = fetchedSoalUmum;
    });
    setState(() {
      isLoading = false;
    });
  }

  int totalSkor = 0; // Variabel untuk menyimpan total skor

  void hitungSkor() {
    totalSkor = 0; // Reset skor sebelum menghitung
    for (int i = 0; i < soal.length; i++) {
        print(userAnswers[i]);
        print(soal[i].jawabanBenar);
      if (userAnswers[i] == soal[i].jawabanBenar) {
        totalSkor++;
      }
    }
  }

  void tampilkanHasil() {
    hitungSkor(); // Hitung skor sebelum menampilkan hasil
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Hasil Quiz"),
          content: Text("Total Skor: $totalSkor/${soal.length}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchSoalUmum();
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.sizeOf(context).height;
    bool isKhusus = widget.khusus;

    return Scaffold(
      backgroundColor: Color(0xFF00CFD6),
      appBar: MyAppBar(title: isKhusus ? 'Soal Pilihan Ganda Khusus' : 'Soal Pilihan Ganda Umum'),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : soal.isEmpty ? 
            Center(child: Text('Belum ada soal', style: TextStyle(color: Colors.white),))
            : SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: screenHeight * 9/13,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  soal.length > 0
                    ? Text("Soal ke ${currentPageIndex+1} dari ${soal.length} soal", 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                        ),
                      )
                    : SizedBox.shrink(),
                    
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
                        visible: true,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF00A8AD),
                            ),
                            onPressed: currentPageIndex > 0 ? () {
                              _controller.previousPage(
                                duration: Duration(milliseconds: 1),
                                curve: Curves.linear,
                              ); 
                            } : null, 
                            child: Text("Soal sebelumnya"),
                          ),
                        ),
                      ),
              
                      currentPageIndex != soal.length - 1 ? Visibility(
                        visible: currentPageIndex < soal.length - 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF00A8AD),
                            ),
                            onPressed: currentPageIndex < soal.length - 1 ? () {
                              _controller.nextPage(
                                duration: Duration(milliseconds: 1),
                                curve: Curves.linear,
                              ); 
                            } : null, 
                            child: Text("Soal Selanjutnya"),
                          ),
                        ),
                      ) : 
                      Visibility(
                        visible: currentPageIndex == soal.length - 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF00A8AD),
                            ),
                            onPressed: () {
                              // tampilkanHasil(); // Panggil fungsi untuk menampilkan hasil
                              hitungSkor();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => 
                                NilaiPage(jawabanBenar: totalSkor, jumlahSoal: soal.length)));
                            }, child: Text("Selesai"),
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
      ),
    );
  }

  Widget buildSoalPage(SoalPG soal, int index) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.black, width: 2.0),
            color: Colors.white,
            borderRadius: BorderRadius.circular(14)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  // color: Colors.red,
                  child: Text(
                    soal.soal,
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              ...soal.listJawaban.map((String jawaban) {
                return Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () => cekJawaban(index, jawaban),
                      child: Text(jawaban, style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.grey)),
                        backgroundColor: userAnswers[index] == jawaban
                          ? Color(0xFF00CFD6)
                          : Colors.white
                      ),
                    ),
                  ),
                );
              }).toList(),
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Text(
              //     userAnswers[index] == null
              //       ? ""
              //       : userAnswers[index] == soal.jawabanBenar
              //         ? "Benar!"
              //         : "Salah!",
              //     style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              //     textAlign: TextAlign.center,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}