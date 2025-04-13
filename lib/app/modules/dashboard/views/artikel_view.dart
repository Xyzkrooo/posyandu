import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:html/parser.dart';

import '../controllers/dashboard_controller.dart';
import 'detail_artikel_view.dart';

class ArtikelView extends GetView<DashboardController> {
  const ArtikelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Artikel Edukasi"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingArtikel.value) {
          // SHIMMER LOADING
          return ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(12.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          );
        }

        if (controller.artikelList.isEmpty) {
          return const Center(child: Text("Tidak ada artikel ditemukan."));
        }

        return ListView.builder(
          itemCount: controller.artikelList.length,
          itemBuilder: (context, index) {
            final artikel = controller.artikelList[index];

            return GestureDetector(
              onTap: () {
                // Navigasi ke halaman detail artikel
                Get.to(() => ArtikelDetailView(artikel: artikel));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail
                      if (artikel.thumbnail != null)
                        CachedNetworkImage(
                          imageUrl: artikel.thumbnail!,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: double.infinity,
                              height: 180,
                              color: Colors.white,
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),

                      // Content
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              artikel.judulArtEdu ?? "-",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Penulis: ${artikel.namaPenulis ?? 'Tidak diketahui'}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 10),

                            // Ringkasan konten HTML
                            Text(
                              controller.getRingkasan(artikel.kontenArtEdu ?? ""),
                              style: const TextStyle(fontSize: 14),
                            ),

                            const SizedBox(height: 10),
                            Text(
                              "Kategori: ${artikel.kategoriArtEdu ?? '-'}",
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
