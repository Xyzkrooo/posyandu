import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';


class CSView extends StatelessWidget {
  const CSView({super.key});

  void _launchWhatsApp() async {
    const phone = '+6281234567890'; // Ganti dengan nomor CS
    final url = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak bisa membuka WhatsApp.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7F6),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: _launchWhatsApp,
        tooltip: "Hubungi via WhatsApp",
        child: const FaIcon(FontAwesomeIcons.whatsapp), // pakai FaIcon!
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Jadwal Layanan
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal.shade100),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.access_time, color: Colors.teal),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Layanan tersedia setiap hari kerja:\nSenin - Jumat, 08.00 - 17.00 WIB",
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Lottie
                Center(
                  child: Lottie.asset(
                    'assets/lottie/cs_help.json',
                    height: 200,
                  ),
                ),
                const SizedBox(height: 16),

                // Judul & Deskripsi
                const Center(
                  child: Text(
                    "Ada pertanyaan seputar layanan Posyandu?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    "Silakan hubungi kami melalui kontak berikut.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Kontak Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Column(
                    children: const [
                      ListTile(
                        leading: Icon(Icons.phone, color: Colors.teal),
                        title: Text("Telepon"),
                        subtitle: Text("+62 812-3456-7890"),
                      ),
                      Divider(height: 0),
                      ListTile(
                        leading: Icon(Icons.email, color: Colors.teal),
                        title: Text("Email"),
                        subtitle: Text("cs@posyandusakura.id"),
                      ),
                      Divider(height: 0),
                      ListTile(
                        leading: Icon(Icons.location_on, color: Colors.teal),
                        title: Text("Alamat"),
                        subtitle:
                            Text("Jl. Sehat No.10, Kec. Bahagia, Kota Posyandu"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80), // untuk memberi ruang pada FAB
              ],
            ),
          ),
        ),
      ),
    );
  }
}
