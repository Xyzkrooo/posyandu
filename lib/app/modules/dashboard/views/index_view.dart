import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

class IndexView extends GetView {
  const IndexView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Selamat Datang
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Selamat Datang di Posyandu Sakura! 🌸",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Tempat terbaik untuk memantau kesehatan ibu dan anak.\n"
                    "Mari bersama menjaga tumbuh kembang buah hati kita! 💙",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),

            // Carousel dengan Lorem Picsum
            _buildCarousel(),

            const SizedBox(height: 15),

            // Grid Menu 4 Kotak (1 Row)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMenuItem(
                    icon: Icons.analytics ,
                    label: "Laporan Gizi",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.medical_services,
                    label: "Layanan",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.article,
                    label: "Artikel",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.vaccines,
                    label: "Imunisasi",
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Informasi tambahan
            _buildInfoSection(),
          ],
        ),
      ),
    );
  }

  // Widget untuk Carousel pakai Lorem Picsum
  Widget _buildCarousel() {
    List<Map<String, String>> carouselItems = [
      {
        "image": "https://picsum.photos/800/400?random=1",
        "text": "🌿 Sehat bersama Posyandu! Cegah stunting sejak dini dengan pola makan sehat.",
      },
      {
        "image": "https://picsum.photos/800/400?random=2",
        "text": "👶 Imunisasi lengkap, masa depan cerah! Pastikan anak mendapatkan vaksin tepat waktu.",
      },
      {
        "image": "https://picsum.photos/800/400?random=3",
        "text": "❤️ Kesehatan ibu, kesehatan keluarga. Yuk, periksa kesehatan ibu secara rutin!",
      },
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 180.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.9,
      ),
      items: carouselItems.map((item) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              Image.network(
                item["image"]!,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Text(
                  item["text"]!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Widget untuk Menu Kotak (1 Row, 4 Item)
  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.blueAccent),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk Informasi Tambahan
  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "💡 Info Kesehatan!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Jaga kesehatan anak dengan imunisasi rutin dan gizi seimbang. "
              "Pastikan datang ke Posyandu sesuai jadwal!",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}