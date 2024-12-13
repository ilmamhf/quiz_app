import 'package:flutter/material.dart';

import 'my_button.dart';

class MyNetworkImage extends StatefulWidget {
  final String imageUrl;
  // final Function deleteFunc;
  // final bool canEdit;

  MyNetworkImage({
    required this.imageUrl,
    // required this.deleteFunc,
    // this.canEdit = false,
  });

  @override
  State<MyNetworkImage> createState() => _MyNetworkImageState();
}

class _MyNetworkImageState extends State<MyNetworkImage> {

  bool notDeleted = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // notDeleted ? 
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.network(
            height: 250,
            width: 250,
            widget.imageUrl,
            fit: BoxFit.fitHeight, // Atur sesuai kebutuhan
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                // _isImageLoaded = true;
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            },
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
              return Text('Gagal memuat gambar');
            },
          ),
        ) 
        // : SizedBox.shrink(),

        // SizedBox(height: 5),

        // widget.canEdit ? MyButton(
        //   text: 'Hapus gambar',
        //   size: 5,
        //   fontSize: 12,
        //   paddingSize: 10,
        //   onTap: widget.deleteFunc(),
        // ) : SizedBox.shrink()
        // ElevatedButton(
        //   onPressed: () {
        //     setState(() {
        //       notDeleted = false;
        //     });
        //   },
        //   child: Text('Hapus Gambar'),
        // ),
      ],
    );
  }
}