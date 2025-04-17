import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../artikel/controllers/artikel_controller.dart';

class ArtikelDetailView extends StatelessWidget {
  final String slug;
  ArtikelDetailView({super.key, required this.slug});

  final controller = Get.put(ArtikelController());

  @override
  Widget build(BuildContext context) {
    if (controller.artikelDetail.value == null) {
      controller.getArtikelBySlug(slug).then((_) {
        final artikel = controller.artikelDetail.value;
        if (artikel != null) {
          controller.getRelatedArtikel(
            artikel.kategori ?? "",
            artikel.id ?? 0,
          );
        }
      });
    }

    return Scaffold(
      body: Obx(() {
        if (controller.isLoadingDetail.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Color(0xFF1E88E5),
                ),
                SizedBox(height: 16),
                Text(
                  "Memuat artikel...",
                  style: TextStyle(
                    color: Color(0xFF1E88E5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        final artikel = controller.artikelDetail.value;
        if (artikel == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'Artikel tidak ditemukan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Kembali"),
                ),
              ],
            ),
          );
        }

        String formattedDate = "";
        if (artikel.createdAt != null) {
          try {
            final date = DateTime.parse(artikel.createdAt!);
            formattedDate = DateFormat('dd MMMM yyyy').format(date);
          } catch (_) {}
        }

        return CustomScrollView(
          slivers: [
            // Featured Image with Parallax Effect
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                ],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    artikel.thumbnail != null
                        ? CachedNetworkImage(
                            imageUrl: artikel.thumbnail!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image, size: 64),
                            ),
                          )
                        : Container(color: Colors.grey.shade200),
                    // Gradient overlay for better text visibility
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 120,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                title: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    artikel.kategori ?? "",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              ),
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Get.back(),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.share, color: Colors.black87),
                    onPressed: () {
                      Share.share(
                        'Baca artikel: ${artikel.judul ?? "Artikel"} - ${artikel.ringkasan ?? ""}',
                      );
                    },
                  ),
                ),
              ],
            ),

            // Article Content
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(top: 0),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      artikel.judul ?? "-",
                      style: GoogleFonts.merriweather(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Author and Date Row
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFF1E88E5),
                          child: Text(
                            artikel.penulis?.substring(0, 1).toUpperCase() ??
                                "?",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                artikel.penulis ?? "Tidak diketahui",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              if (formattedDate.isNotEmpty)
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            artikel.kategori ?? "Umum",
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Quote or Summary
                    if (artikel.ringkasan != null &&
                        artikel.ringkasan!.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Colors.blue.shade300,
                              width: 4,
                            ),
                          ),
                          color: Colors.blue.shade50,
                        ),
                        child: Text(
                          artikel.ringkasan!,
                          style: GoogleFonts.merriweather(
                            fontStyle: FontStyle.italic,
                            color: Colors.black87,
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                      ),

                    // Main Content
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: artikel.konten != null
                          ? Html(
                              data: artikel.konten!,
                              style: {
                                "body": Style(
                                  fontSize: FontSize(16),
                                  lineHeight: LineHeight(1.8),
                                  fontFamily: 'Merriweather',
                                ),
                                "h1,h2,h3,h4,h5,h6": Style(
                                  fontFamily: 'Merriweather',
                                  fontWeight: FontWeight.bold,
                                  margin: Margins.only(top: 16, bottom: 8),
                                ),
                                "p": Style(
                                  margin: Margins.only(bottom: 16),
                                ),
                                "img": Style(
                                  margin: Margins.symmetric(vertical: 16),
                                ),
                                "blockquote": Style(
                                  border: const Border(
                                    left: BorderSide(
                                        width: 4, color: Colors.grey),
                                  ),
                                  padding: HtmlPaddings.only(left: 16),
                                  fontStyle: FontStyle.italic,
                                ),
                              },
                            )
                          : Text(
                              "Konten tidak tersedia",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                    ),

                    // Tags Section
                    if (artikel.kategori != null &&
                        artikel.kategori!.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tags",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: (artikel.kategori ?? "")
                                  .split(",")
                                  .map((tag) => Chip(
                                        label: Text(tag.trim()),
                                        backgroundColor: Colors.grey.shade100,
                                        labelStyle: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 12,
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),

                    const Divider(height: 40, thickness: 1),

                    // Related Articles Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.library_books,
                                color: Color(0xFF1E88E5)),
                            const SizedBox(width: 8),
                            Text(
                              "Artikel Terkait",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E88E5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          if (controller.isLoadingRelated.value) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (controller.relatedArtikelList.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.info_outline, color: Colors.grey),
                                  SizedBox(width: 8),
                                  Text(
                                    "Tidak ada artikel terkait saat ini",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: controller.relatedArtikelList.length,
                            itemBuilder: (context, index) {
                              final related =
                                  controller.relatedArtikelList[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() =>
                                      ArtikelDetailView(slug: related.slug!));
                                },
                                child: Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Thumbnail
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(12),
                                        ),
                                        child: related.thumbnail != null
                                            ? CachedNetworkImage(
                                                imageUrl: related.thumbnail!,
                                                height: 120,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Container(
                                                  color: Colors.grey.shade200,
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: 120,
                                                color: Colors.grey.shade200,
                                                child: const Icon(
                                                  Icons.image,
                                                  size: 40,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                      ),
                                      // Content
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (related.kategori != null)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  related.kategori!,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.blue.shade700,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            const SizedBox(height: 8),
                                            Text(
                                              related.judul ?? "Tanpa Judul",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                height: 1.3,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              controller.getRingkasan(
                                                  related.konten ?? ""),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade700,
                                                height: 1.4,
                                              ),
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
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
