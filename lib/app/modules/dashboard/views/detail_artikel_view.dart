import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:html/parser.dart'; // Untuk parsing HTML

import '../../../data/artikelResponse.dart';
import '../../../data/dashboardResponse.dart';

class ArtikelDetailView extends StatelessWidget {
  final Data artikel; // Menerima objek Data

  const ArtikelDetailView({super.key, required this.artikel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Artikel"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Artikel
              Text(
                artikel.judulArtEdu ?? "-",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Penulis Artikel
              Text(
                "Penulis: ${artikel.namaPenulis ?? 'Tidak diketahui'}",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),

              // Thumbnail
              if (artikel.thumbnail != null)
                CachedNetworkImage(
                  imageUrl: artikel.thumbnail!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              const SizedBox(height: 10),

              // Konten Lengkap (dengan HTML parsing)
              Text(
                "Konten Artikel:",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                parse(artikel.kontenArtEdu ?? "").body?.text ?? "Konten tidak tersedia.",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Kategori Artikel
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
      ),
    );
  }
}
