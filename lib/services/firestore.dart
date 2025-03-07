import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/profil.dart';
import '../models/soal.dart';

class FirestoreService {
  Future<void> addID(DocumentReference docRef) async {
    try {
      // Simpan ID dokumen ke dalam dokumen itu sendiri
      await docRef.update({'id': docRef.id});
    } catch (e) {
      print('Gagal menambahkan ID: $e');
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  

  // ------------------------------------------- soal pilihan ganda
  // Fungsi untuk menambah soal ke Firestore
  Future<void> addSoalPGUmum(soalUmum, String tipe) async {
    try {
      DocumentReference docRef = await _firestore.collection('soal pg $tipe').add({
        'Soal': soalUmum.soal,
        'Jawaban': soalUmum.listJawaban,
        'Jawaban Benar': soalUmum.jawabanBenar,
        'Gambar': soalUmum.gambar
      });

      await addID(docRef);
      print('Dokumen berhasil dibuat dengan ID: ${docRef.id}');
    } catch (e) {
      print('Gagal menambah soal: $e');
    }
  }

  // Fungsi untuk memperbarui soal di Firestore
  Future<void> updateSoalPGUmum(SoalPG soalUmum, String tipe) async {
    try {
      await _firestore.collection('soal pg $tipe').doc(soalUmum.id).update({
        'Soal': soalUmum.soal,
        'Jawaban': soalUmum.listJawaban,
        'Jawaban Benar': soalUmum.jawabanBenar,
        'Gambar': soalUmum.gambar
      });
      print('Dokumen berhasil diperbarui dengan ID: ${soalUmum.id}');
    } catch (e) {
      print('Gagal memperbarui soal: $e');
    }
  }

  // Fungsi untuk menghapus soal di Firestore
  Future<void> deleteSoalPGUmum(soalId, String tipe) async {
    try {
      await _firestore.collection('soal pg $tipe').doc(soalId).delete();
      print('Dokumen dengan ID $soalId berhasil dihapus.');
    } catch (e) {
      print('Gagal menghapus dokumen: $e');
    }
  }

  // Fungsi untuk mengambil soal dari Firestore dan mengembalikannya sebagai list of Soal
  Future<List<SoalPG>> fetchSoalPGUmum(String tipe) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('soal pg $tipe').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return SoalPG(
          soal: data['Soal'],
          listJawaban: List<String>.from(data['Jawaban']),
          jawabanBenar: data['Jawaban Benar'],
          id: doc.id,
          gambar: data['Gambar'] ?? ''
        );
      }).toList();
    } catch (e) {
      print('Gagal mengambil soal: $e');
      return []; // Mengembalikan list kosong jika terjadi kesalahan
    }
  }

  // ------------------------------------------- soal kognitif
  // Fungsi untuk menambah soal ke Firestore
  Future<void> addSoalKognitifUmum(SoalKognitif soalKognitifUmum, String tipe) async {
    try {
      DocumentReference docRef = await _firestore.collection('soal kognitif $tipe').add({
        'Soal': soalKognitifUmum.soal,
        'Jawaban Benar': soalKognitifUmum.jawabanBenar,
        'Video': soalKognitifUmum.video,
        'Gambar': soalKognitifUmum.gambar
      });

      await addID(docRef);
      print('Dokumen berhasil dibuat dengan ID: ${docRef.id}');
    } catch (e) {
      print('Gagal menambah soal kognitif: $e');
    }
  }

  // Fungsi untuk mengambil soal dari Firestore dan mengembalikannya sebagai list of Soal
  Future<List<SoalKognitif>> fetchSoalKognitifUmum(String tipe) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('soal kognitif $tipe').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return SoalKognitif(
          soal: data['Soal'],
          jawabanBenar: data['Jawaban Benar'],
          id : doc.id,
          video: data['Video'] ?? '',
          gambar: data['Gambar'] ?? ''
        );
      }).toList();
    } catch (e) {
      print('Gagal mengambil soal kognitif: $e');
      return []; // Mengembalikan list kosong jika terjadi kesalahan
    }
  }

  // Fungsi untuk menghapus soal di Firestore
  Future<void> deleteSoalKognitifUmum(soalId, String tipe) async {
    try {
      await _firestore.collection('soal kognitif $tipe').doc(soalId).delete();
      print('Dokumen dengan ID $soalId berhasil dihapus.');
    } catch (e) {
      print('Gagal menghapus dokumen: $e');
    }
  }

  // Fungsi untuk memperbarui soal di Firestore
  Future<void> updateSoalKognitifUmum(SoalKognitif soalUmum, String tipe) async {
    try {
      await _firestore.collection('soal kognitif $tipe').doc(soalUmum.id).update({
        'Soal': soalUmum.soal,
        'Jawaban Benar': soalUmum.jawabanBenar,
        'Gambar' : soalUmum.gambar
      });
      print('Dokumen berhasil diperbarui dengan ID: ${soalUmum.id}');
    } catch (e) {
      print('Gagal memperbarui soal kognitif: $e');
    }
  }

  // ------------------------------------------ soal video
  // Fungsi untuk menambah soal ke Firestore
  Future<void> addSoalVideoUmum(SoalKognitif soalKognitifUmum, String tipe) async {
    try {
      DocumentReference docRef = await _firestore.collection('soal video $tipe').add({
        'Soal': soalKognitifUmum.soal,
        'Jawaban Benar': soalKognitifUmum.jawabanBenar,
        'Video': soalKognitifUmum.video,
        'Gambar': soalKognitifUmum.gambar
      });

      await addID(docRef);
      print('Dokumen berhasil dibuat dengan ID: ${docRef.id}');
    } catch (e) {
      print('Gagal menambah soal video: $e');
    }
  }

  // Fungsi untuk mengambil soal dari Firestore dan mengembalikannya sebagai list of Soal
  Future<List<SoalKognitif>> fetchSoalVideoUmum(String tipe) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('soal video $tipe').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return SoalKognitif(
          soal: data['Soal'],
          jawabanBenar: data['Jawaban Benar'],
          id : doc.id,
          video: data['Video'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Gagal mengambil soal video: $e');
      return []; // Mengembalikan list kosong jika terjadi kesalahan
    }
  }

  // Fungsi untuk menghapus soal di Firestore
  Future<void> deleteSoalVideoUmum(soalId, String tipe) async {
    try {
      await _firestore.collection('soal video $tipe').doc(soalId).delete();
      print('Dokumen dengan ID $soalId berhasil dihapus.');
    } catch (e) {
      print('Gagal menghapus dokumen: $e');
    }
  }

  // Fungsi untuk memperbarui soal di Firestore
  Future<void> updateSoalVideoUmum(SoalKognitif soalUmum, String tipe) async {
    try {
      await _firestore.collection('soal video $tipe').doc(soalUmum.id).update({
        'Soal': soalUmum.soal,
        'Jawaban Benar': soalUmum.jawabanBenar,
      });
      print('Dokumen berhasil diperbarui dengan ID: ${soalUmum.id}');
    } catch (e) {
      print('Gagal memperbarui soal video: $e');
    }
  }


  // Fungsi untuk menambah user admin/evaluator
  Future<void> addUser(Profil userProfile) async {
    try {
      await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser !.uid).set({
        'Nama Lengkap': userProfile.nama,
        'Tanggal Lahir': userProfile.tglLahir,
        'Jenis Kelamin': userProfile.jenisKelamin,
        'No HP': userProfile.noHP,
        'Role': userProfile.role,
        // 'evaluatorID': null,
      });
    } catch (e) {
      print('Gagal menambah admin: $e');
    }
  }

  // Fungsi untuk mengupdate admin / evaluator 
  Future<void> updateAccount(Profil userProfile) async {
    try {
      await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser !.uid).update({
        'Nama Lengkap': userProfile.nama,
        'Tanggal Lahir': userProfile.tglLahir,
        'Jenis Kelamin': userProfile.jenisKelamin,
        'No HP': userProfile.noHP,
      });
    } catch (e) {
      print('Gagal memperbarui admin: $e');
    }
  }

  // Fungsi untuk menambah evaluator
  Future<void> addEvaluator(Profil userProfile) async {
    try {
      await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser !.uid).set({
        'Nama Lengkap': userProfile.nama,
        'Tanggal Lahir': userProfile.tglLahir,
        'Jenis Kelamin': userProfile.jenisKelamin,
        'No HP': userProfile.noHP,
        'Role': 'Evaluator',
        'evaluatorID': userProfile.evaluatorID,
      });
    } catch (e) {
      print('Gagal menambah evaluator: $e');
    }
  }

  // // Fungsi untuk mengupdate evaluator
  // Future<void> updateEvaluator(Profil userProfile) async {
  //   try {
  //     await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser !.uid).update({
  //       'Nama Lengkap': userProfile.nama,
  //       'Tanggal Lahir': userProfile.tglLahir,
  //       'Jenis Kelamin': userProfile.jenisKelamin,
  //       'No HP': userProfile.noHP,
  //     });
  //   } catch (e) {
  //     print('Gagal memperbarui evaluator: $e');
  //   }
  // }

  // Fungsi untuk menambah user (hanya bisa dilakukan oleh evaluator)
  Future<void> addUserByEvaluator(Profil userProfile, String userID) async {
    try {
      await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser !.uid + userID).set({
        'Nama Lengkap': userProfile.nama,
        'Tanggal Lahir': userProfile.tglLahir,
        'Jenis Kelamin': userProfile.jenisKelamin,
        'No HP': userProfile.noHP,
        'Role': 'User ',
        'evaluatorID': FirebaseAuth.instance.currentUser !.uid,
        'userID': userID,
        'password': userProfile.password,
      });
    } catch (e) {
      print('Gagal menambah user: $e');
    }
  }

  // Fungsi untuk mengupdate user (hanya bisa dilakukan oleh evaluator yang terkait)
  Future<void> updateUserByEvaluator(Profil userProfile, String userID) async {
    try {
      await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser !.uid + userID).update({
        'Nama Lengkap': userProfile.nama,
        'Tanggal Lahir': userProfile.tglLahir,
        'Jenis Kelamin': userProfile.jenisKelamin,
        'No HP': userProfile.noHP,
        'password': userProfile.password
      });
    } catch (e) {
      print('Gagal memperbarui user: $e');
    }
  }

  // Fungsi untuk menghapus user berdasarkan userID
  Future<void> deleteUser(String userID) async {
    try {
      // Referensi ke koleksi 'users' di Firestore
      DocumentReference userDoc = _firestore.collection('users').doc(userID);

      // Hapus dokumen user berdasarkan userID
      await userDoc.delete();

      print('User dengan ID $userID berhasil dihapus.');
    } catch (e) {
      print('Error saat menghapus user: $e');
    }
  }

  // Fungsi untuk mengecek ketersediaan userID
  Future<bool> cekKetersediaanUsername(String userID) async {
    String evaluatorID = FirebaseAuth.instance.currentUser !.uid;
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

  // Fungsi untuk mengambil semua evaluator
  Future<List<Profil>> fetchEvaluators() async {
    try {
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
    } catch (e) {
      print('Gagal mengambil evaluator: $e');
      return []; // Mengembalikan list kosong jika terjadi kesalahan
    }
  }

  // Fungsi untuk mengambil semua user yang diakses oleh evaluator tertentu
  Future<List<Profil>> fetchUsersAsEvaluator(String evaluatorID) async {
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
          password: data['password'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching users as evaluator: $e');
      return []; // Mengembalikan list kosong jika terjadi kesalahan
    }
  }

  // Fungsi untuk mengambil semua user
  Future<List<Profil>> fetchAllUserAsAdmin(String tipe, String? evaluatorID) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('Role', isEqualTo: tipe)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Profil(
          nama: data['Nama Lengkap'],
          tglLahir: data['Tanggal Lahir'],
          jenisKelamin: data['Jenis Kelamin'],
          noHP: data['No HP'],
          role: data['Role'],
          evaluatorID: data['evaluatorID'] ?? '-', // Evaluator tidak memiliki evaluatorID
          username: data['userID'],
          password: data['password'] ?? '-',
        );
      }).toList();
    } catch (e) {
      print('Gagal mengambil semua user: $e');
      return []; // Mengembalikan list kosong jika terjadi kesalahan
    }
  }

  // get nama
  Future<String> getFullName() async {
    try {
      User? currentUser  = FirebaseAuth.instance.currentUser ;
      if (currentUser  != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser .uid)
            .get();

        if (userDoc.exists) {
          return userDoc['Nama Lengkap'] ?? 'Nama tidak tersedia';
        } else {
          return 'Dokumen tidak ditemukan';
        }
      } else {
        return 'Pengguna tidak terautentikasi';
      }
    } catch (e) {
      // Menangkap kesalahan dan mengembalikan pesan kesalahan
      return 'Tidak Ada Koneksi!';
    }
  }

  // Fungsi untuk mengambil profil user saat ini berdasarkan userID
  Future<Profil?> fetchCurrentUserProfile(String userID) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('userID', isEqualTo: userID)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data() as Map<String, dynamic>;
        return Profil(
          nama: data['Nama Lengkap'],
          tglLahir: data['Tanggal Lahir'],
          jenisKelamin: data['Jenis Kelamin'],
          noHP: data['No HP'],
          role: data['Role'],
          evaluatorID: data['evaluatorID'] ?? '',
          username: data['userID'],
          password: data['password'] ?? '',
        );
      } else {
        print('User  not found');
        return null; // Mengembalikan null jika user tidak ditemukan
      }
    } catch (e) {
      print('Error fetching current user profile: $e');
      return null; // Mengembalikan null jika terjadi kesalahan
    }
  }
}