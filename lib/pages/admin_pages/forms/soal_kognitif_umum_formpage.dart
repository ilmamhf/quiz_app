import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../components/big_popup.dart';
import '../../../components/my_appbar.dart';
import '../../../components/my_button.dart';
import '../../../components/my_form_row.dart';
import '../../../components/my_image_picker.dart';
import '../../../components/my_textfield.dart';
import '../../../components/my_yt_player.dart';
import '../../../components/small_popup.dart';
import '../../../models/soal.dart';
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
  Widget build(BuildContext context) {

    String? userTerpilihID = widget.userTerpilihID;
    bool isKhusus = widget.khusus;
    // bool isVideo = widget.isVideo;

    return Scaffold(
      backgroundColor: Color(0xFF00cfd6),

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
                      labelText: 'Soal : ',
                      myWidget: MyTextField(
                        controller: soalController,
                        hintText: 'Ketik soal di sini',
                        obscureText: false,
                      ),
                    ),
                
                    const SizedBox(height: 5),
                
                    // gambar
                    // !widget.isVideo ? 
                    MyFormRow(
                      labelText: "Gambar", 
                      myWidget: MyImagePicker(
                        onImageSelected: (File? image) {
                          setState(() {
                            _selectedImage = image;
                          });
                        },
                      ),
                    ),
                    // : MyYoutubePlayer(),
                
                    const SizedBox(height: 5),
                
                    // jawaban benar

                    MyFormRow(
                      labelText: 'Jawaban Benar : ',
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
                          
                                SoalKognitif soalKognitifUmum = SoalKognitif(
                                  soal: soalController.text,
                                  // gambar: 'Belum ada gambar',
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
                                
                                MyBigPopUp.showAlertDialog(context: context, teks: 'Soal kognitif umum sudah terupload!');
                                          
                                // Navigator.push(context, MaterialPageRoute(
                                //   builder: (context) => SelesaiBuatSoalUmumPage()
                                // )
                                // );
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => KumpulanSoalKognitifPage()))
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