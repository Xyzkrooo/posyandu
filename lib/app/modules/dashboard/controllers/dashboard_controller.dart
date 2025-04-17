import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as HtmlParser;

import '../../../data/dashboardResponse.dart';
import '../../../data/profileResponse.dart';
import '../../../utils/api.dart';
import '../views/cs_view.dart';
import '../views/faq_view.dart';
import '../views/index_view.dart';

class DashboardController extends GetxController {
  var profileResponse = Rxn<ProfileResponse>();
  var dashboardResponse = Rxn<DashboardResponse>();

  var isLoadingProfile = true.obs;
  var isLoadingArtikel = true.obs;
  var isLoadingDashboard = true.obs;

  var selectedIndex = 0.obs;
  final storage = GetStorage();
  late final RxnString token;

  final List<Widget> pages = [
    IndexView(),
    FAQView(),
    CSView(),
  ];

  @override
  void onInit() {
    token = RxnString(storage.read('token'));
    searchController.addListener(_onSearchChanged);
    filteredFaqs.addAll(faqList);
    expandedStates.value = List.generate(filteredFaqs.length, (_) => false);
    if (token.value != null && token.value!.isNotEmpty) {
      getProfile();
      getDashboard();
    } else {
      Get.offAllNamed('/login');
    }

    super.onInit();
  }

