import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:html/parser.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../data/dashboardResponse.dart';
import '../../../utils/api.dart';
import '../controllers/dashboard_controller.dart';

class IndexView extends GetView<DashboardController> {
  const IndexView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        if (controller.isLoadingDashboard.value) {
          return _buildShimmer();
        }

        final dashboard = controller.dashboardResponse.value;
        final artikelList = dashboard?.artikel ?? [];
        final notifList = dashboard?.notifikasi ?? [];
        final jadwal = dashboard?.countdownJadwal;
        final profile = controller.profileResponse.value;

        return RefreshIndicator(
          onRefresh: controller.getDashboard,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSelamatDatang(profile?.user?.nama ?? ''),
                const SizedBox(height: 20),
                if (artikelList.isNotEmpty) _buildCarouselArtikel(artikelList),
                const SizedBox(height: 20),
                if (jadwal != null)
                  _buildCountdownJadwal(jadwal), // Move countdown here
                const SizedBox(height: 20),
                _buildNavigasiMenu(),
                const SizedBox(height: 20),
                _buildNotifikasiImunisasi(notifList),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSelamatDatang(String nama) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            FaIcon(FontAwesomeIcons.handshake, size: 30, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Halo, $nama!\nSelamat datang di aplikasi Posyandu.",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownJadwal(CountdownJadwal jadwal) {
    final date =
        DateTime.parse('${jadwal.tanggalKegiatan} ${jadwal.waktuMulai}');
    final now = DateTime.now();
    final diff = date.difference(now);

    String countdownText;
    if (diff.inSeconds <= 0) {
      countdownText = "Sedang berlangsung";
    } else {
      countdownText =
          "${diff.inDays} hari ${diff.inHours % 24} jam ${diff.inMinutes % 60} menit lagi";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("⏳ Jadwal Terdekat",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: ListTile(
            leading: const Icon(FontAwesomeIcons.calendarDay,
                color: Colors.deepPurple),
            title: Text(jadwal.namaKegiatan ?? '-',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text("Mulai: ${jadwal.waktuMulai} WIB\n$countdownText"),
            trailing: Text(DateFormat('dd MMM yyyy').format(date)),
          ),
        )
      ],
    );
  }

  Widget _buildCarouselArtikel(List<Artikel> artikelList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("📰 Artikel Terbaru",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        CarouselSlider(
          options: CarouselOptions(
            height: 220,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.85,
          ),
          items: artikelList.map((item) {
            final ringkasan = _getRingkasan(item.kontenArtEdu ?? '');
            final imageUrl = "${BaseUrl.imageUrl}/${item.thumbnail}";
            return GestureDetector(
              onTap: () => Get.toNamed('/artikel-detail', arguments: item),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        imageUrl,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 100,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.broken_image, size: 50),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(item.judulArtEdu ?? '-',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(ringkasan,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNavigasiMenu() {
    final List<Map<String, dynamic>> menu = [
      {
        'title': 'Riwayat Pemeriksaan',
        'icon': FontAwesomeIcons.stethoscope,
        'route': '/pemeriksaan'
      },
      {
        'title': 'Imunisasi',
        'icon': FontAwesomeIcons.syringe,
        'route': '/imunisasi'
      },
      {
        'title': 'Jadwal',
        'icon': FontAwesomeIcons.calendarCheck,
        'route': '/jadwal'
      },
      {
        'title': 'Data Anak',
        'icon': FontAwesomeIcons.baby,
        'route': '/data-anak'
      },
    ];

    return GridView.builder(
      itemCount: menu.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final item = menu[index];
        return GestureDetector(
          onTap: () => Get.toNamed(item['route']),
          child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(item['icon'], size: 28),
                const SizedBox(height: 10),
                Text(item['title'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotifikasiImunisasi(List<Notifikasi> list) {
    if (list.isEmpty) {
      return const Text("Tidak ada notifikasi imunisasi.");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("🔔 Notifikasi Imunisasi",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ...list.map((item) => Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: const FaIcon(FontAwesomeIcons.bell),
                title: Text(item.namaAnak ?? '-'),
                subtitle: Text(
                    "Vaksin: ${item.namaVaksin} (${item.statusImunisasi})"),
                trailing: Text(item.tanggalKegiatan ?? ''),
              ),
            )),
      ],
    );
  }

  String _getRingkasan(String htmlContent) {
    final document = parse(htmlContent);
    final text = document.body?.text ?? '';
    return text.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 3,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(height: 100, width: double.infinity),
        ),
      ),
    );
  }
}
