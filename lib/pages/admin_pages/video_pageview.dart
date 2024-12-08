// import 'package:flutter/material.dart';

// import '../../models/soal.dart';

// class VideoPageView extends StatefulWidget {
//   const VideoPageView({super.key});

//   @override
//   State<VideoPageView> createState() => _VideoPageViewState();
// }

// class _VideoPageViewState extends State<VideoPageView> {
//   @override
//   Widget build(BuildContext context, SoalKognitif soal, int index) {
//     return SingleChildScrollView(
//       child: Container(
//         // constraints: BoxConstraints(minHeight: 450),
//         decoration: BoxDecoration(
//           // border: Border.all(color: Colors.black, width: 2.0),
//           color: Colors.white,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // judul
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Text(
//                 "Soal ${index + 1}",
//                 // "Soal ${index + 1}: ${soal.soal}",
//                 style: TextStyle(fontSize: 20.0),
//                 textAlign: TextAlign.center,
//               ),
//             ),
      
//             // soal
            
//             MyFormRow(
//               labelText: 'Soal : ',
//               myWidget: MyTextField(
//                 controller: soalControllers[index],
//                 hintText: 'Ketik soal di sini',
//                 obscureText: false,
//                 enabled: canEdit,
//               ),
//             ),
      
//             // gambar
      
//             // video
//             MyFormRow(
//               labelText: 'Video',
//               myWidget: Column(
//                 children: [
//                   MyTextField(
//                     controller: urlControllers[index],
//                     hintText: 'Masukkan link YouTube',
//                     obscureText: false,
//                   ),

//                   const SizedBox(height: 5),

//                   MyButton(
//                     text: 'Muat Video', 
//                     size: 5,
//                     fontSize: 12,
//                     paddingSize: 80,
//                     onTap: () {
//                       setState(() {
//                         String? videoId = YoutubePlayer.convertUrlToId(urlControllers[index].text);
//                         if (videoId != null) {// cari video
//                           if(ytPlayerTerbuat == false) {
//                             _loadVideo();
//                             ytPlayerTerbuat = true;
//                           } else {
//                             // videoController.pause();
//                             videoController.load(videoId);
//                             // videoController.pause();
//                             // videoController.updateValue(videoController.value);
//                             print(videoController.value.metaData.title);
//                           }
//                         }
//                       });
//                     }, 
//                   ),

//                   // komponen youtube video player
//                   // vidLoaded ? 
//                   MyYoutubePlayer(
//                     controller: _controller
//                   ),
//                   // : SizedBox.shrink(),
                  
//                   const SizedBox(height: 5),
//                 ],
//               ),
//             ),
            
//             SizedBox(height: 5),
            
//             // jawaban benar

//             MyFormRow(
//               labelText: 'Jawaban Benar : ',
//               myWidget: MyTextField(
//                 controller: jawabanBenarControllers[index],
//                 hintText: 'Ketik jawaban benar di sini',
//                 obscureText: false,
//                 enabled: canEdit,
//               ),
//             ),
          
//             const SizedBox(height: 20),

//             // edit, hapus, batal, simpan
//             MySoalCRUDButton(
//               canEdit: canEdit,
//               deleteFunc: () {_deleteSoal(soal.id);},
//               editFunc: () {_editSoal(soal);},
//               batalFunc: () {
//                 //balikkan value
//                 soalControllers[index].text = soal.soal;
//                 jawabanBenarControllers[index].text = soal.jawabanBenar;
//                 _exitEdit();
//               },
//               simpanFunc: () {_saveSoal(soal, index);},
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }