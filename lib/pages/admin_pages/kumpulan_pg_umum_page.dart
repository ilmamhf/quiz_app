import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../models/soal.dart';
import '../../../services/firestore.dart';
import '../../components/big_popup.dart';
import '../../components/loading_popup.dart';
import '../../components/my_appbar.dart';
import '../../components/my_button.dart';
import '../../components/my_checkbox_row.dart';
import '../../components/my_form_row.dart';
import '../../components/my_image_picker.dart';
import '../../components/my_textfield.dart';
import '../../components/network_image.dart';
import '../../components/page_navigator_button.dart';
import '../../components/soal_crud_button.dart';
import '../../services/auth_service.dart';
import '../../services/cloudinary.dart';

class KumpulanSoalPage extends StatefulWidget {
  final String? userTerpilihID;// nama user opsional
  final bool khusus;

  const KumpulanSoalPage({Key? key, 
  this.userTerpilihID, 
  this.khusus = false}) 
  : super(key: key);

  @override
  State<KumpulanSoalPage> createState() => _KumpulanSoalPageState();
}

class _KumpulanSoalPageState extends State<KumpulanSoalPage> {
  final FirestoreService firestoreService = FirestoreService();
  final AuthService authService = AuthService();
  bool isLoading = false;
  
  List<SoalPG> soal = [];
  PageController _controller = PageController();
  int currentPageIndex = 0;

  final gambarController = TextEditingController();
  List<String> listJawaban = ['', '', '', ''];
  List<String> abcd = ['A', 'B', 'C', 'D'];

  bool isChecked = false;

  List<TextEditingController> soalControllers = [];
  List<List<TextEditingController>> jawabanControllers = [];
  List<TextEditingController> jawabanBenarControllers = [];
  List<ValueNotifier<int>> selectedAnswerNotifiers = [];

  int originalSelectedAnswer = 0;

  bool canEdit = false;

  File? newImage;
  List<String> gambarControllers = [];
  List<bool> gambarDariInternet = [];

  @override
  void dispose() {
    // Bebaskan semua controller
    for (var controller in soalControllers) {
      controller.dispose();
    }
    for (var controller in jawabanBenarControllers) {
      controller.dispose();
    }
    for (var jawabanList in jawabanControllers) {
      for (var controller in jawabanList) {
        controller.dispose();
      }
    }
    for (var notifier in selectedAnswerNotifiers) {
      notifier.dispose(); // Bebaskan ValueNotifier
    }
    // Bebaskan PageController
    _controller.dispose();
    // Bebaskan gambarController
    gambarController.dispose();
    super.dispose(); // Panggil super.dispose() di akhir
  }

  @override
  void initState() {
    super.initState();
    _fetchSoal();
  }

