import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../components/big_popup.dart';
import '../../components/my_appbar.dart';
import '../../components/my_form_row.dart';
import '../../components/my_textfield.dart';
import '../../models/soal.dart';
import '../../services/firestore.dart';

class KumpulanSoalKognitifPage extends StatefulWidget {
  const KumpulanSoalKognitifPage({super.key});

  @override
  State<KumpulanSoalKognitifPage> createState() => _KumpulanSoalKognitifPageState();
}

class _KumpulanSoalKognitifPageState extends State<KumpulanSoalKognitifPage> {
  
  final FirestoreService firestoreService = FirestoreService();
  
  List<SoalKognitif> soal = [];

  PageController _controller = PageController();
  int currentPageIndex = 0;

  List<TextEditingController> soalControllers = [];
  List<TextEditingController> jawabanBenarControllers = [];
  
  bool canEdit = false;

  @override
  void initState() {
    super.initState();
    _fetchSoal();
  }

  Future<void> _fetchSoal() async {
    List<SoalKognitif> fetchedSoal = await firestoreService.fetchSoalKognitifUmum();
    setState(() {
      soal = fetchedSoal;
      soalControllers = List.generate(fetchedSoal.length, (index) => TextEditingController());
      jawabanBenarControllers = List.generate(fetchedSoal.length, (index) => TextEditingController());

      // Inisialisasi controller dengan data soal
      for (int i = 0; i < fetchedSoal.length; i++) {
        soalControllers[i].text = fetchedSoal[i].soal;
        jawabanBenarControllers[i].text = fetchedSoal[i].jawabanBenar;
      }
    });
  }

  void _deleteSoal(String soalId) async {
    await firestoreService.deleteSoalKognitifUmum(soalId);
    Fluttertoast.showToast(
      msg: "Soal berhasil dihapus",
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    _fetchSoal(); // Refresh soal setelah dihapus
  }

  void _saveSoal(SoalKognitif soal, int index) async {
    // Buat objek soal baru dengan data yang telah diubah
    SoalKognitif updatedSoal = SoalKognitif(
      id: soal.id, // Pastikan untuk menyertakan ID
      soal: soalControllers[index].text,
      jawabanBenar: jawabanBenarControllers[index].text,
    );

    // Panggil fungsi untuk memperbarui soal di Firestore
    await firestoreService.updateSoalKognitifUmum(updatedSoal);

    // Perbarui data lokal
    setState(() {
      _saveLocal(updatedSoal, index);
      canEdit = false;
    });
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00cfd6),

      appBar: MyAppBar(title: "Kumpulan Soal",),
      body: soal.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                
                    // kotak soal
                    Flexible(
                      flex: 7,
                      child: Container(
                        // color: Color(0xFF68F1F6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                        ),
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
                    ),
                
                    // tombol ke soal sebelum dan selanjutnya
                    !canEdit ? Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(0.0),
                        // color: Color(0xFFEEF3FC),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // tombol ke soal sebelumnya
                            Visibility(
                              visible: true,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Color(0xFF00A8AD),
                                  ),
                                  onPressed: currentPageIndex > 0 ? () {
                                    _controller.previousPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    ); 
                                  } : null,
                                        
                                  child: Text("Soal sebelumnya"),
                                ),
                              ),
                            ),
                                        
                            // tombol ke soal selanjutnya
                            Visibility(
                              visible: true,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Color(0xFF00A8AD),
                                  ),
                                  onPressed: currentPageIndex < soal.length - 1 ? () {
                                    _controller.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  } : null,
                                  child: Text("Soal selanjutnya"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ) : Flexible(child: SizedBox()),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildSoalPage(SoalKognitif soal, int index) {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(minHeight: 450),
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
              labelText: 'Soal : ',
              myWidget: MyTextField(
                controller: soalControllers[index],
                hintText: 'Ketik soal di sini',
                obscureText: false,
                enabled: canEdit,
              ),
            ),
      
            // gambar
      
            const SizedBox(height: 5),
            
            // jawaban benar

            MyFormRow(
              labelText: 'Jawaban Benar : ',
              myWidget: MyTextField(
                controller: jawabanBenarControllers[index],
                hintText: 'Ketik jawaban benar di sini',
                obscureText: false,
                enabled: canEdit,
              ),
            ),
          
            const SizedBox(height: 20),
      
            // edit dan hapus
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: !canEdit ? [
          
                // delete soal
                ElevatedButton.icon(
                  onPressed: () {
                    MyBigPopUp.showAlertDialog(
                      teks: "Apakah anda yakin ingin menghapus?",
                      context: context,
                      additionalButtons: [
                        // batal
                        TextButton(
                          onPressed: () => Navigator.pop(context), 
                          child: Text('Batal')),
                        // hapus  
                        TextButton(
                          onPressed: () {
                            _deleteSoal(soal.id);
                            Navigator.pop(context);
                          }, 
                          child: Text('Hapus')),
                      ],
                    );
                  },
                  icon: const Icon(Icons.delete, color: Colors.white,),
                  label: const Text("Hapus", style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),

                // edit soal
                ElevatedButton.icon(
                  onPressed: () {
                    _editSoal(soal);
                  },
                  icon: const Icon(Icons.edit, color: Colors.white,),
                  label: const Text("Edit", style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ] : [
                // batal
                ElevatedButton.icon(
                  onPressed: () {
                    //balikkan value
                    soalControllers[index].text = soal.soal;
                    jawabanBenarControllers[index].text = soal.jawabanBenar;
                    _exitEdit();
                  },
                  icon: const Icon(Icons.cancel, color: Colors.white,),
                  label: const Text("Batal", style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                ),
          
                // save soal
                ElevatedButton.icon(
                  onPressed: () {
                    _saveSoal(soal, index);
                  },
                  icon: const Icon(Icons.save, color: Colors.white,),
                  label: const Text("Simpan", style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}