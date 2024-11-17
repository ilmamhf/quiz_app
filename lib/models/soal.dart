class Soal {
  final String soal;
  // final String gambar;
  final List<String> listJawaban;
  final String jawabanBenar;
  String id;
  
  Soal({
    required this.soal,
    // required this.gambar,
    required this.listJawaban,
    required this.jawabanBenar,
    this.id = 'firebase document id',
  });
}

class SoalKognitif {
  final String soal;
  // final String gambar;
  final String jawabanBenar;
  
  SoalKognitif({
    required this.soal,
    // required this.gambar,
    required this.jawabanBenar,
  });
}