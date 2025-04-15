import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../../../data/anakResponse.dart' as anakModel;
import '../../../utils/api.dart';

class AnakController extends GetxController {
  var anakList = <anakModel.Data>[].obs;
  var isLoading = true.obs;
  final storage = GetStorage();
  late final RxnString token;

  @override
  void onInit() {
    token = RxnString(storage.read('token'));
    if (token.value != null && token.value!.isNotEmpty) {
      fetchAnak();
    }
    super.onInit();
  }

  Future<void> refreshAnak() async {
    await fetchAnak();
    Get.snackbar(
      'Success',
      'Jadwal berhasil diperbarui',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> fetchAnak() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(BaseUrl.anak),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final result = anakModel.AnakResponse.fromJson(jsonData);
        anakList.value = result.data ?? [];
      } else {
        Get.snackbar("Error", "Gagal memuat data anak.");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
