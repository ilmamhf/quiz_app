import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/big_popup.dart';
import '../../components/loading_popup.dart';
import '../../components/my_appbar.dart';
import '../../components/my_button.dart';
import '../../components/my_form_row.dart';
import '../../components/my_image_picker.dart';
import '../../components/my_textfield.dart';
import '../../components/network_image.dart';
import '../../components/page_navigator_button.dart';
import '../../components/soal_crud_button.dart';
import '../../models/soal.dart';
import '../../services/auth_service.dart';
import '../../services/cloudinary.dart';
import '../../services/firestore.dart';
import 'forms/soal_video_page.dart';

class KumpulanSoalKognitifPage extends StatefulWidget {
  final String? userTerpilihID; // nama user opsional
  final bool khusus;

  const KumpulanSoalKognitifPage({
    Key? key,
    this.userTerpilihID,
    this.khusus = false,
  }) : super(key: key);

  @override
  State<KumpulanSoalKognitifPage> createState() =>
      _KumpulanSoalKognitifPageState();
}

class _KumpulanSoalKognitifPageState extends State<KumpulanSoalKognitifPage> {
  final FirestoreService firestoreService = FirestoreService();
  final AuthService authService = AuthService();

  List<SoalKognitif> soal = [];
  PageController _controller = PageController();
  int currentPageIndex = 0;
  File? newImage;
  List<TextEditingController> soalControllers = [];
  List<TextEditingController> jawabanBenarControllers = [];
  List<String> gambarControllers = [];
  List<bool> gambarDariInternet = [];

  bool canEdit = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSoal();
  }

  Future<void> _fetchSoal() async {
    setState(() => isLoading = true);

    List<SoalKognitif> fetchedSoal = widget.khusus
        ? await firestoreService.fetchSoalKognitifUmum(
            '${await authService.getCurrentFirebaseUserID()}${widget.userTerpilihID}')
        : await firestoreService.fetchSoalKognitifUmum('umum');

    if (fetchedSoal.isNotEmpty) {
      setState(() {
        soal = fetchedSoal;
        _initializeControllers(fetchedSoal);
      });
    } else {
      print('kosong');
    }

    setState(() => isLoading = false);
  }

  void _initializeControllers(List<SoalKognitif> fetchedSoal) {
    soalControllers =
        List.generate(fetchedSoal.length, (_) => TextEditingController());
    jawabanBenarControllers =
        List.generate(fetchedSoal.length, (_) => TextEditingController());
    gambarDariInternet = List.filled(fetchedSoal.length, false);
    gambarControllers = List.filled(fetchedSoal.length, '');

    for (int i = 0; i < fetchedSoal.length; i++) {
      soalControllers[i].text = fetchedSoal[i].soal;
      jawabanBenarControllers[i].text = fetchedSoal[i].jawabanBenar;
      if (fetchedSoal[i].gambar.isNotEmpty) {
        gambarDariInternet[i] = true;
        gambarControllers[i] = fetchedSoal[i].gambar;
      }
    }
  }

  void _deleteSoal(String soalId) async {
    final userId = widget.khusus
        ? '${await authService.getCurrentFirebaseUserID()}${widget.userTerpilihID}'
        : 'umum';
    await firestoreService.deleteSoalKognitifUmum(soalId, userId);

    Fluttertoast.showToast(
      msg: "Soal berhasil dihapus",
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    _fetchSoal(); // Refresh soal setelah dihapus
  }

  void _saveSoal(SoalKognitif soal, int index) async {
    LoadingDialog.show(context);
    String? linkGambar;

    try {
      if (!gambarDariInternet[index]) {
        gambarControllers[index] = ''; // kondisi kalo gapake gambar
        if (newImage != null) {
          linkGambar = await uploadToCloudinary(newImage);
          if (linkGambar == null) throw Exception('Gagal upload');
          gambarDariInternet[index] = true;
          gambarControllers[index] = linkGambar;
        }
      } else {
        linkGambar = gambarControllers[index];
      }

      SoalKognitif updatedSoal = SoalKognitif(
        id: soal.id,
        soal: soalControllers[index].text,
        jawabanBenar: jawabanBenarControllers[index].text,
        gambar: linkGambar ?? '',
      );

      final userId = widget.khusus
          ? '${await authService.getCurrentFirebaseUserID()}${widget.userTerpilihID}'
          : 'umum';
      await firestoreService.updateSoalKognitifUmum(updatedSoal, userId);

      setState(() {
        _saveLocal(updatedSoal, index);
        canEdit = false;
      });

      LoadingDialog.hide(context);
      MyBigPopUp.showAlertDialog(
          context: context, teks: 'Soal berhasil diperbarui!');
    } catch (e) {
      LoadingDialog.hide(context);
      MyBigPopUp.showAlertDialog(context: context, teks: 'Gagal upload!');
    }
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
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Color(0xFF00cfd6),
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(title: "Kumpulan Soal"),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : soal.isEmpty
              ? Center(
                  child: Text("Tidak ada soal",
                      style: TextStyle(color: Colors.white)))
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white,
                          ),
                          height: screenHeight * 6 / 9,
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
                                _exitEdit();
                              },
                              itemBuilder: (context, index) {
                                return buildSoalPage(soal[index], index);
                              },
                            ),
                          ),
                        ),
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

  Widget buildSoalPage(SoalKognitif soal, int index) {
    String imageUrl = soal.gambar;

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Soal ${index + 1}",
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ),
            MyFormRow(
              labelText: 'Soal',
              myWidget: MyTextField(
                controller: soalControllers[index],
                hintText: 'Ketik soal di sini',
                obscureText: false,
                enabled: canEdit,
              ),
            ),
            const SizedBox(height: 5),
            MyFormRow(
              labelText: "Gambar",
              myWidget: gambarDariInternet[index]
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyNetworkImage(imageUrl: imageUrl),
                        ),
                        if (canEdit)
                          MyButton(
                            text: 'Hapus',
                            size: 5,
                            fontSize: 12,
                            onTap: () {
                              setState(() {
                                imageUrl = '';
                                gambarDariInternet[index] = false;
                              });
                            },
                          ),
                      ],
                    )
                  : canEdit
                      ? MyImagePicker(
                          onImageSelected: (File? image) {
                            setState(() {
                              newImage = image;
                            });
                          },
                          deleteFunc: (File? image) {
                            setState(() {
                              newImage = null;
                              PaintingBinding.instance.imageCache.clear();
                              print('gambar terhapus');
                            });
                          }
                        )
                      : SizedBox.shrink(),
            ),
            const SizedBox(height: 5),
            MyFormRow(
              labelText: 'Jawaban Benar',
              myWidget: MyTextField(
                controller: jawabanBenarControllers[index],
                hintText: 'Ketik jawaban benar di sini',
                obscureText: false,
                enabled: canEdit,
              ),
            ),
            const SizedBox(height: 20),
            MySoalCRUDButton(
              canEdit: canEdit,
              deleteFunc: () {
                _deleteSoal(soal.id);
                newImage = null;
              },
              editFunc: () {
                _editSoal(soal);
                newImage = null;
              },
              batalFunc: () {
                soalControllers[index].text = soal.soal;
                jawabanBenarControllers[index].text = soal.jawabanBenar;
                if (soal.gambar.isNotEmpty) {
                  setState(() {
                    gambarDariInternet[index] = true;
                  });
                }
                newImage = null;
                _exitEdit();
              },
              simpanFunc: () {
                _saveSoal(soal, index);
                newImage = null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
