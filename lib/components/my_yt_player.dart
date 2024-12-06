// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class MyYoutubePlayer extends StatefulWidget {
//   @override
//   _MyYoutubePlayerState createState() => _MyYoutubePlayerState();
// }

// class _MyYoutubePlayerState extends State<MyYoutubePlayer> {
//   late YoutubePlayerController _controller;
//   final TextEditingController _urlController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // Initialize with a default video ID
//     _controller = YoutubePlayerController(
//       initialVideoId: 'dQw4w9WgXcQ', // Default video ID
//       flags: YoutubePlayerFlags(autoPlay: false),
//     );
//   }

//   void _playVideo() {
//     String? videoId = YoutubePlayer.convertUrlToId(_urlController.text);
//     if (videoId != null) {
//       setState(() {
//         _controller.load(videoId);
//       });
//     } else {
//       // Handle invalid URL
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Invalid YouTube URL')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextField(
//           controller: _urlController,
//           decoration: InputDecoration(
//             labelText: 'Enter YouTube URL',
//             suffixIcon: IconButton(
//               icon: Icon(Icons.play_arrow),
//               onPressed: _playVideo,
//             ),
//           ),
//         ),
//         SizedBox(height: 20),
//         YoutubePlayer(
//           controller: _controller,
//           showVideoProgressIndicator: true,
//           progressIndicatorColor: Colors.amber,
//           onReady: () {
//             // You can add additional functionality here
//           },
//         ),
//       ],
//     );
//   }
// }