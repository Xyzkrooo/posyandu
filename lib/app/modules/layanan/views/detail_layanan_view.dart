import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/layanan_controller.dart';

class DetailLayananView extends StatelessWidget {
  final String slug;

  DetailLayananView({required this.slug}) {
    final controller = Get.put(LayananController());
    controller.getLayananDetail(slug);
  }

  final controller = Get.find<LayananController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      body: Obx(() {
        if (controller.isLoadingDetail.value) {
          return const Center(
              child: CircularProgressIndicator(
            color: Color(0xFF3A9EC1),
          ));
        }

        final layanan = controller.layananDetail.value;

        if (layanan == null) {
          return _buildErrorState();
        }

        return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 220.0,
                floating: false,
                pinned: true,
                backgroundColor: const Color(0xFF3A9EC1),
                elevation: 0,
                leading: InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                actions: [
                  InkWell(
                    onTap: () {
                      Share.share(
                          'Lihat informasi tentang layanan ${layanan.namaLyn} di aplikasi Posyandu');
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.share_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (layanan.gambarLyn != null &&
                          layanan.gambarLyn!.isNotEmpty)
                        CachedNetworkImage(
                          imageUrl: layanan.gambarLyn!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: const Color(0xFF3A9EC1),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: const Color(0xFF3A9EC1),
                            child: const Icon(
                              Icons.medical_services_outlined,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      // Gradient overlay for better text visibility
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                      // Title and category at the bottom
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (layanan.jenisLyn != null &&
                                layanan.jenisLyn!.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  layanan.jenisLyn!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8),
                            Text(
                              layanan.namaLyn ?? 'Detail Layanan',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 3,
                                    color: Color.fromARGB(150, 0, 0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info card section
                _buildInfoCard(layanan),

                // Content sections
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Keterangan section
                      if (layanan.keteranganLyn != null &&
                          layanan.keteranganLyn!.isNotEmpty)
                        _buildContentSection(
                          title: 'Keterangan',
                          icon: Icons.info_outline,
                          content: layanan.keteranganLyn!,
                          iconColor: const Color(0xFF3A9EC1),
                        ),

                      // Manfaat section
                      if (layanan.manfaatLyn != null &&
                          layanan.manfaatLyn!.isNotEmpty)
                        _buildContentSection(
                          title: 'Manfaat',
                          icon: Icons.check_circle_outline,
                          content: layanan.manfaatLyn!,
                          iconColor: const Color(0xFF4CAF50),
                        ),

                      // Larangan section
                      if (layanan.laranganLyn != null &&
                          layanan.laranganLyn!.isNotEmpty)
                        _buildContentSection(
                          title: 'Larangan',
                          icon: Icons.warning_amber_outlined,
                          content: layanan.laranganLyn!,
                          iconColor: const Color(0xFFFF9800),
                        ),

                      const SizedBox(height: 24),

                      // Registration and information button
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard(dynamic layanan) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (layanan.keteranganSingkat != null &&
              layanan.keteranganSingkat!.isNotEmpty)
            Text(
              layanan.keteranganSingkat!,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF666666),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              // Age range info
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1F5FE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.cake_outlined,
                        color: Color(0xFF0288D1),
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Usia',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF757575),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${layanan.usiaMinimal ?? 0} - ${layanan.usiaMaksimal ?? '-'} bulan',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey[300],
              ),
              // Availability info
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFF4CAF50),
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF757575),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Tersedia',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey[300],
              ),
              // Schedule info
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFFFF9800),
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Jadwal',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF757575),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Lihat Jadwal',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3A9EC1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection({
    required String title,
    required IconData icon,
    required String content,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Html(
                data: content,
                style: {
                  "body": Style(
                    fontSize: FontSize(14),
                    lineHeight: LineHeight(1.6),
                    color: const Color(0xFF555555),
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                  ),
                  "li": Style(
                    margin: Margins.only(
                        bottom: 8),
                  ),
                  "strong": Style(
                    color: const Color(0xFF333333),
                  ),
                  "a": Style(
                    color: const Color(0xFF3A9EC1),
                    textDecoration: TextDecoration.none,
                  ),
                },
              )),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Implement info action
              Get.snackbar(
                'Informasi',
                'Menampilkan informasi lebih lanjut',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.white,
                colorText: const Color(0xFF3A9EC1),
              );
            },
            icon: const Icon(Icons.info_outline),
            label: const Text('Informasi'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF3A9EC1),
              side: const BorderSide(color: Color(0xFF3A9EC1)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Implement registration action
              Get.snackbar(
                'Pendaftaran',
                'Anda akan diarahkan ke halaman pendaftaran',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xFF3A9EC1),
                colorText: Colors.white,
              );
            },
            icon: const Icon(Icons.calendar_today_outlined),
            label: const Text('Daftar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3A9EC1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 70,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Layanan tidak ditemukan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Maaf, informasi layanan yang Anda cari tidak tersedia',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Kembali'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3A9EC1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
