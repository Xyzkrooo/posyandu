import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../../../utils/api.dart';

import '../../../data/profileResponse.dart';

class ProfileController extends GetxController {
  final storage = GetStorage();

  var profileResponse = Rxn<ProfileResponse>();
  var token = ''.obs;

  @override
  void onInit() {
    super.onInit();
    token.value = storage.read('token') ?? '';
    getProfile();
  }

  Future<void> getProfile() async {
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
        profileResponse.value = ProfileResponse.fromJson(jsonData);
      } else {
        Get.snackbar(
          'Error',
          'Gagal mengambil profil (${response.statusCode})',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Colors.white,
      );
    }
  }

  void logOut() async {
    try {
      final response = await http.post(
        Uri.parse(BaseUrl.logout),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        await storage.erase();
        Get.offAllNamed('/login');
        Get.snackbar(
          'Success',
          'Logout berhasil',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
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
}
