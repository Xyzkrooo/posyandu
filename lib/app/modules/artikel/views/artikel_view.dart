import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import '../controllers/artikel_controller.dart';
import 'detail_artikel_view.dart';

class ArtikelView extends GetView<ArtikelController> {
  const ArtikelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("Artikel Edukasi", 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F66CD),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF0F66CD)),
            onPressed: () {
              // Implementasi pencarian artikel
              Get.snackbar(
                'Info', 
                'Fitur pencarian akan datang segera',
                backgroundColor: const Color(0xFF0F66CD),
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingArtikel.value) {
          return _buildShimmerLoading();
        }

        if (controller.artikelList.isEmpty) {
          return _buildEmptyState();
        }

        return AnimationLimiter(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 12, bottom: 20),
            itemCount: controller.artikelList.length,
            itemBuilder: (context, index) {
              final artikel = controller.artikelList[index];
              
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Hero(
                      tag: 'artikel_${artikel.id}',
                      child: GestureDetector(
                        onTap: () {
                            Get.to(() => ArtikelDetailView(slug: artikel.slug!),
                            transition: Transition.fadeIn,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Thumbnail with rounded corners
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: Stack(
                                  children: [
                                    // Image
                                    CachedNetworkImage(
                                      imageUrl: artikel.thumbnail ?? '',
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: double.infinity,
                                          height: 200,
                                          color: Colors.white,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        width: double.infinity,
                                        height: 200,
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: Icon(Icons.image_not_supported, 
                                            size: 50, 
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    
                                    // Category badge
                                    Positioned(
                                      top: 16,
                                      left: 16,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12, 
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0F66CD),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          artikel.kategori ?? 'Umum',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Content
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      artikel.judul ?? "-",
                                      style: const TextStyle(
                                        fontSize: 18, 
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF333333),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 12),
                                    
                                    // Penulis dan tanggal
                                    Row(
                                      children: [
                                        const Icon(
                                          FontAwesomeIcons.user,
                                          size: 14,
                                          color: Color(0xFF0F66CD),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          artikel.penulis ?? 'Admin',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        const Icon(
                                          FontAwesomeIcons.calendar,
                                          size: 14,
                                          color: Color(0xFF0F66CD),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          artikel.createdAt ?? 'Tidak diketahui',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    
                                    // Ringkasan konten
                                    Text(
                                      controller.getRingkasan(artikel.konten ?? ""),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[800],
                                        height: 1.5,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    
                                    const SizedBox(height: 16),
                                    
                                    // Read more button
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Read more button with animation
                                        TweenAnimationBuilder<double>(
                                          tween: Tween<double>(begin: 0, end: 1),
                                          duration: const Duration(milliseconds: 300),
                                          builder: (context, value, child) {
                                            return Transform.scale(
                                              scale: 0.9 + (0.1 * value),
                                              child: child,
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF0F66CD).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "Baca Selengkapnya",
                                                  style: TextStyle(
                                                    color: Color(0xFF0F66CD),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  size: 16,
                                                  color: Color(0xFF0F66CD),
                                                ),
                                              ],
                                            ),
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
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF0F66CD),
              onPressed: () {
                controller.refreshArtikel();
              },
              child: const Icon(Icons.refresh),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
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
          const Icon(
            FontAwesomeIcons.newspaper,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            "Belum ada artikel saat ini",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Periksa kembali nanti untuk informasi terbaru",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              controller.refreshArtikel();
            },
            icon: const Icon(Icons.refresh),
            label: const Text("Muat Ulang"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F66CD),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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