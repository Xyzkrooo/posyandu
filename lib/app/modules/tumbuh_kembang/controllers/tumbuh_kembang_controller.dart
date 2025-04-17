import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/tumbuhKembangResponse.dart' as tumbuhKembangModel;
import '../../../utils/api.dart';

class TumbuhKembangController extends GetxController {
  var isLoading = true.obs;
  var tumbuhKembangList = <tumbuhKembangModel.Data>[].obs;
  var selectedIndex = 0.obs;
  final storage = GetStorage();
  late final RxnString token;

  @override
  void onInit() {
    token = RxnString(storage.read('token'));
    if (token.value != null) {
      fetchTumbuhKembang();
    }
    super.onInit();
  }

  /// Method utama untuk mengambil data dari API
  Future<void> fetchTumbuhKembang() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(BaseUrl.tumbuhKembang),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final parsed = tumbuhKembangModel.TumbuhKembangResponse.fromJson(jsonData);
        tumbuhKembangList.assignAll(parsed.data ?? []);
      } else {
        Get.snackbar("Gagal", "Gagal mengambil data tumbuh kembang");
      }
    } catch (e) {
      Get.snackbar("Kesalahan", "Terjadi kesalahan: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Method untuk refresh data saat tekan "Coba Lagi"
  void loadData() {
    if (token.value != null) {
      fetchTumbuhKembang();
    } else {
      Get.snackbar("Token tidak ditemukan", "Silakan login kembali.");
    }
  }
}
