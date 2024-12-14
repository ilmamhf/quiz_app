import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../components/big_popup.dart';
import '../../../components/loading_popup.dart';
import '../../../components/my_appbar.dart';
import '../../../components/my_button.dart';
import '../../../components/my_form_row.dart';
import '../../../components/my_image_picker.dart';
import '../../../components/my_textfield.dart';
import '../../../components/small_popup.dart';
import '../../../models/soal.dart';
import '../../../services/cloudinary.dart';
import '../../../services/firestore.dart';
import '../kumpulan_kognitif_umum_page.dart';

class FormSoalKognitifUmum extends StatefulWidget {
  final String? userTerpilihID;// nama user opsional
  final bool khusus;
  // final bool isVideo;

  const FormSoalKognitifUmum({
    super.key,
    this.userTerpilihID,
    this.khusus = false,
    // this.isVideo = false,
  });

  @override
  State<FormSoalKognitifUmum> createState() => _FormSoalKognitifUmumState();
}

class _FormSoalKognitifUmumState extends State<FormSoalKognitifUmum> {

  final FirestoreService firestoreService = FirestoreService();

  final soalController = TextEditingController();
  final jawabanBenarController = TextEditingController();

  final urlController = TextEditingController();

  File? _selectedImage;

  @override
  void dispose() {
    soalController.dispose();
    jawabanBenarController.dispose();
    urlController.dispose();
    PaintingBinding.instance.imageCache.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    String? userTerpilihID = widget.userTerpilihID;
    bool isKhusus = widget.khusus;

    return Scaffold(
      backgroundColor: const Color(0xFF00cfd6),

      appBar: MyAppBar(
        title: isKhusus == false 
          ? "Buat Soal Kognitif Umum"
          : "Buat Soal Kognitif Khusus"
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
                        ? 'Silahkan buat soal kognitif untuk semua user'
                        : 'Silahkan buat soal kognitif untuk user $userTerpilihID'
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
                
                    // jawaban benar

                    MyFormRow(
                      labelText: 'Jawaban Benar',
                      myWidget: MyTextField(
                        controller: jawabanBenarController,
                        hintText: 'Ketik jawaban benar di sini',
                        obscureText: false,
                      ),
                    ),
                
                    const SizedBox(height: 20),
                
                    // tombol kirim
                
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
                                jawabanBenarController.text.isNotEmpty
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
                                  SoalKognitif soalKognitifUmum = SoalKognitif(
                                    soal: soalController.text,
                                    gambar: linkGambar ?? '',
                                    jawabanBenar: jawabanBenarController.text,
                                  );
                                            
                                  // add to db
                                  print('uploading... ');
                                  if (isKhusus == false) {
                                    firestoreService.addSoalKognitifUmum(soalKognitifUmum, 'umum');
                                  } else {
                                    String? currentEvaluatorID = await FirebaseAuth.instance.currentUser!.uid;
                                    String combinedUserID = currentEvaluatorID + userTerpilihID!;

                                    firestoreService.addSoalKognitifUmum(soalKognitifUmum, combinedUserID);
                                  }
                                  print('soal terupload');

                                  // exit dialog loading
                                  LoadingDialog.hide(context);

                                  MyBigPopUp.showAlertDialog(context: context, teks: 'Soal sudah terupload!');
                                } catch (e) {
                                  // exit dialog loading
                                  LoadingDialog.hide(context);
                                  
                                  MyBigPopUp.showAlertDialog(context: context, teks: 'Gagal upload!');
                                }
                              } else {
                                MySmallPopUp.showToast(
                                  message: 'Soal tidak valid!',
                                );
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const KumpulanSoalKognitifPage()))
                              :() => Navigator.push(context, MaterialPageRoute(builder: (context) => KumpulanSoalKognitifPage(khusus: true, userTerpilihID: userTerpilihID,))), 
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