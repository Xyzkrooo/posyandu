import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/artikelResponse.dart' as artikel;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as HtmlParser;

import '../../../utils/api.dart';

class ArtikelController extends GetxController {
  var artikelResponse = Rxn<artikel.ArtikelResponse>();
  var isLoadingArtikel = true.obs;
  var artikelList = <artikel.Artikel>[].obs;

  var artikelDetail = Rxn<artikel.Artikel>();
  var isLoadingDetail = true.obs;

  var relatedArtikelList = <artikel.Artikel>[].obs;
  var isLoadingRelated = true.obs;

  final storage = GetStorage();
  final token = RxnString();

  @override
  @override
  void onInit() {
    token.value = storage.read('token');

    if (token.value != null && token.value!.isNotEmpty) {
      getArtikel();
    } else {
      print('No token found');
      // optional: redirect ke login kalau mau
      Get.offAllNamed('/login');
    }

    super.onInit();
  }

  Future<void> refreshArtikel() async {
    await getArtikel();
    Get.snackbar(
      'Success',
      'Artikel berhasil diperbarui',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
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

  Future<void> getArtikelBySlug(String slug) async {
    isLoadingDetail.value = true;
    try {
      final response = await http.get(
        Uri.parse('${BaseUrl.artikel}/$slug'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        artikelDetail.value = artikel.Artikel.fromJson(jsonData['data']);
      } else {
        Get.snackbar('Error', 'Artikel tidak ditemukan');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat mengambil artikel: $e');
    } finally {
      isLoadingDetail.value = false;
    }
  }

  Future<void> getRelatedArtikel(String kategori, int exceptId) async {
    try {
      final response = await http.get(
        Uri.parse('${BaseUrl.artikel}/related/$kategori/$exceptId'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        relatedArtikelList.value = List<artikel.Artikel>.from(
          jsonData['data'].map((x) => artikel.Artikel.fromJson(x)),
        );
      }
    } catch (e) {
      print("Error related: $e");
    }
  }

  String getRingkasan(String htmlString, {int maxLength = 100}) {
    final document = HtmlParser.parse(htmlString);
    final parsedText = document.body?.text ?? "";
    return parsedText.length > maxLength
        ? "${parsedText.substring(0, maxLength)}..."
        : parsedText;
  }
}
