import 'package:flutter/material.dart';

import '../../components/my_appbar.dart';
import '../../components/my_button.dart';

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
      backgroundColor: const Color(0xFF00CFD6),
      appBar: const MyAppBar(title: 'Hasil Akhir',),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text('Total jawaban benar',style: const TextStyle(fontSize: 18, color: Colors.white),),
                const SizedBox(height: 5),

                Text('$jawabanBenar dari $jumlahSoal soal', style: const TextStyle(fontSize: 18, color: Colors.white),),
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
                            const Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Text('Total nilai akhir kamu', style: TextStyle(fontSize: 36,),textAlign: TextAlign.center,),
                            ),
                                          
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF99FCFF),
                                  ),
                                  child: Center(
                                    child: Text(
                                      nilaiAkhir.toString(), 
                                      style: const TextStyle(fontSize: 72),
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
              ],
            ),
          ),
        )
      ),
    );
  }
}