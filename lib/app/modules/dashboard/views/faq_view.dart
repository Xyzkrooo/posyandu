import 'package:flutter/material.dart';

class FAQView extends StatefulWidget {
  const FAQView({super.key});

  @override
  State<FAQView> createState() => _FAQViewState();
}

class _FAQViewState extends State<FAQView> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Map<String, String>> _faqList = [
    {
      "question": "Apa itu Posyandu?",
      "answer":
          "Posyandu (Pos Pelayanan Terpadu) adalah layanan kesehatan dasar yang dikelola masyarakat bersama petugas kesehatan untuk ibu dan anak."
    },
    {
      "question": "Siapa saja yang bisa datang ke Posyandu?",
      "answer":
          "Balita, ibu hamil, dan ibu menyusui bisa mendapatkan layanan di Posyandu."
    },
    {
      "question": "Layanan apa saja yang tersedia di Posyandu?",
      "answer":
          "Penimbangan, imunisasi, pemberian vitamin A, pemeriksaan kesehatan anak dan ibu, serta penyuluhan gizi."
    },
    {
      "question": "Kapan jadwal Posyandu diadakan?",
      "answer":
          "Jadwal Posyandu berbeda di setiap wilayah. Cek jadwal terbaru di halaman 'Jadwal' aplikasi."
    },
    {
      "question": "Apakah harus mendaftar sebelum datang ke Posyandu?",
      "answer":
          "Ya, sebaiknya mendaftar melalui aplikasi agar data anak tercatat dan proses pelayanan lebih cepat."
    },
    {
      "question": "Apa saja yang harus dibawa ke Posyandu?",
      "answer":
          "Buku KIA, kartu imunisasi anak, dan data identitas jika belum pernah mendaftar."
    },
    {
      "question": "Apakah layanan Posyandu berbayar?",
      "answer":
          "Tidak. Semua layanan Posyandu umumnya gratis dan didukung oleh pemerintah."
    },
    {
      "question": "Bagaimana cara mengetahui imunisasi yang belum lengkap?",
      "answer":
          "Cek riwayat imunisasi anak di aplikasi pada menu 'Riwayat Imunisasi'."
    },
    {
      "question": "Siapa yang melayani di Posyandu?",
      "answer":
          "Kader Posyandu, bidan, dan tenaga kesehatan dari Puskesmas terdekat."
    },
    {
      "question": "Bagaimana cara melaporkan masalah atau kendala layanan?",
      "answer":
          "Hubungi CS melalui halaman 'Layanan CS' di aplikasi atau email ke cs@posyandusakura.id."
    },
  ];

  final List<Map<String, String>> _visibleFaqs = [];

  @override
  void initState() {
    super.initState();
    _insertItemsSequentially();
  }

  void _insertItemsSequentially() async {
    for (int i = 0; i < _faqList.length; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      _visibleFaqs.add(_faqList[i]);
      _listKey.currentState?.insertItem(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7F6),
      body: SafeArea(
        child: AnimatedList(
          key: _listKey,
          padding: const EdgeInsets.all(16),
          initialItemCount: _visibleFaqs.length,
          itemBuilder: (context, index, animation) {
            final faq = _visibleFaqs[index];
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeOut)),
              ),
              child: FadeTransition(
                opacity: animation,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    shadowColor: Colors.grey.withOpacity(0.2),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        faq["question"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Text(
                            faq["answer"]!,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}