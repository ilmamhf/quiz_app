import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/profil.dart';
import '../pages/start_pages/home_page.dart';
import '../pages/start_pages/login_page.dart';

class AuthService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign up
  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    
    try {

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const HomePage()
        )
      );
      
    } on FirebaseAuthException catch(e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
       Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
    catch(e){
    }
  }

  // sign in
  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    
    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const HomePage()
        )
      );
      
    } on FirebaseAuthException catch(e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
      }
       Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
    catch(e){
    }
  }

  // sign out
  Future<void> signout({
    required BuildContext context
  }) async {
    
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>LoginPage()
        )
      );
  }

  // get UID
  Future<String?> getCurrentFirebaseUserID() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      return user?.uid; // Mengembalikan UID user jika login, atau null jika tidak
    } catch (e) {
      print('Error getting current Firebase user UID: $e');
      return null; // Mengembalikan null jika terjadi kesalahan
    }
  }
  
  // Fake sign in function
  Future<bool> fakeSignIn(String username, String password) async {
    print(username+password);
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('userID', isEqualTo: username)
        .get();

    // Memeriksa apakah ada dokumen yang ditemukan
    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      // Memeriksa apakah password cocok
      if (data['password'] == password) {
        return true; // Sign in berhasil
      } else {
        return false; // Password salah
      }
    }

    return false; // Username tidak ditemukan
  }

  // cek username
  Future<bool> cekUsername(String username) async {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('userID', isEqualTo: username)
        .get();

    // Memeriksa apakah ada dokumen yang ditemukan
    if (snapshot.docs.isNotEmpty) {
      return true;
    }

    return false; // Username tidak ditemukan
  }

  // cek role
  Future<bool> cekRole(String username, String role) async {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('userID', isEqualTo: username)
        .where('Role', isEqualTo: role)
        .get();

    // Memeriksa apakah ada dokumen yang ditemukan
    if (snapshot.docs.isNotEmpty) {
      return true;
    }

    return false; // Username tidak ditemukan
  }

  // Function to convert Firestore document to Profil object
  Profil profilFromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Profil(
      nama: data['Nama Lengkap'] ?? '',
      tglLahir: data['Tanggal Lahir'] ?? Timestamp.now(),
      jenisKelamin: data['Jenis Kelamin'] ?? '',
      noHP: data['No HP'] ?? '',
      role: data['Role'] ?? '',
      evaluatorID: data['evaluatorID'],
      username: data['userID'],
      password: data['password'],
    );
  }

  // Function to get Profil by username
  Future<Profil?> getProfilByUsername(String username) async {
    try {
      // Get the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query the collection where username matches
      QuerySnapshot querySnapshot = await firestore
          .collection('users') // Ganti dengan nama koleksi Anda
          .where('userID', isEqualTo: username)
          .get();

      // Check if any documents were found
      if (querySnapshot.docs.isNotEmpty) {
        // Return the first document as a Profil object
        return profilFromFirestore(querySnapshot.docs.first);
      } else {
        // No document found
        return null;
      }
    } catch (e) {
      print('Error getting profil: $e');
      return null;
    }
  }

  // // sign in user biasa
  // Future<Profil?> signInAsUser () async {
  //   QuerySnapshot snapshot = await _firestore
  //       .collection('users')
  //       .where('Role', isEqualTo: 'User ')
  //       .limit(1) // Mengambil hanya satu dokumen
  //       .get();

  //   // Memeriksa apakah ada dokumen yang ditemukan
  //   if (snapshot.docs.isNotEmpty) {
  //     final data = snapshot.docs.first.data() as Map<String, dynamic>;
  //     return Profil(
  //       nama: data['Nama Lengkap'],
  //       tglLahir: data['Tanggal Lahir'],
  //       jenisKelamin: data['Jenis Kelamin'],
  //       noHP: data['No HP'],
  //       role: data['Role'],
  //       evaluatorID: data['evaluatorID'],
  //     );
  //   }

  //   // Mengembalikan null jika tidak ada dokumen yang ditemukan
  //   return null;
  // }
}