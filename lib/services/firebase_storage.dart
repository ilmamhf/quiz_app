// import 'package:image_picker/image_picker.dart';

// Future<String?> uploadImage(XFile image) async {
//   try {
//     // Mendapatkan referensi ke Firebase Storage
//     final storageRef = FirebaseStorage.instance.ref();
    
//     // Membuat referensi untuk gambar yang akan diupload
//     final imageRef = storageRef.child('images/${image.name}');
    
//     // Mengupload gambar
//     await imageRef.putFile(File(image.path));
    
//     // Mendapatkan URL gambar setelah diupload
//     String downloadUrl = await imageRef.getDownloadURL();
//     return downloadUrl;
//   } catch (e) {
//     print('Gagal mengupload gambar: $e');
//     return null;
//   }
// }