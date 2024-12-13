import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../components/big_popup.dart';
import '../../components/loading_popup.dart';
import '../../components/my_appbar.dart';
import '../../components/my_button.dart';
import '../../components/my_form_row.dart';
import '../../components/my_image_picker.dart';
import '../../components/my_textfield.dart';
import '../../components/network_image.dart';
import '../../components/page_navigator_button.dart';
import '../../components/soal_crud_button.dart';
import '../../models/soal.dart';
import '../../services/auth_service.dart';
import '../../services/cloudinary.dart';
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
  File? newImage;

  List<TextEditingController> soalControllers = [];
  List<TextEditingController> jawabanBenarControllers = [];
  List<String> gambarControllers = [];
  List<bool> gambarDariInternet = [];
  
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
      print('kosong');
    } else {
      setState(() {
      soal = fetchedSoal;
      soalControllers = List.generate(fetchedSoal.length, (index) => TextEditingController());
      jawabanBenarControllers = List.generate(fetchedSoal.length, (index) => TextEditingController());
      gambarDariInternet = List.generate(fetchedSoal.length, (index) => bool() = false);
      gambarControllers = List.generate(fetchedSoal.length, (index) => String() = '');

      // Inisialisasi controller dengan data soal
      for (int i = 0; i < fetchedSoal.length; i++) {
        soalControllers[i].text = fetchedSoal[i].soal;
        jawabanBenarControllers[i].text = fetchedSoal[i].jawabanBenar;
        // gambarControllers[i].text = fetchedSoal[i].gambar;
        if (fetchedSoal[i].gambar.isNotEmpty) {
          gambarDariInternet[i] = true;
          gambarControllers[i] = fetchedSoal[i].gambar;
        }
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
    // Tampilkan dialog loading
    LoadingDialog.show(context);

    String? linkGambar;

    try {

      if (gambarDariInternet[index] == false) {
        gambarControllers[index] = ''; // kondisi kalo gapake gambar
        if (newImage != null) {
          // upload gambar ke cloudinary
          linkGambar = await uploadToCloudinary(newImage);
          if (linkGambar == null) {
            throw Exception('Gagal upload'); // otomatis langsung keluar dari try
          } else {
            gambarDariInternet[index] = true;
            gambarControllers[index] = linkGambar;
          }
        }
      } else {
        linkGambar = gambarControllers[index];
      }

      print(linkGambar);
      
      // Buat objek soal baru dengan data yang telah diubah
      SoalKognitif updatedSoal = SoalKognitif(
        id: soal.id, // Pastikan untuk menyertakan ID
        soal: soalControllers[index].text,
        jawabanBenar: jawabanBenarControllers[index].text,
        gambar: linkGambar ?? '',
      );
      print(updatedSoal.gambar);

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

      // exit dialog loading
      LoadingDialog.hide(context);
      MyBigPopUp.showAlertDialog(context: context, teks: 'Soal berhasil diperbarui!');
    } catch (e) {
      // exit dialog loading
      LoadingDialog.hide(context);
      MyBigPopUp.showAlertDialog(context: context, teks: 'Gagal upload!');
    }
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

    return Scaffold(
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
                      height: screenHeight * 6/9,
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
    );
  }

  Widget buildSoalPage(SoalKognitif soal, int index) { // page untuk pageview builder

    // bool gambarDariInternet = soal.gambar.isNotEmpty;
    String imageUrl = soal.gambar;

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
              labelText: 'Soal',
              myWidget: MyTextField(
                controller: soalControllers[index],
                hintText: 'Ketik soal di sini',
                obscureText: false,
                enabled: canEdit,
              ),
            ),
            const SizedBox(height: 5),
      
            // gambar
            MyFormRow(
              labelText: "Gambar", 
              myWidget: 
                gambarDariInternet[index] ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyNetworkImage(
                        imageUrl: imageUrl,
                      ),
                    ),
                    canEdit ?
                      MyButton(
                        text: 'Hapus',
                        size: 5,
                        fontSize: 12,
                        onTap: () {
                          setState(() {
                            imageUrl = '';
                            gambarDariInternet[index] = false;
                          });
                          print('gambar terhapus');
                        },
                      )
                    : SizedBox.shrink()
                  ],
                )
              : canEdit ? MyImagePicker(
                onImageSelected: (File? image) {
                  setState(() {
                    newImage = image;
                  });
                },
              ) : SizedBox.shrink()
            ),
            
            const SizedBox(height: 5),
            
            // jawaban benar

            MyFormRow(
              labelText: 'Jawaban Benar',
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
              deleteFunc: () {_deleteSoal(soal.id); newImage = null;},
              editFunc: () {_editSoal(soal); print(soal.gambar); print(gambarControllers[index]); print(gambarDariInternet[index].toString()); newImage = null;},
              batalFunc: () {
                //balikkan value
                soalControllers[index].text = soal.soal;
                jawabanBenarControllers[index].text = soal.jawabanBenar;
                if (soal.gambar.isNotEmpty) {
                  setState(() {
                    gambarDariInternet[index] = true;
                  });
                }
                newImage = null;
                _exitEdit();
              },
              simpanFunc: () {
                _saveSoal(soal, index);
                // print(gambarDariInternet[index].toString());
                newImage = null;
              },
            ),
          ],
        ),
      ),
    );
  }
}