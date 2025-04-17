import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/tumbuhKembangResponse.dart';
import '../controllers/tumbuh_kembang_controller.dart';

class TumbuhKembangView extends GetView<TumbuhKembangController> {
  const TumbuhKembangView({super.key});

  // Halodoc theme colors
  static const Color primaryColor = Color(0xFF02B4B8); // Halodoc teal
  static const Color secondaryColor = Color(0xFF3A5998); // Halodoc blue
  static const Color accentColor = Color(0xFFFFA500); // Orange for accents
  static const Color backgroundColor = Color(0xFFF5F8FA); // Light background
  static const Color textColor = Color(0xFF2D3748); // Dark text

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: primaryColor),
                const SizedBox(height: 16),
                Text(
                  "Memuat data...",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      if (controller.tumbuhKembangList.isEmpty) {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.child_care, size: 64, color: primaryColor.withOpacity(0.5)),
                const SizedBox(height: 16),
                Text(
                  "Belum ada data tumbuh kembang",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => controller.loadData(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Coba Lagi"),
                ),
              ],
            ),
          ),
        );
      }

      return DefaultTabController(
        length: controller.tumbuhKembangList.length,
        initialIndex: controller.selectedIndex.value,
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 2,
            title: const Text(
              "Grafik Tumbuh Kembang",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () => _showInfoDialog(context),
              ),
            ],
            bottom: TabBar(
              isScrollable: true,
              onTap: (index) => controller.selectedIndex.value = index,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(fontSize: 14),
              tabs: controller.tumbuhKembangList
                  .map((e) => Tab(text: e.namaAnak))
                  .toList(),
            ),
          ),
          body: TabBarView(
            children: controller.tumbuhKembangList.map((anakData) {
              final riwayat = anakData.riwayat ?? [];
              
              if (riwayat.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.show_chart,
                        size: 64,
                        color: primaryColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Belum ada riwayat tumbuh kembang untuk ${anakData.namaAnak}",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              
              return _buildContentView(anakData, riwayat);
            }).toList(),
          ),
        ),
      );
    });
  }
  
  Widget _buildContentView(Data anakData, List<Riwayat> riwayat) {
    final latestRecord = riwayat.isNotEmpty ? riwayat.last : null;
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: primaryColor.withOpacity(0.2), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: primaryColor.withOpacity(0.2),
                          child: Text(
                            anakData.namaAnak?.substring(0, 1) ?? "A",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                anakData.namaAnak ?? "Nama tidak tersedia",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                "ID: ${anakData.idAnak ?? "Tidak tersedia"}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    if (latestRecord != null) ...[
                      Text(
                        "Data Terakhir (${_formatDate(latestRecord.tanggal ?? '')})",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildInfoCard(
                            Icons.monitor_weight_outlined,
                            "${latestRecord.beratBadan ?? 0} kg",
                            "Berat",
                            primaryColor,
                          ),
                          const SizedBox(width: 12),
                          _buildInfoCard(
                            Icons.height,
                            "${latestRecord.tinggiBadan ?? 0} cm",
                            "Tinggi",
                            secondaryColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildInfoCard(
                            Icons.radio_button_checked,
                            "${latestRecord.lingkarKepala ?? 0} cm",
                            "Lingkar Kepala",
                            accentColor,
                          ),
                          const SizedBox(width: 12),
                          _buildInfoCard(
                            Icons.accessibility_new,
                            "${latestRecord.lingkarLengan ?? 0} cm",
                            "Lingkar Lengan",
                            Colors.purple,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Chart Title
            Text(
              "Grafik Perkembangan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            
            // Legend
            Wrap(
              spacing: 24,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildLegendItem(primaryColor, "Berat (kg)"),
                _buildLegendItem(secondaryColor, "Tinggi (cm)"),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Chart
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 10,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 0.8,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 0.8,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < riwayat.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _formatDateShort(riwayat[index].tanggal ?? ''),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  minX: 0,
                  maxX: (riwayat.length - 1).toDouble(),
                  minY: 0,
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.white.withOpacity(0.8),
                      tooltipRoundedRadius: 8,
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((spot) {
                          final index = spot.x.toInt();
                          final date = riwayat[index].tanggal ?? '';
                          final value = spot.y.toInt();
                          final isWeight = spot.barIndex == 0;
                          
                          return LineTooltipItem(
                            '${_formatDate(date)}\n',
                            TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: '${isWeight ? "Berat: $value kg" : "Tinggi: $value cm"}',
                                style: TextStyle(
                                  color: isWeight ? primaryColor : secondaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          );
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    _generateLine(riwayat, 'berat', primaryColor),
                    _generateLine(riwayat, 'tinggi', secondaryColor),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // History Table
            Text(
              "Riwayat Tumbuh Kembang",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            
            // Table
            _buildHistoryTable(riwayat),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoCard(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: color,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  
  Widget _buildHistoryTable(List<Riwayat> riwayat) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Table(
          border: TableBorder(
            horizontalInside: BorderSide(
              width: 1,
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1.5),
            4: FlexColumnWidth(1.5),
          },
          children: [
            // Header
            TableRow(
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
              ),
              children: [
                _tableHeader("Tanggal"),
                _tableHeader("Berat (kg)"),
                _tableHeader("Tinggi (cm)"),
                _tableHeader("L. Kepala (cm)"),
                _tableHeader("L. Lengan (cm)"),
              ],
            ),
            // Data rows
            ...riwayat.reversed.map((record) {
              return TableRow(
                children: [
                  _tableCell(_formatDate(record.tanggal ?? '')),
                  _tableCell("${record.beratBadan ?? '-'}"),
                  _tableCell("${record.tinggiBadan ?? '-'}"),
                  _tableCell("${record.lingkarKepala ?? '-'}"),
                  _tableCell("${record.lingkarLengan ?? '-'}"),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
  
  Widget _tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
  
  Widget _tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        style: TextStyle(color: textColor),
        textAlign: TextAlign.center,
      ),
    );
  }
  
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.info, color: primaryColor),
              const SizedBox(width: 8),
              const Text("Tentang Tumbuh Kembang"),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Pemantauan tumbuh kembang anak sangat penting untuk memastikan perkembangan yang sehat. Grafik ini membantu Anda melacak berat dan tinggi anak seiring waktu.",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 12),
                Text(
                  "Beberapa tips untuk tumbuh kembang anak yang optimal:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 8),
                Text("• Pastikan anak mendapatkan nutrisi yang cukup"),
                Text("• Ajak anak untuk aktif bergerak dan bermain"),
                Text("• Lakukan pemeriksaan rutin ke dokter anak"),
                Text("• Perhatikan pola tidur yang cukup"),
                Text("• Berikan stimulasi yang sesuai dengan usianya"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
              ),
              child: const Text("Tutup"),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }
  
  LineChartBarData _generateLine(List<Riwayat> data, String tipe, Color color) {
    List<FlSpot> spots = [];

    for (int i = 0; i < data.length; i++) {
      double y = 0;
      switch (tipe) {
        case 'berat':
          y = (data[i].beratBadan ?? 0).toDouble();
          break;
        case 'tinggi':
          y = (data[i].tinggiBadan ?? 0).toDouble();
          break;
      }
      spots.add(FlSpot(i.toDouble(), y));
    }

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: Colors.white,
            strokeWidth: 2,
            strokeColor: color,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.15),
      ),
    );
  }
  
  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    
    try {
      final parts = dateString.split('-');
      if (parts.length < 3) return dateString;
      
      final months = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      
      final day = int.parse(parts[2]);
      final month = int.parse(parts[1]);
      final year = parts[0];
      
      return '$day ${months[month]} $year';
    } catch (e) {
      return dateString;
    }
  }
  
  String _formatDateShort(String dateString) {
    if (dateString.isEmpty) return '';
    
    try {
      final parts = dateString.split('-');
      if (parts.length < 3) return dateString;
      
      final day = parts[2];
      final month = parts[1];
      
      return '$day/$month';
    } catch (e) {
      return dateString;
    }
  }
}