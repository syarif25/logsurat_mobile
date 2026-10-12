class SuratMasukModel {
  final String nomorPengajuan;
  final String namaLembaga;
  final String perihal;
  final String tglMasuk;

  SuratMasukModel({
    required this.nomorPengajuan,
    required this.namaLembaga,
    required this.perihal,
    required this.tglMasuk,
  });

  factory SuratMasukModel.fromJson(Map<String, dynamic> json) {
    return SuratMasukModel(
      nomorPengajuan: json['nomor_pengajuan']?.toString() ?? '',
      namaLembaga: json['lembaga']?['name']?.toString() ?? '',
      perihal: json['perihal']?.toString() ?? '',
      tglMasuk: json['tgl_masuk']?.toString() ?? '',
    );
  }
}
