import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/riwayatImunisasiResponse.dart' as riwayatImunisasiModel;
import '../../../data/riwayatImunisasiResponse.dart';
import '../../../utils/api.dart';

class ImunisasiController extends GetxController {
  var isLoading = true.obs;
  var riwayatImunisasiList = <riwayatImunisasiModel.Data>[].obs;
  var selectedAnakIndex = 0.obs;
  var namaAnakList = <String>[].obs;
  final storage = GetStorage();
  late final RxnString token;

  @override
  void onInit() {
    token = RxnString(storage.read('token'));
    if (token.value != null && token.value!.isNotEmpty) {
      fetchRiwayatImunisasi();
    }
    super.onInit();
    fetchRiwayatImunisasi();
  }

  Future<void> fetchRiwayatImunisasi() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(BaseUrl.riwayatImunisasi),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final parsed = RiwayatImunisasiResponse.fromJson(jsonData);
        riwayatImunisasiList.assignAll(parsed.data ?? []);

        final anakSet =
            riwayatImunisasiList.map((e) => e.namaAnak).toSet().toList();
        namaAnakList.assignAll(anakSet.whereType<String>());
      } else {
        Get.snackbar("Error", "Gagal memuat data");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<riwayatImunisasiModel.Data> get riwayatAnakTerpilih {
    if (namaAnakList.isEmpty) return [];
    final selectedName = namaAnakList[selectedAnakIndex.value];
    return riwayatImunisasiList
        .where((e) => e.namaAnak == selectedName)
        .toList();
  }
}
