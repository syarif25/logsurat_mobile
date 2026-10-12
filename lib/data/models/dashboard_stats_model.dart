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
  final Map<String, int> summary;
  final Map<String, dynamic> chartTrenBulanan;

  DashboardStatsModel({
    required this.posisiSurat,
    required this.rekapBulan,
    this.summary = const {},
    this.chartTrenBulanan = const {},
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    Map<String, int> posisi = {};
    List<RekapBulanModel> rekapList = [];
    Map<String, int> summaryMap = {};
    Map<String, dynamic> trenMap = {};

    if (json['data'] != null) {
      if (json['data']['summary'] != null) {
        (json['data']['summary'] as Map).forEach((k, v) {
          summaryMap[k.toString()] = (v is num) ? v.toInt() : 0;
        });
      }

      if (json['data']['chart_tren_bulanan'] != null) {
        trenMap = Map<String, dynamic>.from(json['data']['chart_tren_bulanan']);
      }

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
      summary: summaryMap,
      chartTrenBulanan: trenMap,
    );
  }
}
