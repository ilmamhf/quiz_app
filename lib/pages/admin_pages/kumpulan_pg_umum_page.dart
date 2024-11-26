import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../models/soal.dart';
import '../../../services/firestore.dart';
import '../../components/big_popup.dart';
import '../../components/my_appbar.dart';
import '../../components/my_checkbox_row.dart';
import '../../components/my_form_row.dart';
import '../../components/my_textfield.dart';
import '../../components/page_navigator_button.dart';
import '../../components/soal_crud_button.dart';

class KumpulanSoalPage extends StatefulWidget {
  const KumpulanSoalPage({Key? key}) : super(key: key);

  @override
  State<KumpulanSoalPage> createState() => _KumpulanSoalPageState();
}

class _KumpulanSoalPageState extends State<KumpulanSoalPage> {
  final FirestoreService firestoreService = FirestoreService();
  late Future<List<SoalPG>> _soalListFuture;
  List<SoalPG> soal = [];
  PageController _controller = PageController();
  int currentPageIndex = 0;

  // final soalController = TextEditingController();
  final gambarController = TextEditingController();
  // List<TextEditingController> jawabanControllers = [
  // TextEditingController(), // jawaban A
  // TextEditingController(), // jawaban B
  // TextEditingController(), // jawaban C
  // TextEditingController(), // jawaban D
  // ];
  List<String> listJawaban = ['', '', '', ''];
  List<String> abcd = ['A', 'B', 'C', 'D'];

  // final jawabanBenarController = TextEditingController();
  bool isChecked = false;
  // ValueNotifier<int> selectedAnswerNotifier = ValueNotifier<int>(-1);
  List<TextEditingController> soalControllers = [];
  List<List<TextEditingController>> jawabanControllers = [];
  List<TextEditingController> jawabanBenarControllers = [];
  List<ValueNotifier<int>> selectedAnswerNotifiers = [];

  int originalSelectedAnswer = 0;


  bool canEdit = false;

  @override
  void initState() {
    super.initState();
    _fetchSoal();
  }

  Future<void> _fetchSoal() async {
    List<SoalPG> fetchedSoal = await firestoreService.fetchSoalPGUmum();
    setState(() {
      soal = fetchedSoal;
      soalControllers = List.generate(fetchedSoal.length, (index) => TextEditingController());
      jawabanControllers = List.generate(fetchedSoal.length, (index) => List.generate(4, (i) => TextEditingController()));
      jawabanBenarControllers = List.generate(fetchedSoal.length, (index) => TextEditingController());
      selectedAnswerNotifiers = List.generate(fetchedSoal.length, (index) => ValueNotifier<int>(-1)); // Inisialisasi ValueNotifier

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

        
      }
    });
  }

  void _deleteSoal(String soalId) async {
    await firestoreService.deleteSoalPGUmum(soalId);
    Fluttertoast.showToast(
      msg: "Soal berhasil dihapus",
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    _fetchSoal(); // Refresh soal setelah dihapus
  }

  void _saveSoal(SoalPG soal, int index) async {
    // Buat objek soal baru dengan data yang telah diubah
    SoalPG updatedSoal = SoalPG(
      id: soal.id, // Pastikan untuk menyertakan ID
      soal: soalControllers[index].text,
      listJawaban: jawabanControllers[index].map((controller) => controller.text).toList(),
      jawabanBenar: soal.listJawaban[selectedAnswerNotifiers[index].value],
    );

    // Panggil fungsi untuk memperbarui soal di Firestore
    await firestoreService.updateSoalPGUmum(updatedSoal);

    // Perbarui data lokal
    setState(() {
      _saveLocal(updatedSoal, index);
      canEdit = false;
    });
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
      body: soal.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
                // "Soal ${index + 1}: ${soal.soal}",
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
      
            // gambar
      
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
              deleteFunc: () {_deleteSoal(soal.id);},
              editFunc: () {_editSoal(soal, selectedAnswerNotifiers[index].value);},
              batalFunc: () {
                //balikkan value
                soalControllers[index].text = soal.soal;
                for (int i = 0; i < 4; i++) {
                  jawabanControllers[index][i].text = soal.listJawaban[i];
                }
                // jawabanBenarControllers[index].text = soal.jawabanBenar;
                selectedAnswerNotifiers[index].value = originalSelectedAnswer;
                _exitEdit();
              },
              simpanFunc: () {_saveSoal(soal, index);},
            ),
          ],
        ),
      ),
    );
  }
}