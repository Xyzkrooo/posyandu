import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/layananResponse.dart' as layanan;
import '../../../utils/api.dart';

class LayananController extends GetxController {
  final layananList = <layanan.Data>[].obs;
  final isLoading = true.obs;

  final layananDetail = Rxn<layanan.Data>();
  final isLoadingDetail = true.obs;

  final storage = GetStorage();
  late final RxnString token;

  // Search & Filter
  late TextEditingController searchController;
  final searchText = ''.obs;
  final selectedCategory = 'Semua'.obs;
  final filteredLayananList = <layanan.Data>[].obs;

  @override
  void onInit() {
    super.onInit();
    token = RxnString(storage.read('token'));
    initSearch();

    if (token.value != null && token.value!.isNotEmpty) {
      fetchLayanan();
    } else {
      print('Token tidak ditemukan');
      Get.offAllNamed('/login');
    }
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
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse(BaseUrl.layanan),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final result = layanan.LayananResponse.fromJson(jsonData);
        layananList.value = result.data ?? [];
        applyFilters(); // supaya filtered list langsung update
      } else {
        Get.snackbar("Error", "Gagal memuat data layanan.");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getLayananDetail(String slug) async {
    isLoadingDetail.value = true;
    try {
      final response = await http.get(
        Uri.parse('${BaseUrl.layanan}/$slug'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        layananDetail.value = layanan.Data.fromJson(jsonData['data']);
      } else {
        Get.snackbar('Error', 'Layanan tidak ditemukan');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil layanan: $e');
    } finally {
      isLoadingDetail.value = false;
    }
  }

  void initSearch() {
    searchController = TextEditingController();
    ever(layananList, (_) => applyFilters());
  }

  void searchLayanan(String query) {
    searchText.value = query;
    applyFilters();
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    applyFilters();
  }

  void applyFilters() {
    if (layananList.isEmpty) {
      filteredLayananList.clear();
      return;
    }

    List<layanan.Data> result = layananList;

    // Search filter
    if (searchText.value.isNotEmpty) {
      result = result.where((item) {
        final nama = item.namaLyn?.toLowerCase() ?? '';
        final ket = item.keteranganSingkat?.toLowerCase() ?? '';
        return nama.contains(searchText.value.toLowerCase()) ||
            ket.contains(searchText.value.toLowerCase());
      }).toList();
    }

    // Category filter
    if (selectedCategory.value != 'Semua') {
      result = result
          .where((item) => item.jenisLyn == selectedCategory.value)
          .toList();
    }

    filteredLayananList.value = result;
  }

  void clearSearch() {
    searchController.clear();
    searchText.value = '';
    applyFilters();
  }

  void resetFilters() {
    selectedCategory.value = 'Semua';
    clearSearch();
  }
  
}
