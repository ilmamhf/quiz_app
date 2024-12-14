import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../components/big_popup.dart';
import '../../components/my_appbar.dart';
import '../../components/my_button.dart';
import '../../components/my_form_row.dart';
import '../../components/my_textfield.dart';
import '../../components/my_yt_player.dart';
import '../../components/page_navigator_button.dart';
import '../../components/soal_crud_button.dart';
import '../../models/soal.dart';
import '../../services/auth_service.dart';
import '../../services/firestore.dart';
import 'forms/soal_video_page.dart';

class KumpulanSoalVideoPage extends StatefulWidget {
  final String? userTerpilihID;// nama user opsional
  final bool khusus;

  const KumpulanSoalVideoPage({
    super.key,
    this.userTerpilihID, 
    this.khusus = false,
  });

  @override
  State<KumpulanSoalVideoPage> createState() => _KumpulanSoalVideoPageState();
}

class _KumpulanSoalVideoPageState extends State<KumpulanSoalVideoPage> {
  
  final FirestoreService firestoreService = FirestoreService();
  final AuthService authService = AuthService();
  
  List<SoalKognitif> soal = [];

  PageController _controller = PageController();
  int currentPageIndex = 0;

  List<TextEditingController> soalControllers = [];
  List<TextEditingController> jawabanBenarControllers = [];
  List<TextEditingController> urlControllers = [];
  List<YoutubePlayerController> videoControllers = [];
  
  bool canEdit = false;

  @override
  void initState() {
    super.initState();
    _fetchSoal();
  }

  Future<void> _fetchSoal() async {
    setState(() {
      isLoading = true;
    });

    List<SoalKognitif> fetchedSoal = [];

    if (widget.khusus == false) {
      fetchedSoal = await firestoreService.fetchSoalVideoUmum('umum');
    } else {
      String? currentEvaluatorID = await authService.getCurrentFirebaseUserID();
      String combinedUserID = currentEvaluatorID! + widget.userTerpilihID!;

      fetchedSoal = await firestoreService.fetchSoalVideoUmum(combinedUserID);
    }

    if (fetchedSoal.isEmpty) {
      print('kosong');
      setState(() {
        soal = [];
      });
    } else {
      setState(() {
      soal = fetchedSoal;
      soalControllers = List.generate(fetchedSoal.length, (index) => TextEditingController());
      jawabanBenarControllers = List.generate(fetchedSoal.length, (index) => TextEditingController());
      urlControllers = List.generate(fetchedSoal.length, (index) => TextEditingController());

      // Inisialisasi controller dengan data soal
      for (int i = 0; i < fetchedSoal.length; i++) {
        soalControllers[i].text = fetchedSoal[i].soal;
        jawabanBenarControllers[i].text = fetchedSoal[i].jawabanBenar;
        urlControllers[i].text = fetchedSoal[i].video;

        // print(soalControllers[i].text);
        // print(urlControllers[i].text);
      }
      // String? videoId = YoutubePlayer.convertUrlToId(urlControllers[index].text);

      videoControllers = List.generate(fetchedSoal.length, (index) => YoutubePlayerController(initialVideoId: YoutubePlayer.convertUrlToId(urlControllers[index].text).toString()));
    });
    }
    
    setState(() {
      isLoading = false;
    });
  }

  void _deleteSoal(String soalId) async {
    if (widget.khusus == false) {
      await firestoreService.deleteSoalVideoUmum(soalId, 'umum');
    } else {
      String? currentEvaluatorID = await authService.getCurrentFirebaseUserID();
      String combinedUserID = currentEvaluatorID! + widget.userTerpilihID!;

      await firestoreService.deleteSoalVideoUmum(soalId, combinedUserID);
    }

    
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
      video: urlControllers[index].text,
    );

    // Panggil fungsi untuk memperbarui soal di Firestore
    if (widget.khusus == false) {
      await firestoreService.updateSoalKognitifUmum(updatedSoal, 'umum');
    } else {
      String? currentEvaluatorID = await authService.getCurrentFirebaseUserID();
      String combinedUserID = currentEvaluatorID! + widget.userTerpilihID!;
      await firestoreService.updateSoalKognitifUmum(updatedSoal, combinedUserID);
    }

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
  
  bool isLoading = true;

