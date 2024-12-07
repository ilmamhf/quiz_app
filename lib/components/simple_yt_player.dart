// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class YTPlayer extends StatelessWidget {
//   final YoutubePlayerController controller;

//   const YTPlayer({Key? key, required this.controller}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return YoutubePlayer(
//       controller: controller,
//       showVideoProgressIndicator: true,
//       progressIndicatorColor: Colors.blueAccent,
//       topActions: <Widget>[
//         const SizedBox(width: 8.0),
//         Expanded(
//           child: Text(
//             controller.metadata.title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 18.0,
//             ),
//             overflow: TextOverflow.ellipsis,
//             maxLines: 1,
//           ),
//         ),
//         IconButton(
//           icon: const Icon(
//             Icons.settings,
//             color: Colors.white,
//             size: 25.0,
//           ),
//           onPressed: () {
//             // Add your settings action here
//           },
//         ),
//       ],
//       onReady: () {
//         // Add your onReady action here
//       },
//       onEnded: (data) {
//         // Add your onEnded action here
//       },
//     );
//   }
// }
