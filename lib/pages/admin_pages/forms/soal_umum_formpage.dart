import 'dart:io';

import 'package:flutter/material.dart';

import '../../../components/big_popup.dart';
import '../../../components/loading_popup.dart';
import '../../../components/my_appbar.dart';
import '../../../components/my_button.dart';
import '../../../components/my_checkbox_row.dart';
import '../../../components/my_form_row.dart';
import '../../../components/my_image_picker.dart';
import '../../../components/my_textfield.dart';
import '../../../components/small_popup.dart';
import '../../../models/soal.dart';
import '../../../services/auth_service.dart';
import '../../../services/cloudinary.dart';
import '../../../services/firestore.dart';
import '../kumpulan_pg_umum_page.dart';

class FormSoalPGUmum extends StatefulWidget {
  final String? userTerpilihID;// nama user opsional
  final bool khusus;

  const FormSoalPGUmum({
    super.key,
    this.userTerpilihID,
    this.khusus = false
  });

  @override
  State<FormSoalPGUmum> createState() => _FormSoalPGUmumState();
}

class _FormSoalPGUmumState extends State<FormSoalPGUmum> {
  final FirestoreService firestoreService = FirestoreService();
  final AuthService authService = AuthService();

  final soalController = TextEditingController();
  final gambarController = TextEditingController();
  List<TextEditingController> jawabanControllers = [
  TextEditingController(), // jawaban A
  TextEditingController(), // jawaban B
  TextEditingController(), // jawaban C
  TextEditingController(), // jawaban D
  ];
  List<String> listJawaban = ['', '', '', ''];

  final jawabanBenarController = TextEditingController();

  List<String> abcd = ['A', 'B', 'C', 'D'];
  bool isChecked = false;
  ValueNotifier<int> selectedAnswerNotifier = ValueNotifier<int>(-1);

  File? _selectedImage;

  @override
  void dispose() {
    soalController.dispose();
    gambarController.dispose();
    for (var controller in jawabanControllers) {
      controller.dispose();
    }
    jawabanBenarController.dispose();
    selectedAnswerNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    String? userTerpilihID = widget.userTerpilihID;
    bool isKhusus = widget.khusus;

    return Scaffold(
      backgroundColor: Color(0xFF00cfd6),

      appBar: MyAppBar(
        title: isKhusus == false 
          ? "Buat Soal PG Umum"
          : "Buat Soal PG Khusus"
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                // border: Border.all(color: Colors.black),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // judul
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        isKhusus == false 
                        ? 'Silahkan buat soal pilihan ganda untuk semua user'
                        : 'Silahkan buat soal pilihan ganda untuk user $userTerpilihID'
                      ),
                    ),
                
                    const SizedBox(height: 20),
                
                    // soal
                    MyFormRow(
                      labelText: 'Soal',
                      myWidget: MyTextField(
                        controller: soalController,
                        hintText: 'Ketik soal di sini',
                        obscureText: false,
                      ),
                    ),
                
                    const SizedBox(height: 5),
                
                    // gambar
                    MyFormRow(
                      labelText: "Gambar", 
                      myWidget: MyImagePicker(
                        onImageSelected: (File? image) {
                          setState(() {
                            _selectedImage = image;
                          });
                        },
                        deleteFunc: (File? image) {
                          setState(() {
                            _selectedImage = null;
                            PaintingBinding.instance.imageCache.clear();
                            print('gambar terhapus');
                          });
                        },
                      ),
                    ),
                
                    const SizedBox(height: 5),
                
                    // jawaban A-D
                    for (int i = 0; i < 4; i++)...[
                      MyFormRow(
                      labelText: 'Jawaban ${abcd[i]}',
                      myWidget: MyTextField(
                        controller: jawabanControllers[i],
                        hintText: 'Ketik jawaban ${abcd[i]} di sini',
                        obscureText: false,
                      ),
                    ),
                
                    const SizedBox(height: 5),
                    ],
                
                    // jawaban benar
                
                    MyFormRow(
                      labelText: 'Jawaban Benar',
                      myWidget: MyCheckboxRow(
                        abcd: abcd,
                        selectedAnswerNotifier: selectedAnswerNotifier,
                        enabled: true,
                      )
                    ),
                
                    const SizedBox(height: 20),
                
                    // tombol Simpan soal

                    Row(
                      children: [
                        Expanded(
                          child: MyButton(
                            size: 5,
                            text: 'Simpan Soal',
                            paddingSize: 15,
                            onTap: () async { 
                                              
                              // check apakah
                              if (
                                soalController.text.isNotEmpty &&
                                jawabanControllers[0].text.isNotEmpty &&
                                jawabanControllers[1].text.isNotEmpty &&
                                jawabanControllers[2].text.isNotEmpty &&
                                jawabanControllers[3].text.isNotEmpty &&
                                selectedAnswerNotifier.value != -1
                                ) {

                                // Tampilkan dialog loading
                                LoadingDialog.show(context);

                                try {
                                  String? linkGambar;

                                  if (_selectedImage != null) {
                                    // upload gambar ke cloudinary
                                    linkGambar = await uploadToCloudinary(_selectedImage);
                                    if (linkGambar == null) {
                                      throw Exception('Gagal upload'); // otomatis langsung keluar dari try
                                    }
                                  }

                                  for (int i = 0; i < 4; i++) {
                                    listJawaban[i] = jawabanControllers[i].text;
                                  }
                                  SoalPG soalUmum = SoalPG(
                                    soal: soalController.text,
                                    gambar: linkGambar ?? '',
                                    listJawaban: listJawaban,
                                    jawabanBenar: listJawaban[selectedAnswerNotifier.value],
                                  );
                                                
                                  // add to db
                                  print('uploading... ');
                                  if (isKhusus == false) {
                                    firestoreService.addSoalPGUmum(soalUmum, 'umum');
                                  } else {
                                    String? currentEvaluatorID = await authService.getCurrentFirebaseUserID();
                                    String combinedUserID = currentEvaluatorID! + userTerpilihID!;

                                    firestoreService.addSoalPGUmum(soalUmum, combinedUserID);
                                  }
                                  
                                  print('soal terupload');

                                  // exit dialog loading
                                  LoadingDialog.hide(context);
                                  
                                  MyBigPopUp.showAlertDialog(
                                    teks: 'Soal sudah terupload!', 
                                    context: context,
                                  );
                                } catch (e) {
                                  // exit dialog loading
                                  LoadingDialog.hide(context);

                                  MyBigPopUp.showAlertDialog(
                                    teks: 'Gagal upload!', 
                                    context: context,
                                  );
                                }
                              } else {
                                MySmallPopUp.showToast(message: 'Soal tidak valid!');
                              }
                            },
                          ),
                        ),

                        Expanded(
                          child: MyButton(
                            size: 5,
                            text: 'Kumpulan Soal',
                            onTap: isKhusus == false ? 
                              () => 
                              Navigator.push(context, MaterialPageRoute(builder: (context) => KumpulanSoalPage()))
                              :() => Navigator.push(context, MaterialPageRoute(builder: (context) => KumpulanSoalPage(khusus: true, userTerpilihID: userTerpilihID,))), 
                            paddingSize: 15,
                          ),
                        ),
                        
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}