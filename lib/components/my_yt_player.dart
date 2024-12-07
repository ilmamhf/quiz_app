// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class MyYoutubePlayer extends StatefulWidget {
//   final String videoUrl;
//   const MyYoutubePlayer({
//     Key? key,
//     required this.videoUrl,
//   }) : super(key: key);

//   @override
//   State<MyYoutubePlayer> createState() => _MyYoutubePlayerState();
// }

// class _MyYoutubePlayerState extends State<MyYoutubePlayer> {
//   late YoutubePlayerController _controller;
//   bool _isPlayerReady = false;
//   YoutubeMetaData _videoMetaData = const YoutubeMetaData();
//   PlayerState _playerState = PlayerState.unknown;

//   @override
//   void initState() {
//     super.initState();
//     String? videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
//     if (videoId != null) {
//       _controller = YoutubePlayerController(
//         initialVideoId: videoId,
//         flags: const YoutubePlayerFlags(
//           autoPlay: false,
//           mute: false,
//         ),
//       )..addListener(() {
//           if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
//             setState(() {
//               _playerState = _controller.value.playerState;
//               _videoMetaData = _controller.metadata;
//             });
//           }
//         });
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     // // Mengatur orientasi layar ke portrait
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     super.dispose();
//   }

//   @override
//   void deactivate() {
//     // Pauses video while navigating to next page.
//     _controller.pause();

//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     super.deactivate();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return YoutubePlayer(
//       controller: _controller,
//       showVideoProgressIndicator: true,
//       progressIndicatorColor: Colors.blueAccent,
//       topActions: <Widget>[
//         const SizedBox(width: 8.0),
//         Expanded(
//           child: Text(
//             _videoMetaData.title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 18.0,
//             ),
//             overflow: TextOverflow.ellipsis,
//             maxLines: 1,
//           ),
//         ),
//       ],
//       onReady: () {
//         setState(() => _isPlayerReady = true);
//       },
//       onEnded: (data) {
//         _controller.pause();
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MyYoutubePlayer extends StatelessWidget {
  final YoutubePlayerController controller;

  const MyYoutubePlayer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.blueAccent,
      topActions: <Widget>[
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            controller.metadata.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
      onReady: () {
        print("YouTube Player is ready.");
      },
      onEnded: (data) {
        controller.pause();
      },
    );
  }
}
