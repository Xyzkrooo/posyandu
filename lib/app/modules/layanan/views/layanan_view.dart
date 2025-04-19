import 'package:Posyandu/app/modules/layanan/views/detail_layanan_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/layanan_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class LayananView extends GetView<LayananController> {
  const LayananView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize search functionality
    controller.initSearch();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 180.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: const Color(0xFF0F66CD),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: const Text(
                  'Layanan Posyandu',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background pattern
                    Opacity(
                      opacity: 0.1,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/pattern.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF0F66CD).withOpacity(0.8),
                            const Color(0xFF0F66CD),
                          ],
                        ),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.medical_services_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Temukan Layanan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Berbagai layanan kesehatan untuk Anda dan keluarga',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
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
          ];
        },
        body: Column(
          children: [
            Obx(() => controller.isLoading.value 
              ? _buildShimmerSearchBar() 
              : _buildSearchSection()
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _buildLayananListView(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0F66CD),
        child: const Icon(Icons.filter_list),
        onPressed: () {
          _showFilterBottomSheet(context);
        },
      ),
    );
  }

  Widget _buildShimmerSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Obx(() => TextField(
        controller: controller.searchController,
        onChanged: (value) {
          controller.searchLayanan(value);
        },
        decoration: InputDecoration(
          hintText: 'Cari layanan kesehatan...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(Icons.search, color: const Color(0xFF0F66CD).withOpacity(0.7)),
          suffixIcon: controller.searchText.value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    controller.clearSearch();
                  },
                )
              : const SizedBox.shrink(),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: const Color(0xFF0F66CD).withOpacity(0.3)),
          ),
        ),
      )),
    );
  }

  Widget _buildLayananListView() {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingState();
      }

      if (controller.filteredLayananList.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        onRefresh: controller.refreshLayanan,
        color: const Color(0xFF0F66CD),
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: controller.filteredLayananList.length,
          itemBuilder: (context, index) {
            final layanan = controller.filteredLayananList[index];
            return _buildLayananCard(layanan, context, index);
          },
        ),
      );
    });
  }

  Widget _buildLayananCard(dynamic layanan, BuildContext context, int index) {
    // Define animation delay based on index
    final animationDelay = Duration(milliseconds: 100 * index);
    
    // Define card gradients
    final List<List<Color>> cardGradients = [
      [const Color(0xFF2D7D9A), const Color(0xFF3A9EC1)],
      [const Color(0xFF5ABD8C), const Color(0xFF4A9C74)],
      [const Color(0xFFF6A564), const Color(0xFFE08F4E)],
      [const Color(0xFF7C65E6), const Color(0xFF6B56CC)],
      [const Color(0xFFFF7676), const Color(0xFFE06767)],
    ];
    
    final int gradientIndex = index % cardGradients.length;
    final List<Color> gradient = cardGradients[gradientIndex];
    
    final Map<String, IconData> categoryIcons = {
      'Balita': Icons.child_care,
      'Ibu Hamil': Icons.pregnant_woman,
      'Imunisasi': Icons.local_hospital,
      'Vitamin': Icons.medication,
      'Konsultasi': Icons.question_answer,
      'Lainnya': Icons.more_horiz,
    };
    
    final String category = layanan.jenisLyn ?? 'Lainnya';
    final IconData icon = categoryIcons[category] ?? Icons.local_hospital;
    
    // Age range text
    String ageRangeText = '';
    if (layanan.usiaMinimal != null && layanan.usiaMaksimal != null) {
      ageRangeText = '${layanan.usiaMinimal} - ${layanan.usiaMaksimal} bulan';
    } else if (layanan.usiaMinimal != null) {
      ageRangeText = '> ${layanan.usiaMinimal} bulan';
    } else if (layanan.usiaMaksimal != null) {
      ageRangeText = '< ${layanan.usiaMaksimal} bukan';
    }
    
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
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
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: gradient,
                          ),
                        ),
                        child: layanan.gambarLyn != null && layanan.gambarLyn!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: layanan.gambarLyn!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => _buildImagePlaceholder(),
                                errorWidget: (context, url, error) => _buildImageError(icon),
                              )
                            : _buildImageError(icon),
                      ),
                      // Overlay gradient
                      Container(
                        height: 150,
                        width: double.infinity,
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
                      // Category badge
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                icon,
                                size: 14,
                                color: gradient[0],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                category,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: gradient[0],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Title on image
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Text(
                          layanan.namaLyn ?? '-',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 3.0,
                                color: Color.fromARGB(150, 0, 0, 0),
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
                          layanan.keteranganSingkat ?? '-',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            // Age range badge if available
                            if (ageRangeText.isNotEmpty) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECF5FD),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 12,
                                      color: Color(0xFF0F66CD),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      ageRangeText,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0F66CD),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                            ] else
                              const Spacer(),
                            
                            // View details button
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: gradient,
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Lihat Detail',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
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
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        color: Colors.white,
      ),
    );
  }

  Widget _buildImageError(IconData icon) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          icon,
          size: 50,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        // Add staggered animation to shimmer items
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          period: Duration(milliseconds: 1500 + (index * 100)),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image area
                Container(
                  height: 150,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
                
                // Content area
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title placeholder
                      Container(
                        height: 20,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Description placeholder - 2 lines
                      Container(
                        height: 14,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 14,
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Action area
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Age badge placeholder
                          Container(
                            height: 28,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          
                          // Button placeholder
                          Container(
                            height: 32,
                            width: 110,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Layanan Tidak Ditemukan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Maaf, layanan yang Anda cari tidak ditemukan. Coba gunakan kata kunci lain.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => controller.clearSearch(),
            icon: const Icon(Icons.refresh),
            label: const Text('Reset Pencarian'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F66CD),
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

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter Layanan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              
              // Filter by category
              const Text(
                'Kategori Layanan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 12),
              // Use GetBuilder instead of directly accessing the reactive property
              GetBuilder<LayananController>(
                builder: (controller) => Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: [
                    'Semua',
                    'Balita',
                    'Ibu Hamil', 
                    'Imunisasi',
                    'Vitamin',
                    'Konsultasi',
                    'Lainnya'
                  ].map((category) {
                    return FilterChip(
                      selected: controller.selectedCategory.value == category,
                      label: Text(category),
                      onSelected: (selected) {
                        if (selected) {
                          controller.filterByCategory(category);
                        }
                        Navigator.pop(context);
                      },
                      backgroundColor: const Color(0xFFECF5FD),
                      selectedColor: const Color(0xFF0F66CD).withOpacity(0.2),
                      checkmarkColor: const Color(0xFF0F66CD),
                      labelStyle: TextStyle(
                        color: controller.selectedCategory.value == category
                            ? const Color(0xFF0F66CD)
                            : Colors.grey[700],
                        fontWeight: controller.selectedCategory.value == category
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Filter by age range (placeholder)
              const Text(
                'Rentang Usia',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 12),
              RangeSlider(
                values: const RangeValues(0, 18),
                max: 18,
                divisions: 18,
                labels: const RangeLabels('0 bulan', '120 bulan'),
                activeColor: const Color(0xFF0F66CD),
                inactiveColor: const Color(0xFFECF5FD),
                onChanged: (RangeValues values) {
                  // Implement age range filtering
                },
              ),
              
              const Spacer(),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        controller.resetFilters();
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0F66CD),
                        side: const BorderSide(color: Color(0xFF0F66CD)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Reset Filter'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Apply advanced filters - additional functionality could be added here
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F66CD),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Terapkan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}