import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';

import '../controllers/dashboard_controller.dart';


class FAQView extends GetView<DashboardController> {
  const FAQView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF), // Keeping the soft background
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar like in CSView
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              decoration: const BoxDecoration(
                color: Color(0xFF0F66CD), // Match Index primary blue
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  // Search button on the left
                  IconButton(
                    icon: Obx(() => Icon(
                      controller.isSearching.value ? Icons.close : Icons.search,
                      color: Colors.white,
                    )),
                    onPressed: () => controller.toggleSearch(),
                  ),
                  
                  // Title with conditional search field
                  Expanded(
                    child: Obx(() => controller.isSearching.value
                      ? _buildSearchField()
                      : const Text(
                          "Pertanyaan Umum (FAQ)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        )
                    ),
                  ),
                  
                  // Expand/collapse button on the right
                  IconButton(
                    icon: Obx(() => Icon(
                      controller.expandAll.value ? Icons.unfold_less : Icons.unfold_more,
                      color: Colors.white,
                    )),
                    onPressed: () => controller.toggleExpandAll(),
                    tooltip: controller.expandAll.value ? "Tutup Semua" : "Buka Semua",
                  ),
                ],
              ),
            ),
            
            // Header with illustration (only when not searching)
            // Obx(() => !controller.isSearching.value ? _buildHeader() : Container()),
            
            // Category chips
            _buildCategoryChips(),
            
            // FAQ list
            Expanded(
              child: Obx(() => controller.filteredFaqs.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.filteredFaqs.length,
                      itemBuilder: (context, index) {
                        final faq = controller.filteredFaqs[index];
                        return _buildFaqItem(faq, index);
                      },
                    )),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSearchField() {
    return TextField(
      controller: controller.searchController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: "Cari pertanyaan...",
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 10),
      ),
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
    );
  }
  
  
  Widget _buildCategoryChips() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(() => Row(
          children: controller.categories.map((category) {
            final isSelected = controller.selectedCategory.value == category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: isSelected,
                label: Text(category),
                onSelected: (_) => controller.setCategory(category),
                backgroundColor: const Color(0xFFE3F2FD), // Aligned with Index blue theme
                selectedColor: const Color(0xFFBBDEFB), // Lighter variant for selected state
                checkmarkColor: const Color(0xFF0F66CD), // Main blue from Index
                labelStyle: TextStyle(
                  color: isSelected ? const Color(0xFF0F66CD) : const Color(0xFF5C5C5C),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
            );
          }).toList(),
        )),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 140,
            width: 140,
            child: Lottie.asset(
              'assets/lottie/search_empty.json',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Pertanyaan tidak ditemukan",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F66CD), // Changed to match Index primary blue
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Coba kata kunci lain atau kategori berbeda",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFaqItem(Map<String, String> faq, int index) {
    // Updated with colors matching the Index view
    Map<String, Color> categoryColors = {
      "Umum": const Color(0xFF0F66CD), // Main blue from Index
      "Pembayaran": const Color(0xFF4CAF50), // Green from Index
      "Akun": const Color(0xFF2196F3), // Blue from Index
      "Pengiriman": const Color(0xFFF44336), // Red from Index
      "Produk": const Color(0xFFFF9800), // Orange from Index
      "Lainnya": const Color(0xFF9C27B0), // Purple from Index
    };
    
    final Color categoryColor = categoryColors[faq["category"]] ?? const Color(0xFF0F66CD);
    
    return Obx(() => Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: controller.expandedStates[index]
                ? categoryColor.withOpacity(0.2)
                : Colors.transparent,
            width: 1.0,
          ),
        ),
        elevation: controller.expandedStates[index] ? 2 : 1,
        shadowColor: Colors.grey.withOpacity(0.2),
        color: Colors.white,
        child: Column(
          children: [
            InkWell(
              onTap: () => controller.toggleExpand(index),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        controller.getCategoryIcon(faq["category"] ?? "Umum"),
                        color: categoryColor,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            faq["question"]!,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: const Color(0xFF424242),
                            ),
                          ),
                          if (faq["category"] != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: categoryColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  faq["category"]!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: categoryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: controller.expandedStates[index]
                            ? categoryColor.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        controller.expandedStates[index]
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: controller.expandedStates[index] ? categoryColor : Colors.grey[500],
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (controller.expandedStates[index])
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FBFF),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      faq["answer"]!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF616161),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildHelpfulButton(),
                        const SizedBox(width: 12),
                        _buildReportButton(),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ));
  }
  
  Widget _buildHelpfulButton() {
    return OutlinedButton.icon(
      onPressed: () {
        Get.snackbar(
          'Terima Kasih',
          'Terima kasih atas masukan Anda!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
      },
      icon: const Icon(Icons.thumb_up_alt_outlined, size: 16),
      label: const Text('Membantu'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF4CAF50),
        side: const BorderSide(color: Color(0xFFB8E6B9)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
  
  Widget _buildReportButton() {
    return OutlinedButton.icon(
      onPressed: () {
        // Show report dialog
        Get.dialog(
          AlertDialog(
            title: const Text('Laporkan Masalah', 
              style: TextStyle(color: Color(0xFF0F66CD)), // Changed to match Index primary blue
            ),
            content: const Text(
                'Apakah informasi pada jawaban ini tidak akurat atau sulit dipahami?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Batal', 
                  style: TextStyle(color: Color(0xFF9E9E9E)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    'Laporan Diterima',
                    'Laporan Anda telah diterima. Terima kasih!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFF0F66CD), // Changed to match Index primary blue
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 8,
                  );
                },
                child: const Text('Laporkan', 
                  style: TextStyle(color: Color(0xFF0F66CD)), // Changed to match Index primary blue
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.white,
          ),
        );
      },
      icon: const Icon(Icons.flag_outlined, size: 16),
      label: const Text('Laporkan'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF9E9E9E),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}