import 'dart:io';

import 'package:demensia_app/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyImagePicker extends StatefulWidget {
  final Function(File?) onImageSelected;
  
  const MyImagePicker({
    super.key,
    required this.onImageSelected,
  });

  @override
  State<MyImagePicker> createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {

  File? _selectedImage;

  Future<void> _pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (returnedImage != null) {
      setState(() {
        _selectedImage = File(returnedImage.path);
      });
      widget.onImageSelected(_selectedImage);
    } else {
      print('No Image Picked');
    }
  }
  
  @override
  Widget build(BuildContext context) {

    // _selectedImage = widget.imageController;
    
    return Column(
      children: [
        _selectedImage != null ? 
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 220,
            height: 220,
            child: Image.file(_selectedImage!, fit: BoxFit.contain,)
          ),
        ) 
        : SizedBox.shrink(),
        _selectedImage != null ? SizedBox(height: 5,) : SizedBox.shrink(),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MyButton(
              text: _selectedImage == null ? 'Pilih gambar' : 'Ganti gambar',
              size: 5,
              fontSize: 12,
              paddingSize: _selectedImage == null ? 80 : 10,
              onTap: () {
                _pickImageFromGallery();
              },
            ),

            _selectedImage != null 
              ? MyButton(
                text: 'Hapus gambar',
                size: 5,
                fontSize: 12,
                paddingSize: 10,
                onTap: () {
                  setState(() {
                    _selectedImage = null;
                  // Clear the image cache
                  PaintingBinding.instance.imageCache.clear();
                  print('gambar terhapus');
                  });
                },
              ) : SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}


