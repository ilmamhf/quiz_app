import 'package:cloud_firestore/cloud_firestore.dart';

class Profil {
  final String nama;
  final Timestamp tglLahir;
  final String jenisKelamin;
  final String noHP;
  final String role; // Bisa 'admin', 'evaluator', atau 'user'
  final String? evaluatorID; // null untuk admin dan evaluator, berisi evaluator ID untuk user
  final String? username; // username untuk user

  Profil({
    required this.nama,
    required this.tglLahir,
    required this.jenisKelamin,
    required this.noHP,
    required this.role,
    this.evaluatorID,
    this.username
  });
}

