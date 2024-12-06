import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../components/my_appbar.dart';
import '../../components/my_button.dart';
import 'user_page.dart';

class NilaiPage extends StatelessWidget {
  final int jawabanBenar;
  final int jumlahSoal;

  const NilaiPage({
    super.key,
    required this.jawabanBenar,
    required this.jumlahSoal,
  });

  @override
  Widget build(BuildContext context) {

    double nilaiAkhir = (jawabanBenar / jumlahSoal) * 100;

    return Scaffold(
      backgroundColor: Color(0xFF00CFD6),
      appBar: MyAppBar(title: 'Hasil Akhir',),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text('Total jawaban benar',style: TextStyle(fontSize: 18, color: Colors.white),),
                const SizedBox(height: 5),

                Text('$jawabanBenar dari $jumlahSoal soal', style: TextStyle(fontSize: 18, color: Colors.white),),
                const SizedBox(height: 30),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text('Total nilai akhir kamu', style: TextStyle(fontSize: 36,),textAlign: TextAlign.center,),
                            ),
                                          
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF99FCFF),
                                  ),
                                  child: Center(
                                    child: Text(
                                      nilaiAkhir.toString(), 
                                      style: TextStyle(fontSize: 72),
                                    )
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),

                MyButton(
                  text: 'Halaman Utama',
                  size: 5,
                  paddingSize: 20,
                  onTap: () {
                    Navigator.popUntil(context, ModalRoute.withName('/userpage'));
                  },
                ),

                // Row(
                //   children: [
                //     Expanded(
                //       child: MyButton(
                //         text: 'Ulangi',
                //         size: 5,
                //         onTap: () {
                //           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => 
                //             NilaiPage(jawabanBenar: totalSkor, jumlahSoal: soal.length)), (Route<dynamic> route) => false,);
                //         },
                //       ),
                //     ),

                    
                //   ],
                // ),
              ],
            ),
          ),
        )
      ),
    );
  }
}