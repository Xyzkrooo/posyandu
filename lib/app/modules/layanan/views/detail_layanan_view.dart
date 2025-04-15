import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../data/layananResponse.dart';

class DetailLayananView extends StatelessWidget {
  final Data layanan = Get.arguments as Data;

  @override

  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(layanan.namaLyn ?? 'Detail Layanan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Layanan
            if (layanan.gambarLyn != null && layanan.gambarLyn!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: layanan.gambarLyn!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              ),
            const SizedBox(height: 16),

            // Nama Layanan
            Text(
              layanan.namaLyn ?? '-',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 8),

            // Keterangan Singkat
            if (layanan.keteranganSingkat != null &&
                layanan.keteranganSingkat!.isNotEmpty)
              Text(
                layanan.keteranganSingkat!,
                style: textTheme.titleMedium,
              ),
            const SizedBox(height: 16),

            // Jenis Layanan
            if (layanan.jenisLyn != null && layanan.jenisLyn!.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.category, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    layanan.jenisLyn!,
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // Usia Minimal dan Maksimal
            if (layanan.usiaMinimal != null || layanan.usiaMaksimal != null)
              Row(
                children: [
                  const Icon(Icons.cake, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Usia: ${layanan.usiaMinimal ?? '-'} - ${layanan.usiaMaksimal ?? '-'} bulan',
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // Keterangan Layanan (HTML)
            if (layanan.keteranganLyn != null &&
                layanan.keteranganLyn!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Keterangan:', style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Html(data: layanan.keteranganLyn!),
                ],
              ),
            const SizedBox(height: 16),

            // Manfaat Layanan (HTML)
            if (layanan.manfaatLyn != null && layanan.manfaatLyn!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Manfaat:', style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Html(data: layanan.manfaatLyn!),
                ],
              ),
            const SizedBox(height: 16),

            // Larangan Layanan (HTML)
            if (layanan.laranganLyn != null && layanan.laranganLyn!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Larangan:', style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Html(data: layanan.laranganLyn!),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
