import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFF87CEFA)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/loading_med.json',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller.usernameController,
                  'Username',
                  Icons.person,
                  false,
                  controller.usernameError.value,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller.passwordController,
                  'Password',
                  Icons.lock,
                  true,
                  controller.passwordError.value,
                ),
                const SizedBox(height: 25),
                _buildLoginButton(controller),
              ],
            )),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
    bool isPassword,
    String errorText,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: Icon(icon, color: Colors.blueAccent),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              ),
            ),
          ),
          if (errorText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 12),
              child: Text(
                errorText,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(LoginController controller) {
    return Obx(() => GestureDetector(
      onTap: controller.isLoading.value ? null : controller.loginNow,
      child: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: controller.isLoading.value ? Colors.grey : Colors.blueAccent,
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: controller.isLoading.value
              ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                )
              : const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    ));
  }
}