  Future<void> _fetchSoal() async {
    setState(() {
      isLoading = true;
    });

    List<SoalPG> fetchedSoal = [];
    print(widget.khusus);
    if (widget.khusus == false) {
      fetchedSoal = await firestoreService.fetchSoalPGUmum('umum');
    } else {
      String? currentEvaluatorID = await authService.getCurrentFirebaseUserID();
      String combinedUserID = currentEvaluatorID! + widget.userTerpilihID!;

      fetchedSoal = await firestoreService.fetchSoalPGUmum(combinedUserID);
    }

    print(fetchedSoal.length);

    if (fetchedSoal.isEmpty) {
      print('kosong');
      setState(() {
        soal = [];
      });
    } else {
      setState(() {
      soal = fetchedSoal;
      soalControllers = List.generate(fetchedSoal.length, (index) => TextEditingController());
      jawabanControllers = List.generate(fetchedSoal.length, (index) => List.generate(4, (i) => TextEditingController()));
      jawabanBenarControllers = List.generate(fetchedSoal.length, (index) => TextEditingController());
      selectedAnswerNotifiers = List.generate(fetchedSoal.length, (index) => ValueNotifier<int>(-1)); // Inisialisasi ValueNotifier
      gambarDariInternet = List.filled(fetchedSoal.length, false);
      gambarControllers = List.filled(fetchedSoal.length, '');

      // Inisialisasi controller dengan data soal
      for (int i = 0; i < fetchedSoal.length; i++) {
        soalControllers[i].text = fetchedSoal[i].soal;
        for (int j = 0; j < 4; j++) {
          jawabanControllers[i][j].text = fetchedSoal[i].listJawaban[j];
        }
        jawabanBenarControllers[i].text = fetchedSoal[i].jawabanBenar;

        // Set ValueNotifier untuk jawaban yang benar
        for (int j = 0; j < 4; j++) {
          if (fetchedSoal[i].listJawaban[j] == fetchedSoal[i].jawabanBenar) {
            selectedAnswerNotifiers[i].value = j; // Set indeks jawaban yang benar
            break;
          }
        }

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
    final userId = widget.khusus
        ? '${await authService.getCurrentFirebaseUserID()}${widget.userTerpilihID}'
        : 'umum';
    await firestoreService.deleteSoalPGUmum(soalId, userId);

    Fluttertoast.showToast(
      msg: "Soal berhasil dihapus",
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    _fetchSoal(); // Refresh soal setelah dihapus
  }

  void _saveSoal(SoalPG soal, int index) async {
    LoadingDialog.show(context);
    String? linkGambar;

    try {
      if (!gambarDariInternet[index]) {
      gambarControllers[index] = ''; // kondisi kalo gapake gambar
      if (newImage != null) {
        linkGambar = await uploadToCloudinary(newImage);
        if (linkGambar == null) throw Exception('Gagal upload');
        gambarDariInternet[index] = true;
        gambarControllers[index] = linkGambar;
      }
    } else {
      linkGambar = gambarControllers[index];
    }
    
    // Buat objek soal baru dengan data yang telah diubah
    SoalPG updatedSoal = SoalPG(
      id: soal.id, // Pastikan untuk menyertakan ID
      soal: soalControllers[index].text,
      listJawaban: jawabanControllers[index].map((controller) => controller.text).toList(),
      jawabanBenar: soal.listJawaban[selectedAnswerNotifiers[index].value],
      gambar: linkGambar ?? '',
    );

    // Panggil fungsi untuk memperbarui soal di Firestore
    if (widget.khusus == false) {
      await firestoreService.updateSoalPGUmum(updatedSoal, 'umum');
    } else {
      String? currentEvaluatorID = await authService.getCurrentFirebaseUserID();
      String combinedUserID = currentEvaluatorID! + widget.userTerpilihID!;
      await firestoreService.updateSoalPGUmum(updatedSoal, combinedUserID);
    }

    // Perbarui data lokal
    setState(() {
      _saveLocal(updatedSoal, index);
      canEdit = false;
    });

    LoadingDialog.hide(context);
    MyBigPopUp.showAlertDialog(
        context: context, teks: 'Soal berhasil diperbarui!');
    } catch (e) {
      LoadingDialog.hide(context);
      MyBigPopUp.showAlertDialog(context: context, teks: 'Gagal upload!');
    }
  }

  void _editSoal(SoalPG soal, int answerValue) {
    setState(() {
      canEdit = true;
      // Simpan nilai asli dari selectedAnswerNotifier
      originalSelectedAnswer = answerValue;
    });
  }

  void _saveLocal(SoalPG soalBaru, int index) {
    soal[index] = soalBaru;
  }

  void _exitEdit() {
    setState(() {
      canEdit = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Color(0xFF00cfd6),
      resizeToAvoidBottomInset: false,

      appBar: MyAppBar(title: "Kumpulan Soal",),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : soal.isEmpty ? 
            Center(child: Text('Tidak ada soal', style: TextStyle(color: Colors.white)))
            : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                
                    // kotak soal
                    Container(
                      // color: Color(0xFF68F1F6),
                      // constraints: BoxConstraints(minHeight: 470),
                      // height: canEdit ? screenHeight * 2/3 : 470,
                      height: screenHeight * 9/13,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: soal.isEmpty ? 
                        Text('Soal kosong')
                        :
                        PageView.builder(
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

  Widget buildSoalPage(SoalPG soal, int index) {
    String imageUrl = soal.gambar;

    return SingleChildScrollView(
      child: Container(
        // constraints: BoxConstraints(minHeight: 450),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
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
              myWidget: gambarDariInternet[index]
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyNetworkImage(imageUrl: soal.gambar),
                        ),
                        if (canEdit)
                          MyButton(
                            text: 'Hapus',
                            size: 5,
                            fontSize: 12,
                            onTap: () {
                              setState(() {
                                imageUrl = '';
                                gambarDariInternet[index] = false;
                              });
                            },
                          ),
                      ],
                    )
                  : canEdit
                      ? MyImagePicker(onImageSelected: (File? image) {
                          setState(() {
                            newImage = image;
                          });
                        }, deleteFunc: (File? image) {
                          setState(() {
                            newImage = null;
                            PaintingBinding.instance.imageCache.clear();
                            print('gambar terhapus');
                          });
                        })
                      : SizedBox.shrink(),
            ),
      
            const SizedBox(height: 5),
                
            // jawaban A-D
            for (int i = 0; i < 4; i++)...[
              MyFormRow(
              labelText: 'Jawaban ${abcd[i]}',
              myWidget: MyTextField(
                controller: jawabanControllers[index][i],
                hintText: 'Ketik jawaban ${abcd[i]} di sini',
                obscureText: false,
                enabled: canEdit
              ),
            ),
            
            const SizedBox(height: 5),
            ],
            
            // jawaban benar
            
            MyFormRow(
              labelText: 'Jawaban Benar',
              myWidget: MyCheckboxRow(
                abcd: abcd,
                selectedAnswerNotifier: selectedAnswerNotifiers[index],
                enabled: canEdit
              )
            ),
          
            const SizedBox(height: 20),
      
            // edit, hapus, batal, simpan
            MySoalCRUDButton(
              canEdit: canEdit,
              deleteFunc: () {
                _deleteSoal(soal.id);
                if (currentPageIndex > 0) {
                  setState(() {
                    _controller.previousPage(
                      duration: Duration(milliseconds: 1),
                      curve: Curves.linear,
                    );
                  });
                }
                newImage = null;
              },
              editFunc: () {
                _editSoal(soal, selectedAnswerNotifiers[index].value);
                newImage = null;
              },
              batalFunc: () {
                //balikkan value
                soalControllers[index].text = soal.soal;
                for (int i = 0; i < 4; i++) {
                  jawabanControllers[index][i].text = soal.listJawaban[i];
                }
                selectedAnswerNotifiers[index].value = originalSelectedAnswer;
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
                newImage = null;
              },
            ),
          ],
        ),
      ),
    );
  }
}