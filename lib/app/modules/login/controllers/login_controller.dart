import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../utils/api.dart';
import '../../dashboard/views/dashboard_view.dart';

class LoginController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final authToken = GetStorage();

  var isLoading = false.obs;
  var usernameError = ''.obs;
  var passwordError = ''.obs;

  void loginNow() async {
    usernameError.value = '';
    passwordError.value = '';

    if (usernameController.text.isEmpty) {
      usernameError.value = 'Username tidak boleh kosong';
    }
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password tidak boleh kosong';
    }

    // Stop proses jika ada error
    if (usernameError.isNotEmpty || passwordError.isNotEmpty) return;

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(BaseUrl.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': usernameController.text,
          'password': passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        authToken.write('token', data['token']);
        Get.offAll(() => const DashboardView());
      } else {
        Get.snackbar(
          'Login Gagal',
          data['message'] ?? 'Username atau password salah',
          icon: const Icon(Icons.error, color: Colors.white),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan jaringan atau server.',
        icon: const Icon(Icons.error, color: Colors.white),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
