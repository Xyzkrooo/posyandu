import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/profileResponse.dart';
import '../../../utils/api.dart';
import '../views/index_view.dart';
import '../views/jadwal_view.dart';

class DashboardController extends GetxController {
  var profileResponse = Rxn<ProfileResponse>();
  var selectedIndex = 0.obs;

  final token = GetStorage().read('token');

  Future<void> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse(BaseUrl.profile),
        headers: {
          'Authorization': 'Bearer $token',
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
          'Gagal mengambil profil',
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

  void logOut() async {
    try {
      final response = await http.post(
        Uri.parse(BaseUrl.logout),
        headers: {
          'Authorization': 'Bearer $token',
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
        GetStorage().erase();
        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          'Failed',
          'Logout gagal',
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

  final List<Widget> pages = [
    IndexView(),
    JadwalView(),
  ];

  @override
  void onInit() {
    getProfile(); // panggil saat init
    super.onInit();
  }
}
