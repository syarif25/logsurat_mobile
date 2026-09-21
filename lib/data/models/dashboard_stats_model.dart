class RekapBulanDetailModel {
  final String jenis;
  final int jumlah;

  RekapBulanDetailModel({required this.jenis, required this.jumlah});

  factory RekapBulanDetailModel.fromJson(Map<String, dynamic> json) {
    return RekapBulanDetailModel(
      jenis: json['jenis'] ?? '',
      jumlah: json['jumlah'] ?? 0,
    );
  }
}

class RekapBulanModel {
  final String bulan;
  final List<RekapBulanDetailModel> details;

  RekapBulanModel({required this.bulan, required this.details});

  factory RekapBulanModel.fromJson(Map<String, dynamic> json) {
    var list = json['details'] as List? ?? [];
    List<RekapBulanDetailModel> detailsList =
        list.map((i) => RekapBulanDetailModel.fromJson(i)).toList();

    return RekapBulanModel(
      bulan: json['bulan'] ?? '',
      details: detailsList,
    );
  }
}

class DashboardStatsModel {
  final Map<String, int> posisiSurat;
  final List<RekapBulanModel> rekapBulan;

  DashboardStatsModel({
    required this.posisiSurat,
    required this.rekapBulan,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    Map<String, int> posisi = {};
    List<RekapBulanModel> rekapList = [];

    if (json['data'] != null) {
      if (json['data']['chart_posisi_surat'] != null) {
        final labels = List<String>.from(json['data']['chart_posisi_surat']['labels'] ?? []);
        final values = List<int>.from(json['data']['chart_posisi_surat']['values'] ?? []);
        
        for (int i = 0; i < labels.length; i++) {
          if (i < values.length) {
            posisi[labels[i]] = values[i];
          }
        }
      }

      if (json['data']['rekap_bulan'] != null) {
        var list = json['data']['rekap_bulan'] as List;
        rekapList = list.map((i) => RekapBulanModel.fromJson(i)).toList();
      }
    }

    return DashboardStatsModel(
      posisiSurat: posisi,
      rekapBulan: rekapList,
    );
  }
}
