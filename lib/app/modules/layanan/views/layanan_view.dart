import 'package:Posyandu/app/modules/layanan/views/detail_layanan_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/layanan_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LayananView extends GetView<LayananController> {
  const LayananView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        title: const Text(
          'Layanan Posyandu',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF3A9EC1),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildHeaderSection(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF3A9EC1),
                  ),
                );
              }

              if (controller.layananList.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: controller.refreshLayanan,
                color: const Color(0xFF3A9EC1),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.layananList.length,
                  itemBuilder: (context, index) {
                    final layanan = controller.layananList[index];
                    return _buildLayananCard(layanan, context);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Layanan Posyandu',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Temukan informasi lengkap tentang layanan-layanan yang tersedia di Posyandu terdekat Anda',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari layanan...',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            onChanged: (value) {
              // Implement search functionality
            },
          ),
          const SizedBox(height: 16),
          _buildCategoryChips(),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    // Sample categories - you would integrate these with your controller
    final categories = ['Semua', 'Balita', 'Ibu Hamil', 'Imunisasi', 'Lainnya'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final isSelected = category == 'Semua'; // Example condition
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              selected: isSelected,
              label: Text(category),
              selectedColor: const Color(0xFF3A9EC1).withOpacity(0.2),
              backgroundColor: const Color(0xFFECF5FD),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF3A9EC1) : const Color(0xFF666666),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onSelected: (selected) {
                // Implement category filtering
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLayananCard(dynamic layanan, BuildContext context) {
    final List<Color> cardColors = [
      const Color(0xFFE3F2FD), // Light Blue
      const Color(0xFFE8F5E9), // Light Green
      const Color(0xFFFFF3E0), // Light Orange
      const Color(0xFFE1F5FE), // Light Blue 2
      const Color(0xFFF3E5F5), // Light Purple
    ];
    
    final int colorIndex = layanan.id % cardColors.length;
    final Color cardColor = cardColors[colorIndex];
    
    final Map<String, IconData> categoryIcons = {
      'Balita': Icons.child_care,
      'Ibu Hamil': Icons.pregnant_woman,
      'Imunisasi': Icons.local_hospital,
      'Vitamin': Icons.medical_services,
      'Konsultasi': Icons.question_answer,
      'Lainnya': Icons.more_horiz,
    };
    
    final String category = layanan.kategori ?? 'Lainnya';
    final IconData icon = categoryIcons[category] ?? Icons.local_hospital;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Get.to(
                () => DetailLayananView(slug: layanan.slug!),
                transition: Transition.fadeIn,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with image
                Stack(
                  children: [
                    SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: layanan.gambarLyn ?? '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: cardColor,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: cardColor.computeLuminance() > 0.5 
                                  ? const Color(0xFF3A9EC1) 
                                  : Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: cardColor,
                          child: Icon(
                            icon,
                            size: 40,
                            color: cardColor.computeLuminance() > 0.5 
                                ? const Color(0xFF3A9EC1) 
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // Category badge
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icon,
                              size: 14,
                              color: const Color(0xFF3A9EC1),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              category,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF3A9EC1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        layanan.namaLyn ?? '-',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        layanan.keteranganSingkat ?? '-',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // Available badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Tersedia',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF4CAF50),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'Lihat Detail',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF3A9EC1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Color(0xFF3A9EC1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada layanan tersedia',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Silakan coba lagi nanti atau hubungi petugas Posyandu',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => controller.refreshLayanan(),
            icon: const Icon(Icons.refresh),
            label: const Text('Muat Ulang'),
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