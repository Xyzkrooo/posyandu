import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class CSView extends StatelessWidget {
  const CSView({super.key});

  void _launchWhatsApp() async {
    const phone = '+6281234567890'; // Nomor CS
    final url = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak bisa membuka WhatsApp.';
    }
  }

  void _launchCall() async {
    const phone = '+6281234567890'; // Nomor telepon CS
    final url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Tidak bisa melakukan panggilan.';
    }
  }

  void _launchEmail() async {
    const email = 'cs@posyandusakura.id';
    final url = Uri.parse('mailto:$email?subject=Pertanyaan%20Layanan%20Posyandu');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Tidak bisa membuka email.';
    }
  }

  void _launchMaps() async {
    const address = 'Posyandu Sakura, Jl. Sehat No.10, Kec. Bahagia, Kota Posyandu';
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak bisa membuka peta.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: _launchWhatsApp,
        tooltip: "Hubungi via WhatsApp",
        child: const FaIcon(FontAwesomeIcons.whatsapp),
      ),
      // Hapus appBar di sini supaya tidak mentok dengan navbar utama
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar yang tidak mentok
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              decoration: const BoxDecoration(
                color: Color(0xFF0F66CD),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  const Expanded(
                    child: Text(
                      "Layanan Pelanggan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Untuk menyeimbangkan layout
                ],
              ),
            ),
            
            // Konten utama dengan scrolling
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lottie Animation
                    FadeInDown(
                      duration: const Duration(milliseconds: 800),
                      child: Center(
                        child: Lottie.asset(
                          'assets/lottie/cs_help.json',
                          height: 180,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Banner CS
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF0F66CD),
                              const Color(0xFF0F66CD).withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0F66CD).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: const [
                            Text(
                              "Tim Layanan Pelanggan Siap Membantu Anda",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Kami berkomitmen memberikan layanan terbaik untuk membantu setiap pertanyaan seputar Posyandu",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Jadwal Layanan
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 600),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F66CD).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF0F66CD).withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.access_time, color: Color(0xFF0F66CD)),
                                SizedBox(width: 8),
                                Text(
                                  "Jam Layanan",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF0F66CD),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Senin - Jumat",
                                          style: TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        Text("08.00 - 17.00 WIB"),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Sabtu",
                                          style: TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        Text("09.00 - 14.00 WIB"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.orange.shade100),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.info_outline, color: Colors.orange, size: 20),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Untuk pertanyaan mendesak di luar jam kerja, silakan kirim pesan dan kami akan merespons pada jam kerja berikutnya.",
                                      style: TextStyle(fontSize: 12, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Estimasi Waktu Respons
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 600),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F66CD).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF0F66CD).withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.timer, color: Color(0xFF0F66CD)),
                                SizedBox(width: 8),
                                Text(
                                  "Estimasi Waktu Respons",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF0F66CD),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _buildResponseTimeCard(
                                  icon: Icons.chat,
                                  title: "WhatsApp",
                                  time: "15-30 menit",
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 8),
                                _buildResponseTimeCard(
                                  icon: Icons.email,
                                  title: "Email",
                                  time: "1-2 jam",
                                  color: Color(0xFF0F66CD),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Kontak Card
                    const Text(
                      "Hubungi Kami",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      duration: const Duration(milliseconds: 600),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: _launchCall,
                              child: const ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Color(0xFF0F66CD),
                                  child: Icon(Icons.phone, color: Colors.white, size: 20),
                                ),
                                title: Text("Telepon"),
                                subtitle: Text("+62 812-3456-7890"),
                                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                              ),
                            ),
                            const Divider(height: 0),
                            InkWell(
                              onTap: _launchWhatsApp,
                              child: const ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.green,
                                  child: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 20),
                                ),
                                title: Text("WhatsApp"),
                                subtitle: Text("+62 812-3456-7890"),
                                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                              ),
                            ),
                            const Divider(height: 0),
                            InkWell(
                              onTap: _launchEmail,
                              child: const ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Color(0xFF0F66CD),
                                  child: Icon(Icons.email, color: Colors.white, size: 20),
                                ),
                                title: Text("Email"),
                                subtitle: Text("cs@posyandusakura.id"),
                                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                              ),
                            ),
                            const Divider(height: 0),
                            InkWell(
                              onTap: _launchMaps,
                              child: const ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  child: Icon(Icons.location_on, color: Colors.white, size: 20),
                                ),
                                title: Text("Alamat"),
                                subtitle: Text("Jl. Sehat No.10, Kec. Bahagia, Kota Posyandu"),
                                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // CS Team
                    FadeInUp(
                      delay: const Duration(milliseconds: 500),
                      duration: const Duration(milliseconds: 600),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F66CD).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF0F66CD).withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.people, color: Color(0xFF0F66CD)),
                                SizedBox(width: 8),
                                Text(
                                  "Tim Layanan Pelanggan",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF0F66CD),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Tim CS kami terdiri dari tenaga profesional kesehatan yang siap membantu Anda dengan segala pertanyaan seputar layanan Posyandu.",
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildCSTeamMember("Bidan Ani", "Koordinator CS"),
                                _buildCSTeamMember("Perawat Budi", "CS Layanan Imunisasi"),
                                _buildCSTeamMember("Ibu Cici", "CS Pendaftaran"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 80), // Untuk memberi ruang pada FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponseTimeCard({
    required IconData icon,
    required String title,
    required String time,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  Text(time, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCSTeamMember(String name, String role) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: const Color(0xFF0F66CD).withOpacity(0.2),
          child: Text(
            name.substring(0, 1),
            style: TextStyle(
              color: const Color(0xFF0F66CD),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        Text(
          role,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}