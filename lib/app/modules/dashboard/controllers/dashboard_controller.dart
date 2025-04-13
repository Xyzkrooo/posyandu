import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as HtmlParser;

import '../../../data/artikelResponse.dart' as artikel;
import '../../../data/dashboardResponse.dart';
import '../../../data/profileResponse.dart';
import '../../../utils/api.dart';
import '../views/artikel_view.dart';
import '../views/cs_view.dart';
import '../views/faq_view.dart';
import '../views/index_view.dart';

class DashboardController extends GetxController {
  var profileResponse = Rxn<ProfileResponse>();
  var dashboardResponse = Rxn<DashboardResponse>();
  var artikelResponse = Rxn<artikel.ArtikelResponse>();

  var artikelList = <artikel.Data>[].obs;

  var isLoadingProfile = true.obs;
  var isLoadingArtikel = true.obs;
  var isLoadingDashboard = true.obs;

  var selectedIndex = 0.obs;
  final storage = GetStorage();
  late final RxnString token;

  final List<Widget> pages = [
    IndexView(),
    ArtikelView(),
    FAQView(),
    CSView(),
  ];

  @override
  void onInit() {
    token = RxnString(storage.read('token'));

    if (token.value != null && token.value!.isNotEmpty) {
      getProfile();
      getDashboard();
      getArtikel();
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

  Future<void> getArtikel() async {
    isLoadingArtikel.value = true;
    try {
      final response = await http.get(
        Uri.parse(BaseUrl.artikel), // ganti dengan endpoint artikelmu
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final newArtikelResponse = artikel.ArtikelResponse.fromJson(jsonData);
        artikelList.value = newArtikelResponse.data ?? [];
      } else {
        Get.snackbar(
          'Error',
          'Gagal memuat artikel (${response.statusCode})',
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
      isLoadingArtikel.value = false;
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

  // OPTIONAL: Untuk ringkasan artikel HTML
  String getRingkasan(String htmlString, {int maxLength = 100}) {
    final document = HtmlParser.parse(htmlString);
    final parsedText = document.body?.text ?? "";
    return parsedText.length > maxLength
        ? "${parsedText.substring(0, maxLength)}..."
        : parsedText;
  }
}
