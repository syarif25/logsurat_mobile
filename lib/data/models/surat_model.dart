class SuratModel {
  final String? idPengajuan;
  final String? nomorPengajuan;
  final String? perihal;
  final String? tglMasuk;
  final String? lembaga;
  final String? jenisSurat;
  final String? posisiSekarang;
  final String? fileUrl;
  final String? status;
  final List<LogSuratModel> histori;

  SuratModel({
    this.idPengajuan,
    this.nomorPengajuan,
    this.perihal,
    this.tglMasuk,
    this.lembaga,
    this.jenisSurat,
    this.posisiSekarang,
    this.fileUrl,
    this.status,
    this.histori = const [],
  });

  factory SuratModel.fromJson(Map<String, dynamic> json) {
    List<LogSuratModel> historiList = [];
    if (json['histori'] != null) {
      historiList = (json['histori'] as List)
          .map((i) => LogSuratModel.fromJson(i))
          .toList();
    }

    return SuratModel(
      idPengajuan: json['id_pengajuan']?.toString(),
      nomorPengajuan: json['nomor_pengajuan']?.toString(),
      perihal: json['perihal']?.toString(),
      tglMasuk: json['tgl_masuk']?.toString(),
      lembaga: json['lembaga']?['name']?.toString(),
      jenisSurat: json['jenis_surat']?['jenis_surat']?.toString(),
      posisiSekarang: json['posisi_sekarang']?['nama_jabatan']?.toString(),
      fileUrl: json['file_url']?.toString(),
      status: json['status']?.toString(),
      histori: historiList,
    );
  }
}

class LogSuratModel {
  final String? idLog;
  final String? posisi;
  final String? status;
  final String? catatan;
  final String? fileUrl;
  final String? tglLog;

  LogSuratModel({
    this.idLog,
    this.posisi,
    this.status,
    this.catatan,
    this.fileUrl,
    this.tglLog,
  });

  factory LogSuratModel.fromJson(Map<String, dynamic> json) {
    return LogSuratModel(
      idLog: json['id_log']?.toString(),
      posisi: json['posisi']?['nama_jabatan']?.toString(),
      status: json['status']?.toString(),
      catatan: json['catatan']?.toString(),
      fileUrl: json['file_url']?.toString(),
      tglLog: json['tgl_log']?.toString(),
    );
  }
}
