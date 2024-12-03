import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../components/big_popup.dart';
import '../../../components/my_button.dart';
import '../../../components/my_form_row.dart';
import '../../../components/my_textfield.dart';
import '../../../components/small_popup.dart';
import '../../../models/soal.dart';
import '../../../services/firestore.dart';
import '../kumpulan_kognitif_umum_page.dart';

class FormSoalKognitifUmum extends StatelessWidget {
  final String? userTerpilihID;// nama user opsional
  final bool khusus;

  const FormSoalKognitifUmum({
    super.key,
    this.userTerpilihID,
    this.khusus = false
  });

  @override
  Widget build(BuildContext context) {

    final FirestoreService firestoreService = FirestoreService();

    final soalController = TextEditingController();
    final jawabanBenarController = TextEditingController();

    String? userTerpilihID = this.userTerpilihID;
    bool isKhusus = this.khusus;

    return Scaffold(
      backgroundColor: Color(0xFF00cfd6),

      appBar: AppBar(
        title: Text("Buat Soal Kognitif Umum"),
        backgroundColor: Color(0xFF00cfd6),
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle
            ),
            child: BackButton(
              color: Color(0xFF00cfd6),
            ),
          ),
        ), 
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                    MyFormRow(
                      labelText: 'Gambar : ',
                      myWidget: MyTextField(
                        controller: null,
                        hintText: 'Fitur upload gambar gabisa di web',
                        obscureText: false,
                      ),
                    ),
                
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
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => KumpulanSoalKognitifPage())), 
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