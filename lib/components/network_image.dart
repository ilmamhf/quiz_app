import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  final String imageUrl;

  ImageDisplay({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover, // Atur sesuai kebutuhan
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
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
    );
  }
}