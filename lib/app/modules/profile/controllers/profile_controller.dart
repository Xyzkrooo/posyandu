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
  
  // Form Controllers untuk Edit Profile
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  
  // Form Controllers untuk Change Password
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Loading states
  var isLoadingProfile = false.obs;
  var isUpdatingProfile = false.obs;
  var isChangingPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
    token.value = storage.read('token') ?? '';
    getProfile();
  }

  @override
  void onClose() {
    // Dispose all controllers
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void populateFormFields() {
    if (profileResponse.value != null && profileResponse.value!.user != null) {
      final user = profileResponse.value!.user!;
      nameController.text = user.nama ?? '';
      usernameController.text = user.username ?? '';
      emailController.text = user.email ?? '';
      phoneController.text = user.noTelp ?? '';
    }
  }

  Future getProfile() async {
    isLoadingProfile.value = true;
    try {
      final response = await http.get(
        Uri.parse(BaseUrl.profile),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
      );
      
      isLoadingProfile.value = false;
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        profileResponse.value = ProfileResponse.fromJson(jsonData);
        populateFormFields();
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
      isLoadingProfile.value = false;
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Colors.white,
      );
    }
  }

  Future updateProfile() async {
    if (nameController.text.isEmpty || 
        usernameController.text.isEmpty || 
        emailController.text.isEmpty ||
        phoneController.text.isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Semua field harus diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isUpdatingProfile.value = true;
    try {
      final response = await http.post(
        Uri.parse(BaseUrl.updateProfile),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'nama': nameController.text,
          'username': usernameController.text,
          'email': emailController.text,
          'no_telp': phoneController.text,
        }),
      );
      
      isUpdatingProfile.value = false;
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        profileResponse.value = ProfileResponse.fromJson(jsonData);
        
        Get.snackbar(
          'Sukses',
          'Profil berhasil diperbarui',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Refresh profile data after update
        getProfile();
      } else {
        Get.snackbar(
          'Gagal',
          'Gagal memperbarui profil (${response.statusCode})',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isUpdatingProfile.value = false;
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future changePassword() async {
    // Validasi password
    if (currentPasswordController.text.isEmpty || 
        newPasswordController.text.isEmpty || 
        confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Semua field password harus diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Validasi Gagal',
        'Password baru dan konfirmasi password tidak sama',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isChangingPassword.value = true;
    try {
      final response = await http.post(
        Uri.parse(BaseUrl.changePassword),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'password_lama': currentPasswordController.text,
          'password_baru': newPasswordController.text,
          'password_baru_confirmation': confirmPasswordController.text,
        }),
      );
      
      isChangingPassword.value = false;
      if (response.statusCode == 200) {
        // Reset password fields
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        
        Get.snackbar(
          'Sukses',
          'Password berhasil diubah',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        final jsonData = json.decode(response.body);
        final message = jsonData['message'] ?? 'Gagal mengubah password';
        
        Get.snackbar(
          'Gagal',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isChangingPassword.value = false;
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  void updateProfilePicture(String imagePath) async {
  if (imagePath.isEmpty) {
    Get.snackbar("Gagal", "Silakan pilih gambar terlebih dahulu",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white);
    return;
  }

  isUpdatingProfile.value = true;

  try {
    final uri = Uri.parse(BaseUrl.updateProfile);
    var request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer ${token.value}';

    // Kirim foto
    request.files.add(await http.MultipartFile.fromPath('foto', imagePath));

    // Sertakan field wajib lainnya
    request.fields['nama'] = nameController.text;
    request.fields['username'] = usernameController.text;
    request.fields['no_telp'] = phoneController.text;
    request.fields['email'] = emailController.text;

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    isUpdatingProfile.value = false;

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      profileResponse.value = ProfileResponse.fromJson(jsonData);

      Get.snackbar("Sukses", "Foto profil berhasil diperbarui",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);

      getProfile(); // refresh data
    } else {
      print("Response Body: ${response.body}");
      Get.snackbar("Gagal", "Gagal memperbarui foto profil",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  } catch (e) {
    isUpdatingProfile.value = false;
    print("Upload Error: $e");
    Get.snackbar("Error", "Terjadi kesalahan saat upload",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white);
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