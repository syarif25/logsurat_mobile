import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> surat = Get.arguments ?? {
      'perihal': 'Detail Surat',
      'pengirim': 'Unknown'
    };

    // Dummy Tracking Data
    final List<Map<String, dynamic>> trackingData = [
      {
        'waktu': '02 Sep 2026 10:30',
        'posisi': 'Kabag',
        'keterangan': 'Surat sedang diproses oleh Kabag',
        'status': 'current'
      },
      {
        'waktu': '01 Sep 2026 14:00',
        'posisi': 'Ka. TU',
        'keterangan': 'Disposisi dari Ka. TU ke Kabag',
        'status': 'done'
      },
      {
        'waktu': '01 Sep 2026 10:00',
        'posisi': 'Staf',
        'keterangan': 'Surat masuk diregistrasi oleh Staf',
        'status': 'done'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lacak Surat'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  surat['perihal'],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text('Pengirim: ${surat['pengirim']}'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: trackingData.length,
              itemBuilder: (context, index) {
                final track = trackingData[index];
                final isLast = index == trackingData.length - 1;
                final isCurrent = track['status'] == 'current';

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCurrent
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade400,
                              border: isCurrent
                                  ? Border.all(color: Colors.white, width: 3)
                                  : null,
                              boxShadow: isCurrent
                                  ? [
                                      BoxShadow(
                                        color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      )
                                    ]
                                  : null,
                            ),
                          ),
                          if (!isLast)
                            Expanded(
                              child: Container(
                                width: 2,
                                color: Colors.grey.shade300,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                track['posisi'],
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isCurrent
                                          ? Theme.of(context).primaryColor
                                          : Colors.black87,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                track['keterangan'],
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                track['waktu'],
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
