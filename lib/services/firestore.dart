import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/profil.dart';
import '../models/soal.dart';

class FirestoreService {
  Future<void> addID(DocumentReference docRef) async {
    // Simpan ID dokumen ke dalam dokumen itu sendiri
      await docRef.update({'id': docRef.id});
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // final DocumentReference blokUser =
  //   FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
    
// ------------------------------------------- soal pilihan ganda
  // Fungsi untuk menambah soal ke Firestore
  Future<void> addSoalPGUmum(soalUmum, String tipe) async {
    DocumentReference docRef = await _firestore.collection('soal pg $tipe').add({
        'Soal': soalUmum.soal,
        'Jawaban': soalUmum.listJawaban,
        'Jawaban Benar': soalUmum.jawabanBenar,
      });

      addID(docRef);

      print('Dokumen berhasil dibuat dengan ID: ${docRef.id}');
  }

  // Fungsi untuk memperbarui soal di Firestore
  Future<void> updateSoalPGUmum(SoalPG soalUmum, String tipe) async {
    await _firestore.collection('soal pg $tipe').doc(soalUmum.id).update({
      'Soal': soalUmum.soal,
      'Jawaban': soalUmum.listJawaban,
      'Jawaban Benar': soalUmum.jawabanBenar,
    });
    print('Dokumen berhasil diperbarui dengan ID: ${soalUmum.id}');
  }

  // Fungsi untuk menghapus soal di Firestore
  Future<void> deleteSoalPGUmum(soalId) async {
    try {
      await _firestore.collection('soal pg umum').doc(soalId).delete();
      print('Dokumen dengan ID $soalId berhasil dihapus.');
    } catch (e) {
      print('Gagal menghapus dokumen: $e');
    }
  }

  // Fungsi untuk mengambil soal dari Firestore dan mengembalikannya sebagai list of Soal
  Future<List<SoalPG>> fetchSoalPGUmum(String tipe) async {
    QuerySnapshot snapshot = await _firestore.collection('soal pg $tipe').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return SoalPG(
        soal: data['Soal'],
        listJawaban: List<String>.from(data['Jawaban']),
        jawabanBenar: data['Jawaban Benar'],
        id: doc.id
      );
    }).toList();
  }

// ------------------------------------------- soal kognitif
  // Fungsi untuk menambah soal ke Firestore
  Future<void> addSoalKognitifUmum(SoalKognitif soalKognitifUmum) async {
    DocumentReference docRef = await _firestore.collection('soal kognitif umum').add({
      'Soal': soalKognitifUmum.soal,
      'Jawaban Benar': soalKognitifUmum.jawabanBenar
    });

    addID(docRef);

      print('Dokumen berhasil dibuat dengan ID: ${docRef.id}');
  }

  // Fungsi untuk mengambil soal dari Firestore dan mengembalikannya sebagai list of Soal
  Future<List<SoalKognitif>> fetchSoalKognitifUmum(String tipe) async {
    QuerySnapshot snapshot = await _firestore.collection('soal kognitif $tipe').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return SoalKognitif(
        soal: data['Soal'],
        jawabanBenar: data['Jawaban Benar'],
        id: doc.id
      );
    }).toList();
  }

  // Fungsi untuk menghapus soal di Firestore
  Future<void> deleteSoalKognitifUmum(soalId) async {
    try {
      await _firestore.collection('soal kognitif umum').doc(soalId).delete();
      print('Dokumen dengan ID $soalId berhasil dihapus.');
    } catch (e) {
      print('Gagal menghapus dokumen: $e');
    }
  }

  // Fungsi untuk memperbarui soal di Firestore
  Future<void> updateSoalKognitifUmum(SoalKognitif soalUmum) async {
    await _firestore.collection('soal kognitif umum').doc(soalUmum.id).update({
      'Soal': soalUmum.soal,
      'Jawaban Benar': soalUmum.jawabanBenar,
    });
    print('Dokumen berhasil diperbarui dengan ID: ${soalUmum.id}');
  }
  
  // Future<void> addUserDefault(String userID, userProfile) {
  // return FirebaseFirestore.instance.collection('users').doc(userID).set({
  //   'Nama Lengkap': userProfile.nama,
  //   'Tanggal Lahir': userProfile.tglLahir,
  //   'Jenis Kelamin': userProfile.jenisKelamin,
  //   'No HP': userProfile.noHP,
    
  //   });
  // }

  // Future<void> updateUserDefault(userProfile) {
  //   return blokUser.update({
  //     'Nama Lengkap': userProfile.nama,
  //     'Tanggal Lahir': userProfile.tglLahir,
  //     'Jenis Kelamin': userProfile.jenisKelamin,
  //     'No HP': userProfile.noHP,
  //   });
  // }

