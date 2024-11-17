import 'package:flutter/material.dart';

import '../../../components/big_popup.dart';
import '../../../components/my_button.dart';
import '../../../components/my_form_row.dart';
import '../../../components/my_textfield.dart';
import '../../../components/small_popup.dart';
import '../../../models/soal.dart';
import '../../../services/firestore.dart';

class FormSoalKognitifUmum extends StatelessWidget {
  const FormSoalKognitifUmum({super.key});

  @override
  Widget build(BuildContext context) {

    final FirestoreService firestoreService = FirestoreService();

    final soalController = TextEditingController();
    final jawabanBenarController = TextEditingController();

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
                    Text('Silahkan buat soal kognitif untuk semua user'),
                
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
                
                    MyButton(
                      onTap: () { 
                
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
                          firestoreService.addSoalKognitifUmum(soalKognitifUmum);
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
                      size: 5,
                      text: 'Kirim',
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