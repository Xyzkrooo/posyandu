import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/layananResponse.dart' as layanan;
import '../../../data/layananResponse.dart';
import '../../../utils/api.dart';


class LayananController extends GetxController {
  var layananList = <layanan.Data>[].obs;
  var isLoading = true.obs;
  final storage = GetStorage();
  late final RxnString token;

  @override
  void onInit() {
    token = RxnString(storage.read('token'));
    if (token.value != null && token.value!.isNotEmpty) {
      fetchLayanan();
    }
    super.onInit();
  }

  Future<void> refreshLayanan() async {
    await fetchLayanan();
    Get.snackbar(
      'Success',
      'Data layanan berhasil diperbarui',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor,
      colorText: Colors.white,
    );
  }

  Future<void> fetchLayanan() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(BaseUrl.layanan), // pastikan endpoint ini sesuai
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final result = LayananResponse.fromJson(jsonData);
        layananList.value = result.data ?? [];
      } else {
        Get.snackbar("Error", "Gagal memuat data layanan.");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