// ----------------------------------------------------- add, update user sesuai role
  // ------------------------------------------- admin
  // Fungsi untuk menambah admin
  Future<void> addAdmin(Profil userProfile) async {
    await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
      'Nama Lengkap': userProfile.nama,
      'Tanggal Lahir': userProfile.tglLahir,
      'Jenis Kelamin': userProfile.jenisKelamin,
      'No HP': userProfile.noHP,
      'Role': 'Admin',
      'evaluatorID': null,
    });
  }

  // Fungsi untuk mengupdate admin
  Future<void> updateAdmin(Profil userProfile) async {
    await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'Nama Lengkap': userProfile.nama,
      'Tanggal Lahir': userProfile.tglLahir,
      'Jenis Kelamin': userProfile.jenisKelamin,
      'No HP': userProfile.noHP,
    });
  }

  // ------------------------------------------ evaluator

  // Fungsi untuk menambah evaluator
  Future<void> addEvaluator(Profil userProfile) async {
    await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
      'Nama Lengkap': userProfile.nama,
      'Tanggal Lahir': userProfile.tglLahir,
      'Jenis Kelamin': userProfile.jenisKelamin,
      'No HP': userProfile.noHP,
      'Role': 'Evaluator',
      'evaluatorID': userProfile.evaluatorID,
    });
  }

  // Fungsi untuk mengupdate evaluator
  Future<void> updateEvaluator(Profil userProfile) async {
    await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'Nama Lengkap': userProfile.nama,
      'Tanggal Lahir': userProfile.tglLahir,
      'Jenis Kelamin': userProfile.jenisKelamin,
      'No HP': userProfile.noHP,
    });
  }

  //--------------------------------------------- user biasa

  // Fungsi untuk menambah user (hanya bisa dilakukan oleh evaluator)
  Future<void> addUserByEvaluator(Profil userProfile, String userID) async {
    await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid+userID).set({
      'Nama Lengkap': userProfile.nama,
      'Tanggal Lahir': userProfile.tglLahir,
      'Jenis Kelamin': userProfile.jenisKelamin,
      'No HP': userProfile.noHP,
      'Role': 'User',
      'evaluatorID': FirebaseAuth.instance.currentUser!.uid,
      'userID': userID,
      'password': userProfile.password
    });
  }

  // Fungsi untuk mengupdate user (hanya bisa dilakukan oleh evaluator yang terkait)
  Future<void> updateUserByEvaluator(Profil userProfile, String userID) async {
    await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid+userID).update({
      'Nama Lengkap': userProfile.nama,
      'Tanggal Lahir': userProfile.tglLahir,
      'Jenis Kelamin': userProfile.jenisKelamin,
      'No HP': userProfile.noHP,
    });
  }

  // Fungsi untuk mengecek ketersediaan userID
  Future<bool> cekKetersediaanUsername(String userID) async {
    String evaluatorID = FirebaseAuth.instance.currentUser!.uid;
    String combinedUserID = evaluatorID + userID; // nama dokumen

    try {
      // Mendapatkan dokumen dengan ID yang dikombinasikan
      final docSnapshot = await _firestore.collection('users').doc(combinedUserID).get();

      // Jika dokumen tidak ada, userID tersedia
      return !docSnapshot.exists;
    } catch (e) {
      print("Error checking userID availability: $e");
      return false; // Jika terjadi error, anggap tidak tersedia
    }
  }


//----------------------------------------- ambil data / fetch

  // Fungsi untuk mengambil semua evaluator
  Future<List<Profil>> fetchEvaluators() async {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('Role', isEqualTo: 'Evaluator')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Profil(
        nama: data['Nama Lengkap'],
        tglLahir: data['Tanggal Lahir'],
        jenisKelamin: data['Jenis Kelamin'],
        noHP: data['No HP'],
        role: data['Role'],
        evaluatorID: null, // Evaluator tidak memiliki evaluatorID
      );
    }).toList();
  }

  // Fungsi untuk mengambil semua user yang diakses oleh evaluator tertentu
  Future<List<Profil>> fetchUsersAsEvaluator(String evaluatorID) async {
    print(evaluatorID);
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('Role', isEqualTo: 'User')
          .where('evaluatorID', isEqualTo: evaluatorID)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Profil(
          nama: data['Nama Lengkap'],
          tglLahir: data['Tanggal Lahir'],
          jenisKelamin: data['Jenis Kelamin'],
          noHP: data['No HP'],
          role: data['Role'],
          evaluatorID: data['evaluatorID'],
          username: data['userID'],
          password: data['password']
        );
      }).toList();
    } catch (e) {
      // Menangani kesalahan
      print('Error fetching users as evaluator: $e');
      return []; // Mengembalikan list kosong jika terjadi kesalahan
    }
  }

  // Fungsi untuk mengambil semua user
  Future<List<Profil>> fetchAllUserAsAdmin() async {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('Role', isEqualTo: 'User')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Profil(
        nama: data['Nama Lengkap'],
        tglLahir: data['Tanggal Lahir'],
        jenisKelamin: data['Jenis Kelamin'],
        noHP: data['No HP'],
        role: data['Role'],
        evaluatorID: data['evaluatorID'], // Evaluator tidak memiliki evaluatorID
      );
    }).toList();
  }


  // get nama
  Future<String> getFullName() async {
    User? currentUser  = FirebaseAuth.instance.currentUser ;
    if (currentUser  != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        return userDoc['Nama Lengkap'] ?? 'Nama tidak tersedia';
      } else {
        return 'Dokumen tidak ditemukan';
      }
    } else {
      return 'Pengguna tidak terautentikasi';
    }
  }

  // DELETE: delete blocks given a doc id
  // Future<void> deleteGizi(String docID) {
  //   return blocks.doc(docID).delete();
  // }

  // Future<void> deleteAktifitas(String docID) {
  //   return blokAktifitas.doc(docID).delete();
  // }

}