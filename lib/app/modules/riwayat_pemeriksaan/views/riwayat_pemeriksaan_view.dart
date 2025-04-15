import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/riwayat_pemeriksaan_controller.dart';

class RiwayatPemeriksaanView extends GetView<RiwayatPemeriksaanController> {
  const RiwayatPemeriksaanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pemeriksaan'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blue),
          );
        }

        if (controller.namaAnakList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_toggle_off,
                    size: 70, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  "Tidak ada data pemeriksaan",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 8),
              child: const Text(
                "Pilih Anak",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: controller.namaAnakList.length,
                itemBuilder: (context, index) {
                  final anakNama = controller.namaAnakList[index];
                  final isSelected =
                      index == controller.selectedAnakIndex.value;

                  return GestureDetector(
                    onTap: () => controller.selectedAnakIndex.value = index,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  Colors.blue.shade500,
                                  Colors.blue.shade700
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isSelected ? null : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                )
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          anakNama,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.article_outlined,
                      color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Riwayat Pemeriksaan",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900),
                  ),
                  const Spacer(),
                  Text(
                    "${controller.riwayatAnakTerpilih.length} data",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: controller.riwayatAnakTerpilih.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history_toggle_off,
                              size: 60, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            "Tidak ada data pemeriksaan untuk anak ini",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: controller.riwayatAnakTerpilih.length,
                      itemBuilder: (context, index) {
                        final item = controller.riwayatAnakTerpilih[index];

                        // Parse and format date for better display
                        String formattedDate;
                        try {
                          if (item.tanggalPemeriksaan != null) {
                            final parsedDate =
                                DateTime.parse(item.tanggalPemeriksaan!);
                            formattedDate =
                                DateFormat('dd MMMM yyyy').format(parsedDate);
                          } else {
                            formattedDate = '-'; // fallback kalau null
                          }
                        } catch (e) {
                          formattedDate = item.tanggalPemeriksaan ??
                              '-'; // fallback juga jika parsing gagal
                        }
                        final statusBerat =
                            getStatusText(item.beratBadan, "berat");
                        final statusTinggi =
                            getStatusText(item.tinggiBadan, "tinggi");

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.calendar_month,
                                            color: Colors.blue.shade700),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        formattedDate,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.verified,
                                                color: Colors.green.shade700,
                                                size: 16),
                                            const SizedBox(width: 4),
                                            Text(
                                              "Selesai",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.green.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Physical measurements
                                      const Text(
                                        "Pengukuran Fisik",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildMeasurementCard(
                                              "Berat Badan",
                                              "${item.beratBadan} kg",
                                              Icons.monitor_weight,
                                              Colors.orange.shade700,
                                              statusBerat,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _buildMeasurementCard(
                                              "Tinggi Badan",
                                              "${item.tinggiBadan} cm",
                                              Icons.height,
                                              Colors.purple.shade700,
                                              statusTinggi,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildMeasurementCard(
                                              "Lingkar Kepala",
                                              "${item.lingkarKepala} cm",
                                              Icons.circle,
                                              Colors.blue.shade700,
                                              null,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _buildMeasurementCard(
                                              "Lingkar Lengan",
                                              "${item.lingkarLengan} cm",
                                              Icons.accessibility_new,
                                              Colors.teal.shade700,
                                              null,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 16),
                                      // Nutrition & Health
                                      const Text(
                                        "Nutrisi & Kesehatan",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      _buildNutritionCard(
                                        "Pemberian ASI",
                                        item.asiYaTdk == 1 ? "Ya" : "Tidak",
                                        Icons.local_drink,
                                        item.asiYaTdk == 1
                                            ? Colors.green.shade700
                                            : Colors.red.shade700,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  String? getStatusText(dynamic value, String type) {
    // This is a simplified function. In a real app, you would check age and compare to growth charts
    // This is just to demonstrate the UI feature
    if (type == "berat") {
      return "Normal";
    } else if (type == "tinggi") {
      return "Normal";
    }
    return null;
  }

  Widget _buildMeasurementCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String? status,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (status != null) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.green.shade700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNutritionCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
