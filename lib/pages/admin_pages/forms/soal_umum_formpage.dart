import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../components/my_button.dart';
import '../../../components/my_checkbox_row.dart';
import '../../../components/my_form_row.dart';
import '../../../components/my_textfield.dart';
import '../../../models/soal.dart';
import '../../../services/firestore.dart';
import '../kumpulan_pg_umum_page.dart';

class FormSoalPGUmum extends StatefulWidget {
  const FormSoalPGUmum({super.key});

  @override
  State<FormSoalPGUmum> createState() => _FormSoalPGUmumState();
}

class _FormSoalPGUmumState extends State<FormSoalPGUmum> {
  final FirestoreService firestoreService = FirestoreService();

  String levelController = 'Mudah/Sedang/Susah';
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

  List<String> listLevel = [
    'Mudah',
    'Sedang',
    'Susah'
  ];

  List<String> abcd = ['A', 'B', 'C', 'D'];
  bool isChecked = false;
  ValueNotifier<int> selectedAnswerNotifier = ValueNotifier<int>(-1);

  // error message popup
  void showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  void showAlertDialog(String teks) {
    // Show Alert message if parsing fails
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            teks, 
            textAlign: TextAlign.center,
            textScaler: TextScaler.linear(1),),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    // double screenWidth = MediaQuery.sizeOf(context).width;
    // double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Color(0xFF00cfd6),

      appBar: AppBar(
        title: Text("Buat Soal Umum"),
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
                    Text('Silahkan buat soal pilihan ganda untuk semua user'),
                
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
                        controller: gambarController,
                        hintText: 'Fitur upload gambar gabisa di web',
                        obscureText: false,
                      ),
                    ),
                
                    const SizedBox(height: 5),
                
                    // jawaban A-D
                    for (int i = 0; i < 4; i++)...[
                      MyFormRow(
                      labelText: 'Jawaban ${abcd[i]} : ',
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
                      labelText: 'Jawaban Benar : ',
                      myWidget: MyCheckboxRow(
                        abcd: abcd,
                        selectedAnswerNotifier: selectedAnswerNotifier,
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
                            onTap: () { 
                                              
                              // check apakah
                              if (
                                soalController.text.isNotEmpty ||
                                jawabanControllers[0].text.isNotEmpty ||
                                jawabanControllers[1].text.isNotEmpty ||
                                jawabanControllers[2].text.isNotEmpty ||
                                jawabanControllers[3].text.isNotEmpty ||
                                selectedAnswerNotifier.value != -1
                                ) {
                                for (int i = 0; i < 4; i++) {
                                  listJawaban[i] = jawabanControllers[i].text;
                                }
                                Soal soalUmum = Soal(
                                  // level: levelController,
                                  soal: soalController.text,
                                  // gambar: 'Belum ada gambar',
                                  listJawaban: listJawaban,
                                  jawabanBenar: listJawaban[selectedAnswerNotifier.value],
                                );
                                              
                                // add to db
                                print('uploading... ');
                                firestoreService.addSoalPGUmum(soalUmum);
                                print('soal terupload');
                                
                                showAlertDialog('Soal sudah terupload!');
                                              
                                // Navigator.push(context, MaterialPageRoute(
                                //   builder: (context) => SelesaiBuatSoalUmumPage()
                                // )
                                // );
                              } else {
                                showErrorMessage('Soal tidak valid!');
                              }
                            },
                          ),
                        ),

                        Expanded(
                          child: MyButton(
                            size: 5,
                            text: 'Kumpulan Soal',
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => KumpulanSoalPage())), 
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