  Future<void> getProfile() async {
    isLoadingProfile.value = true;
    try {
      final response = await http.get(
        Uri.parse(BaseUrl.profile),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final newProfile = ProfileResponse.fromJson(jsonData);
        profileResponse.value = newProfile;
      } else {
        Get.snackbar(
          'Error',
          'Gagal mengambil profil (${response.statusCode})',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingProfile.value = false;
    }
  }

  Future<void> getDashboard() async {
    isLoadingDashboard.value = true;
    try {
      final response = await http.get(
        Uri.parse(BaseUrl.dashboard),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        dashboardResponse.value = DashboardResponse.fromJson(jsonData);
      } else {
        Get.snackbar(
          'Error',
          'Gagal memuat dashboard (${response.statusCode})',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingDashboard.value = false;
    }
  }

  void logOut() async {
    final currentToken = storage.read('token');

    try {
      final response = await http.post(
        Uri.parse(BaseUrl.logout),
        headers: {
          'Authorization': 'Bearer $currentToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Logout berhasil',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await storage.erase();
        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          'Failed',
          'Logout gagal (${response.statusCode})',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final isSearching = false.obs;

  // FAQ categories
  final categories = ["Semua", "Umum", "Layanan", "Jadwal", "Pendaftaran"];

  final selectedCategory = "Semua".obs;

  // FAQ items with added category field
  final faqList = [
    {
      "question": "Apa itu Posyandu?",
      "answer":
          "Posyandu (Pos Pelayanan Terpadu) adalah layanan kesehatan dasar yang dikelola masyarakat bersama petugas kesehatan untuk ibu dan anak. Posyandu merupakan program pemerintah yang bertujuan untuk meningkatkan kesehatan ibu dan anak dengan melibatkan peran aktif masyarakat.",
      "category": "Umum"
    },
    {
      "question": "Siapa saja yang bisa datang ke Posyandu?",
      "answer":
          "Posyandu melayani beberapa kelompok sasaran yaitu:\n\n• Bayi dan balita (0-5 tahun)\n• Ibu hamil\n• Ibu menyusui\n• Wanita usia subur (WUS)\n• Pasangan usia subur (PUS)\n\nLayanan diberikan secara terjadwal dengan prioritas pada pemantauan tumbuh kembang anak dan kesehatan ibu.",
      "category": "Umum"
    },
    {
      "question": "Layanan apa saja yang tersedia di Posyandu?",
      "answer":
          "Posyandu menyediakan berbagai layanan kesehatan dasar yang mencakup:\n\n• Penimbangan berat badan anak\n• Pengukuran tinggi badan dan lingkar kepala\n• Imunisasi lengkap untuk bayi dan anak\n• Pemberian vitamin A\n• Pemberian makanan tambahan\n• Pemantauan tumbuh kembang anak\n• Pemeriksaan kesehatan ibu hamil\n• Penyuluhan gizi dan kesehatan\n• Pencegahan dan penanggulangan diare",
      "category": "Layanan"
    },
    {
      "question": "Kapan jadwal Posyandu diadakan?",
      "answer":
          "Jadwal Posyandu berbeda di setiap wilayah. Umumnya Posyandu diadakan setiap bulan pada tanggal yang sudah ditentukan. Cek jadwal terbaru di halaman 'Jadwal' aplikasi untuk mengetahui jadwal di wilayah Anda. Anda juga bisa mengaktifkan notifikasi untuk mendapatkan pengingat sehari sebelum jadwal Posyandu di wilayah Anda.",
      "category": "Jadwal"
    },
    {
      "question": "Apakah harus mendaftar sebelum datang ke Posyandu?",
      "answer":
          "Ya, sebaiknya mendaftar melalui aplikasi agar data anak tercatat dan proses pelayanan lebih cepat. Pendaftaran online membantu petugas Posyandu dalam mempersiapkan layanan dan mempercepat proses administrasi saat Anda datang. Pendaftaran dapat dilakukan melalui menu 'Daftar Kunjungan' di aplikasi paling lambat 1 hari sebelum jadwal Posyandu.",
      "category": "Pendaftaran"
    },
    {
      "question": "Apa saja yang harus dibawa ke Posyandu?",
      "answer":
          "Dokumen dan perlengkapan yang perlu dibawa saat kunjungan ke Posyandu:\n\n• Buku KIA (Kesehatan Ibu dan Anak)\n• Kartu imunisasi anak\n• KTP atau kartu identitas orangtua\n• Kartu Keluarga (untuk kunjungan pertama)\n• Bukti pendaftaran dari aplikasi (jika sudah mendaftar online)\n• Perlengkapan pribadi bayi/anak (popok, makanan, dll.)",
      "category": "Layanan"
    },
    {
      "question": "Apakah layanan Posyandu berbayar?",
      "answer":
          "Tidak. Semua layanan Posyandu umumnya gratis dan didukung oleh pemerintah. Posyandu merupakan program pemerintah yang dibiayai melalui dana desa, Puskesmas, atau sumber dana lainnya. Masyarakat dapat mengakses layanan Posyandu tanpa dipungut biaya apapun. Jika ada pungutan, silakan laporkan melalui layanan pengaduan di aplikasi.",
      "category": "Layanan"
    },
    {
      "question": "Bagaimana cara mengetahui imunisasi yang belum lengkap?",
      "answer":
          "Cek riwayat imunisasi anak di aplikasi pada menu 'Riwayat Imunisasi'. Di sana Anda dapat melihat imunisasi yang sudah diberikan dan jadwal imunisasi yang akan datang. Aplikasi akan menampilkan status imunisasi dengan kode warna: hijau (sudah dilakukan), kuning (jadwal mendekati), dan merah (terlambat atau belum dilakukan).",
      "category": "Layanan"
    },
    {
      "question": "Siapa yang melayani di Posyandu?",
      "answer":
          "Petugas yang memberikan layanan di Posyandu terdiri dari:\n\n• Kader Posyandu: relawan dari masyarakat yang telah dilatih\n• Bidan desa: tenaga kesehatan profesional\n• Petugas Puskesmas: dokter, perawat, ahli gizi yang berkunjung secara berkala\n\nKader Posyandu bertugas untuk pencatatan dan pengukuran dasar, sementara pemeriksaan kesehatan dan imunisasi dilakukan oleh tenaga kesehatan profesional.",
      "category": "Umum"
    },
    {
      "question": "Bagaimana cara melaporkan masalah atau kendala layanan?",
      "answer":
          "Untuk melaporkan masalah atau kendala layanan, Anda dapat:\n\n• Hubungi CS melalui halaman 'Layanan CS' di aplikasi\n• Kirim email ke cs@posyandusakura.id\n• Hubungi via WhatsApp di nomor yang tersedia di aplikasi\n• Sampaikan langsung kepada Kader atau petugas Posyandu\n\nSetiap laporan akan ditindaklanjuti dalam waktu 1-3 hari kerja.",
      "category": "Layanan"
    },
    {
      "question":
          "Apa yang harus dilakukan jika anak tidak bisa hadir pada jadwal imunisasi?",
      "answer":
          "Jika anak tidak bisa hadir pada jadwal imunisasi di Posyandu, Anda dapat:\n\n• Mengunjungi Posyandu lain yang jadwalnya berbeda\n• Datang ke Puskesmas untuk mendapatkan imunisasi\n• Mengunjungi fasilitas kesehatan seperti klinik atau rumah sakit\n\nPastikan untuk memberitahu petugas Posyandu melalui aplikasi agar status imunisasi anak tetap tercatat dengan baik.",
      "category": "Jadwal"
    },
    {
      "question": "Bagaimana cara membaca KMS (Kartu Menuju Sehat)?",
      "answer":
          "KMS atau Kartu Menuju Sehat berisi grafik pertumbuhan anak dengan kode warna:\n\n• Hijau: pertumbuhan normal\n• Kuning: perlu perhatian, berat badan tidak naik\n• Merah: garis merah bawah, menunjukkan anak kurang gizi\n\nGrafik ini menggambarkan pertumbuhan anak berdasarkan berat badan menurut umur. Petugas Posyandu akan membantu menjelaskan cara membaca KMS dan memberikan saran jika diperlukan.",
      "category": "Umum"
    },
    {
      "question": "Apa manfaat rutin datang ke Posyandu?",
      "answer":
          "Manfaat rutin mengunjungi Posyandu antara lain:\n\n• Pemantauan pertumbuhan dan perkembangan anak secara berkala\n• Mendapatkan imunisasi lengkap sesuai jadwal\n• Deteksi dini gangguan tumbuh kembang anak\n• Mendapatkan vitamin A dan makanan tambahan\n• Informasi dan edukasi tentang kesehatan dan gizi\n• Pencegahan dan penanganan awal penyakit umum pada anak\n• Pemantauan kesehatan ibu hamil dan nifas",
      "category": "Umum"
    },
    {
      "question": "Bagaimana cara mendaftar anak baru di Posyandu?",
      "answer":
          "Untuk mendaftarkan anak baru di Posyandu, ikuti langkah-langkah berikut:\n\n1. Buka aplikasi Posyandu dan pilih menu 'Tambah Anggota Keluarga'\n2. Isi data anak secara lengkap (nama, tanggal lahir, jenis kelamin, dll.)\n3. Unggah dokumen pendukung (akta kelahiran atau surat keterangan lahir)\n4. Pilih Posyandu terdekat dengan tempat tinggal Anda\n5. Konfirmasi pendaftaran dan tunggu verifikasi\n\nSetelah terverifikasi, Anda dapat langsung mendaftarkan kunjungan untuk jadwal Posyandu berikutnya.",
      "category": "Pendaftaran"
    },
  ];

  final filteredFaqs = <Map<String, String>>[].obs;
  final expandAll = false.obs;
  final expandedStates = <bool>[].obs;

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.onClose();
  }

  void _onSearchChanged() {
    searchQuery.value = searchController.text;
    filterFaqs();
  }

  void filterFaqs() {
    filteredFaqs.clear();

    if (searchQuery.isEmpty && selectedCategory.value == "Semua") {
      filteredFaqs.addAll(faqList);
    } else {
      filteredFaqs.addAll(faqList.where((faq) {
        bool matchesSearch = searchQuery.isEmpty ||
            faq["question"]!
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            faq["answer"]!.toLowerCase().contains(searchQuery.toLowerCase());

        bool matchesCategory = selectedCategory.value == "Semua" ||
            faq["category"] == selectedCategory.value;

        return matchesSearch && matchesCategory;
      }));
    }

    expandedStates.value = List.generate(filteredFaqs.length, (_) => false);
  }

  void toggleExpandAll() {
    expandAll.value = !expandAll.value;
    expandedStates.value =
        List.generate(filteredFaqs.length, (_) => expandAll.value);
  }

  void toggleExpand(int index) {
    final List<bool> newList = [...expandedStates];
    newList[index] = !newList[index];
    expandedStates.value = newList;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    filterFaqs();
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchController.clear();
    }
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Umum':
        return Colors.blue;
      case 'Layanan':
        return Colors.purple;
      case 'Jadwal':
        return Colors.orange;
      case 'Pendaftaran':
        return Colors.green;
      default:
        return Colors.teal;
    }
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Umum':
        return Icons.info_outline;
      case 'Layanan':
        return Icons.medical_services_outlined;
      case 'Jadwal':
        return Icons.calendar_today_outlined;
      case 'Pendaftaran':
        return Icons.app_registration;
      default:
        return Icons.help_outline;
    }
  }

  // OPTIONAL: Untuk ringkasan artikel HTML
  String getRingkasan(String htmlString, {int maxLength = 100}) {
    final document = HtmlParser.parse(htmlString);
    final parsedText = document.body?.text ?? "";
    return parsedText.length > maxLength
        ? "${parsedText.substring(0, maxLength)}..."
        : parsedText;
  }
}
