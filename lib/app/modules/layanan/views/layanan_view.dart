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
      appBar: AppBar(
        title: const Text('Layanan Posyandu'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.layananList.isEmpty) {
          return const Center(child: Text('Belum ada layanan tersedia.'));
        }

        return RefreshIndicator(
          onRefresh: controller.refreshLayanan,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.layananList.length,
            itemBuilder: (context, index) {
              final layanan = controller.layananList[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: layanan.gambarLyn ?? '',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                    ),
                  ),
                  title: Text(layanan.namaLyn ?? '-'),
                  subtitle: Text(
                    layanan.keteranganSingkat ?? '-',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    // navigasi ke detail layanan jika ada
                    Get.to(() => DetailLayananView(), arguments: layanan);
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