  // @override
  // void initState() {
  //   videoController = YoutubePlayerController(
  //     initialVideoId: '', // Video ID awal (bisa kosong)
  //     flags: const YoutubePlayerFlags(
  //       autoPlay: false,
  //       mute: false,
  //     ),
  //   );

  //   super.initState();
  // }

  void videoMemoryFix(int index) {
    setState(() {
      videoControllers[index].pause();
    });
    // super.deactivate();
  }

  @override
  void dispose() {
    // Bebaskan semua controller
    for (var controller in soalControllers) {
      controller.dispose();
    }
    for (var controller in jawabanBenarControllers) {
      controller.dispose();
    }
    for (var controller in urlControllers) {
      controller.dispose();
    }
    for (var videoController in videoControllers) {
      videoController.dispose(); // Pastikan untuk membebaskan YoutubePlayerController
    }
    // Bebaskan PageController
    _controller.dispose();
    super.dispose(); // Panggil super.dispose() di akhir
  }

  // @override
  // void deactivate() {
  //   // Pauses video while navigating to next page.
  //   videoController.pause();

  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  //   super.deactivate();
  // }

  bool adaVideo = false;
  bool ytPlayerTerbuat = false;
  
  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.sizeOf(context).height;



    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FormSoalVideoUmum()));
      },
      child: Scaffold(
        backgroundColor: Color(0xFF00cfd6),
        resizeToAvoidBottomInset: false,
      
        appBar: MyAppBar(title: "Kumpulan Soal",),
        body: isLoading
            ? Center(child: CircularProgressIndicator()) // Kondisi loading
          : soal.isEmpty
            ? Center(child: Text("Tidak ada soal", style: TextStyle(color: Colors.white),),) // Kondisi kosong
          : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  
                      // kotak soal
                      Container(
                        // color: Color(0xFF68F1F6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                        ),
                        height: screenHeight * 3/4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PageView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _controller,
                            itemCount: soal.length,
                            onPageChanged: (index) {
                              setState(() {
                                currentPageIndex = index;
                                videoMemoryFix(index);
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
      ),
    );
  }

  Widget buildSoalPage(SoalKognitif soal, int index) {

    // videoControllers[index].load(soal.video);

    return SingleChildScrollView(
      child: Container(
        // constraints: BoxConstraints(minHeight: 450),
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
              labelText: 'Soal',
              myWidget: MyTextField(
                controller: soalControllers[index],
                hintText: 'Ketik soal di sini',
                obscureText: false,
                enabled: canEdit,
              ),
            ),
      
            // gambar
      
            // video
            MyFormRow(
              labelText: 'Video',
              myWidget: Column(
                children: [
                  MyTextField(
                    controller: urlControllers[index],
                    hintText: 'Masukkan link YouTube',
                    obscureText: false,
                    enabled: canEdit,
                  ),

                  const SizedBox(height: 5),

                  canEdit ? MyButton(
                    text: 'Muat Video', 
                    size: 5,
                    fontSize: 12,
                    paddingSize: 80,
                    onTap: () {
                      setState(() {
                        String? videoId = YoutubePlayer.convertUrlToId(urlControllers[index].text);
                        if (videoId != null) {// cari video
                        videoControllers[index].load(videoId);
                        }
                      });
                    }, 
                  ) : SizedBox.shrink(),
                ],
              ),
            ),
            const SizedBox(height: 5),

            // komponen youtube video player
            // vidLoaded ? 
            MyYoutubePlayer(
              controller: videoControllers[index]
            ),
            // : SizedBox.shrink(),
            
            SizedBox(height: 5),
            
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

            // edit, hapus, batal, simpan
            MySoalCRUDButton(
              canEdit: canEdit,
              deleteFunc: () {
                _deleteSoal(soal.id);
                if (currentPageIndex > 0) {
                  setState(() {
                    _controller.previousPage(
                      duration: Duration(milliseconds: 1),
                      curve: Curves.linear,
                    );
                  });
                }
              },
              editFunc: () {_editSoal(soal);},
              batalFunc: () {
                //balikkan value
                soalControllers[index].text = soal.soal;
                jawabanBenarControllers[index].text = soal.jawabanBenar;
                urlControllers[index].text = soal.video;
                setState(() {
                  String? videoId = YoutubePlayer.convertUrlToId(urlControllers[index].text);
                  if (videoId != null) {// cari video
                    videoControllers[index].load(videoId);
                  }
                });
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