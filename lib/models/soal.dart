class SoalPG {
  final String soal;
  // final String gambar;
  final List<String> listJawaban;
  final String jawabanBenar;
  String id;
  
  SoalPG({
    required this.soal,
    // required this.gambar,
    required this.listJawaban,
    required this.jawabanBenar,
    this.id = 'firebase document id',
  });
}


class SoalKognitif {
  final String soal;
  final String gambar;
  final String jawabanBenar;
  String id;
  final String video;
  
  SoalKognitif({
    required this.soal,
    this.gambar = '',
    required this.jawabanBenar,
    this.id = 'firebase document id',
    this.video = '',
  });
}