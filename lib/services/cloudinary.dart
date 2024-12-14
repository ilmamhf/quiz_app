
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

Future<String?> uploadToCloudinary(File? image) async {
  if (image == null || !image.existsSync()) {
    print('No file selected');
    return null;
  }

  File file = File(image.path);
  String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';

  var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/raw/upload");
  var request = http.MultipartRequest("POST", uri);

  try {
    // Membaca file sebagai byte
    var fileBytes = await file.readAsBytes();
    var multipartFile = http.MultipartFile.fromBytes(
      'file', 
      fileBytes,
      filename: file.path.split("/").last,
    );

    request.files.add(multipartFile);
    request.fields['upload_preset'] = "demensiaapp-preset";
    request.fields['resource_type'] = "raw";

    // Kirim permintaan dengan timeout
    var response = await request.send().timeout(Duration(seconds: 10)); // Timeout 10 detik
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print("upload success");
      var jsonResponse = json.decode(responseBody);
      return jsonResponse['secure_url'];
    } else {
      print("upload failed with status: ${response.statusCode}");
      return null;
    }
  } on SocketException {
    // Penanganan jika tidak ada koneksi internet
    print("No internet connection");
    return null;
  } on TimeoutException {
    // Penanganan jika request melebihi batas waktu
    print("Request timed out");
    return null;
  } catch (e) {
    // Penanganan kesalahan lainnya
    print("An error occurred: $e");
    return null;
  }
}


// String getCloudinaryImageUrl(String publicId) {
//   String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
//   return 'https://res.cloudinary.com/$cloudName/image/upload/$publicId.jpg'; // Ganti .jpg dengan format yang sesuai
// }