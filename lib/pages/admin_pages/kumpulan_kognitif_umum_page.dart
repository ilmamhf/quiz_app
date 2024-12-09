import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../components/big_popup.dart';
import '../../components/my_appbar.dart';
import '../../components/my_form_row.dart';
import '../../components/my_image_picker.dart';
import '../../components/my_textfield.dart';
import '../../components/page_navigator_button.dart';
import '../../components/soal_crud_button.dart';
import '../../models/soal.dart';
import '../../services/auth_service.dart';
import '../../services/firestore.dart';
import 'forms/soal_video_page.dart';

class KumpulanSoalKognitifPage extends StatefulWidget {
  final String? userTerpilihID;// nama user opsional
  final bool khusus;

  const KumpulanSoalKognitifPage({
    super.key,
    this.userTerpilihID, 
    this.khusus = false,
  });

  @override
  State<KumpulanSoalKognitifPage> createState() => _KumpulanSoalKognitifPageState();
}

class _KumpulanSoalKognitifPageState extends State<KumpulanSoalKognitifPage> {
  
  final FirestoreService firestoreService = FirestoreService();
  final AuthService authService = AuthService();
  
  List<SoalKognitif> soal = [];

  PageController _controller = PageController();
  int currentPageIndex = 0;

  List<TextEditingController> soalControllers = [];
  List<TextEditingController> jawabanBenarControllers = [];
  List<TextEditingController> gambarControllers = [];
  
  bool canEdit = false;

  @override
  void initState() {
    super.initState();
    _fetchSoal();
  }

  Future<void> _fetchSoal() async {
    setState(() {
      isLoading = true;
    });

    List<SoalKognitif> fetchedSoal = [];

    if (widget.khusus == false) {
      fetchedSoal = await firestoreService.fetchSoalKognitifUmum('umum');
    } else {
      String? currentEvaluatorID = await authService.getCurrentFirebaseUserID();
      String combinedUserID = currentEvaluatorID! + widget.userTerpilihID!;

      fetchedSoal = await firestoreService.fetchSoalKognitifUmum(combinedUserID);
    }

    if (fetchedSoal.isEmpty) {
      print('kosnng');
    } else {
      setState(() {
      soal = fetchedSoal;
      soalControllers = List.generate(fetchedSoal.length, (index) => TextEditingController());
      jawabanBenarControllers = List.generate(fetchedSoal.length, (index) => TextEditingController());
      gambarControllers = List.generate(fetchedSoal.length, (index) => TextEditingController());

      // Inisialisasi controller dengan data soal
      for (int i = 0; i < fetchedSoal.length; i++) {
        soalControllers[i].text = fetchedSoal[i].soal;
        jawabanBenarControllers[i].text = fetchedSoal[i].jawabanBenar;
        gambarControllers[i].text = fetchedSoal[i].gambar;
      }
    });
    }
    
    setState(() {
      isLoading = false;
    });
  }

