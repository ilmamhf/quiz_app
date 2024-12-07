import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../components/big_popup.dart';
import '../../../components/my_appbar.dart';
import '../../../components/my_button.dart';
import '../../../components/my_form_row.dart';
import '../../../components/my_image_picker.dart';
import '../../../components/my_textfield.dart';
// import '../../../components/my_yt_player.dart';
import '../../../components/small_popup.dart';
import '../../../models/soal.dart';
import '../../../services/firestore.dart';
import '../kumpulan_kognitif_umum_page.dart';

class FormSoalVideoUmumCopy extends StatefulWidget {
  final String? userTerpilihID;// nama user opsional
  final bool khusus;

  const FormSoalVideoUmumCopy({
    super.key,
    this.userTerpilihID,
    this.khusus = false,
  });

  @override
  State<FormSoalVideoUmumCopy> createState() => _FormSoalVideoUmumCopyState();
}

class _FormSoalVideoUmumCopyState extends State<FormSoalVideoUmumCopy> {

  final FirestoreService firestoreService = FirestoreService();

  final soalController = TextEditingController();
  final jawabanBenarController = TextEditingController();

  // final urlController = TextEditingController();

  // late YoutubePlayerController YTcontroller;

  late YoutubePlayerController _controller;
  late TextEditingController urlController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  // double _volume = 100;
  // bool _muted = false;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();

    // Mengatur orientasi layar ke portrait
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    
    _controller = YoutubePlayerController(
      initialVideoId: '',
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    )..addListener(listener);

    urlController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;

    // YTcontroller.setFullScreenListener((isFullScreen) {
    //   print('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
    // });
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;

        _controller.addListener(() {
          if (_controller.value.isFullScreen) {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeRight,
              DeviceOrientation.landscapeLeft,
            ]);
          } else {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);
          }
        });

      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    urlController.dispose();
    _seekToController.dispose();

    // // Mengatur orientasi layar ke portrait
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);

    super.dispose();
  }

  bool adaVideo = false;

  void _loadVideo() {
    if (urlController.text.isNotEmpty) {
      var videoId = YoutubePlayer.convertUrlToId(urlController.text);
      print('Video ID: $videoId');
      if (videoId != null) {
        setState(() {
          _controller.load(videoId);
          adaVideo = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('URL tidak valid')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    String? userTerpilihID = widget.userTerpilihID;
    bool isKhusus = widget.khusus;
    // bool isVideo = widget.isVideo;

    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          // DeviceOrientation.portraitDown,
        ]);
        print("Keluar dari fullscreen");
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          // IconButton(
          //   icon: const Icon(
          //     Icons.settings,
          //     color: Colors.white,
          //     size: 25.0,
          //   ),
          //   onPressed: () {
          //     print('Settings Tapped!');
          //   },
          // ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          _controller.pause();
        },
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Color(0xFF00cfd6),
    
          appBar: MyAppBar(
            title: isKhusus == false 
              ? "Buat Soal Video Umum"
              : "Buat Soal Video Khusus"
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
                    
                        // video
                        // MyYoutubePlayer(
                        //   controller: YTcontroller,
                        //   urlController: urlController,
                        // ),
    
                        TextField(
                          controller: urlController,
                          decoration: InputDecoration(
                            labelText: 'Masukkan link YouTube',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _loadVideo();  // cari video
                          },
                          child: Text('Cari'),
                        ),
                        SizedBox(height: 20),

                        // komponen youtube video player
                        adaVideo ? player : SizedBox.shrink(),
                    
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
    );
  }
}