import 'package:flutter/material.dart';

import '../../../components/my_appbar.dart';
import '../../../components/my_form_row.dart';
import '../../../components/my_textfield.dart';
import '../../../models/profil.dart';
import '../../../models/soal.dart';
import '../../../services/auth_service.dart';
import '../../../services/firestore.dart';

class SoalKognitifQuiz extends StatefulWidget {
  final Profil? currentUser; // objek user sekarang
  final bool khusus;
  
  const SoalKognitifQuiz({
    super.key,
    this.currentUser,
    this.khusus = false,
  });

  @override
  State<SoalKognitifQuiz> createState() => _SoalKognitifQuizState();
}

class _SoalKognitifQuizState extends State<SoalKognitifQuiz> {
  
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService authService = AuthService();

  bool isLoading = false;
  
  List<SoalKognitif> soal = [];

  PageController _controller = PageController();

  // Map<int, String> userAnswers = {};
  int currentPageIndex = 0;

  // List<TextEditingController> soalControllers = [];
  List<TextEditingController> jawabanUserController = [];

    // Fungsi untuk mengambil soal dari Firestore
  Future<void> _fetchSoalUmum() async {
    setState(() {
      isLoading = true;
    });

    List<SoalKognitif> fetchedSoal = [];

    if (widget.khusus == false) {
      fetchedSoal = await _firestoreService.fetchSoalKognitifUmum('umum');
    } else {
      fetchedSoal = await _firestoreService.fetchSoalKognitifUmum(widget.currentUser!.evaluatorID! + widget.currentUser!.username!);
    }
    
    setState(() {
      soal = fetchedSoal;
      // soalControllers = List.generate(fetchedSoal.length, (index) => TextEditingController());
      jawabanUserController = List.generate(fetchedSoal.length, (index) => TextEditingController());

      // // Inisialisasi controller dengan data soal
      // for (int i = 0; i < fetchedSoal.length; i++) {
      //   // soalControllers[i].text = fetchedSoal[i].soal;
      //   jawabanUserController[i].text = fetchedSoal[i].jawabanBenar;
      // }
    });
    setState(() {
      isLoading = false;
    });
  }

  int totalSkor = 0; // Variabel untuk menyimpan total skor

  void hitungSkor() {
    totalSkor = 0; // Reset skor sebelum menghitung
    for (int i = 0; i < soal.length; i++) {
      if (jawabanUserController[i].text == soal[i].jawabanBenar) {
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
      appBar: MyAppBar(title: isKhusus ? 'Soal Kognitif Khusus' : 'Soal Kognitif Umum'),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : soal.isEmpty ? 
            Center(child: Text('Belum ada soal'))
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
                              tampilkanHasil(); // Panggil fungsi untuk menampilkan hasil
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

  Widget buildSoalPage(SoalKognitif soal, int index) {
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

              // jawaban user
              MyFormRow(
                labelText: 'Jawaban',
                myWidget: MyTextField(
                  controller: jawabanUserController[index],
                  hintText: 'Ketik jawaban benar di sini',
                  obscureText: false,
                  enabled: true,
                ),
              ),

              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}