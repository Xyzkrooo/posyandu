import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../data/jadwalResponse.dart' as jadwalModel;
import '../../../utils/api.dart';

class JadwalController extends GetxController {
  var jadwalList = <jadwalModel.Data>[].obs;
  var filteredList = <jadwalModel.Data>[].obs;

  var isLoading = true.obs;
  final storage = GetStorage();
  late final RxnString token;
  var selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    token = RxnString(storage.read('token'));
    if (token.value != null && token.value!.isNotEmpty) {
      fetchJadwal();
    }

    // Auto-refresh ketika filteredList dikosongkan
    ever(filteredList, (_) {
      if (filteredList.isEmpty) {
        selectedDate.value = DateTime
            .now(); // Set kembali ke tanggal hari ini atau tanggal yang diinginkan
      }
    });

    super.onInit();
  }

  Future<void> refreshJadwal() async {
    await fetchJadwal();
    Get.snackbar(
      'Success',
      'Jadwal berhasil diperbarui',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> fetchJadwal() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(BaseUrl.jadwal),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final result = jadwalModel.JadwalResponse.fromJson(jsonData);
        jadwalList.value = result.data ?? [];

        // Sort jadwal berdasarkan tanggal
        jadwalList.sort((a, b) {
          final dateA =
              DateTime.tryParse(a.tanggalKegiatan ?? '') ?? DateTime.now();
          final dateB =
              DateTime.tryParse(b.tanggalKegiatan ?? '') ?? DateTime.now();
          return dateA.compareTo(dateB);
        });
      } else {
        Get.snackbar("Error", "Gagal memuat data jadwal.");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<jadwalModel.Data> get jadwalHariIni {
    final filtered = jadwalList.where((item) {
      if (item.tanggalKegiatan == null) return false;

      final itemDate = DateTime.tryParse(item.tanggalKegiatan!);
      if (itemDate == null) {
        return false;
      }

      final isSame = isSameDay(itemDate, selectedDate.value);

      return isSame;
    }).toList();

    return filtered;
  }

  void filterByDateRange(DateTime start, DateTime end) {
    filteredList.value = jadwalList.where((item) {
      final itemDate = DateTime.tryParse(item.tanggalKegiatan ?? '');
      if (itemDate == null) return false;
      return itemDate.isAfter(start.subtract(const Duration(days: 1))) &&
          itemDate.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }
}