  void _deleteSoal(String soalId) async {
    if (widget.khusus == false) {
      await firestoreService.deleteSoalKognitifUmum(soalId, 'umum');
    } else {
      String? currentEvaluatorID = await authService.getCurrentFirebaseUserID();
      String combinedUserID = currentEvaluatorID! + widget.userTerpilihID!;

      await firestoreService.deleteSoalKognitifUmum(soalId, combinedUserID);
    }
    
    Fluttertoast.showToast(
      msg: "Soal berhasil dihapus",
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    _fetchSoal(); // Refresh soal setelah dihapus
  }

  void _saveSoal(SoalKognitif soal, int index) async {
    // Buat objek soal baru dengan data yang telah diubah
    SoalKognitif updatedSoal = SoalKognitif(
      id: soal.id, // Pastikan untuk menyertakan ID
      soal: soalControllers[index].text,
      jawabanBenar: jawabanBenarControllers[index].text,
    );

    // Panggil fungsi untuk memperbarui soal di Firestore
    if (widget.khusus == false) {
      await firestoreService.updateSoalKognitifUmum(updatedSoal, 'umum');
    } else {
      String? currentEvaluatorID = await authService.getCurrentFirebaseUserID();
      String combinedUserID = currentEvaluatorID! + widget.userTerpilihID!;
      await firestoreService.updateSoalKognitifUmum(updatedSoal, combinedUserID);
    }

    // Perbarui data lokal
    setState(() {
      _saveLocal(updatedSoal, index);
      canEdit = false;
    });
  }

  void _editSoal(SoalKognitif soal) {
    setState(() {
      canEdit = true;
    });
  }

  void _saveLocal(SoalKognitif soalBaru, int index) {
    soal[index] = soalBaru;
  }

  void _exitEdit() {
    setState(() {
      canEdit = false;
    });
  }
  
  bool isLoading = true;
  
  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.sizeOf(context).height;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FormSoalVideoUmum()));
      },
      child: Scaffold(
        backgroundColor: Color(0xFF00cfd6),
        resizeToAvoidBottomInset: false,
      
        appBar: MyAppBar(title: "Kumpulan Soal",),
        body: isLoading
            ? Center(child: CircularProgressIndicator()) // Kondisi loading
          : soal.isEmpty
            ? Center(child: Text("Tidak ada soal", style: TextStyle(color: Colors.white),),) // Kondisi kosong
          : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  
                      // kotak soal
                      Container(
                        // color: Color(0xFF68F1F6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                        ),
                        height: screenHeight * 2/4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PageView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _controller,
                            itemCount: soal.length,
                            onPageChanged: (index) {
                              setState(() {
                                currentPageIndex = index;
                              });
                              // matikan editing
                              _exitEdit();
                              print(soal[index].soal);
                            },
                            itemBuilder: (context, index) {
                              return buildSoalPage(soal[index], index);
                            },
                          ),
                        ),
                      ),
                  
                      // tombol ke soal sebelum dan selanjutnya
                      MyPageNavigatorButton(
                        canEdit: canEdit,
                        currentPageIndex: currentPageIndex,
                        pageLength: soal.length,
                        pagesController: _controller,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget buildSoalPage(SoalKognitif soal, int index) {
    return SingleChildScrollView(
      child: Container(
        // constraints: BoxConstraints(minHeight: 450),
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.black, width: 2.0),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // judul
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Soal ${index + 1}",
                // "Soal ${index + 1}: ${soal.soal}",
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ),
      
            // soal
            
            MyFormRow(
              labelText: 'Soal : ',
              myWidget: MyTextField(
                controller: soalControllers[index],
                hintText: 'Ketik soal di sini',
                obscureText: false,
                enabled: canEdit,
              ),
            ),
      
            // gambar
            // cek dulu ada gambarnya ga?
            // kalo gaada widget myimagepicker langsung
            // kalo ada widget network image, (kalo masuk edit mode muncul tombol hapus, langsung muncul widget myimagepicker)
            // kalo edit trus batal ganti lagi ke widget network image
            // MyFormRow(
            //   labelText: "Gambar", 
            //   myWidget: MyImagePicker(
            //     onImageSelected: (File? image) {
            //       setState(() {
            //         _selectedImage = image;
            //       });
            //     },
            //   ),
            // ),
            
            const SizedBox(height: 5),
            
            // jawaban benar

            MyFormRow(
              labelText: 'Jawaban Benar : ',
              myWidget: MyTextField(
                controller: jawabanBenarControllers[index],
                hintText: 'Ketik jawaban benar di sini',
                obscureText: false,
                enabled: canEdit,
              ),
            ),
          
            const SizedBox(height: 20),

            // edit, hapus, batal, simpan
            MySoalCRUDButton(
              canEdit: canEdit,
              deleteFunc: () {_deleteSoal(soal.id);},
              editFunc: () {_editSoal(soal);},
              batalFunc: () {
                //balikkan value
                soalControllers[index].text = soal.soal;
                jawabanBenarControllers[index].text = soal.jawabanBenar;
                _exitEdit();
              },
              simpanFunc: () {_saveSoal(soal, index);},
            ),
          ],
        ),
      ),
    );
  }
}