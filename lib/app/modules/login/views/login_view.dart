import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F7FA), Color(0xFFE4ECF7)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo/Animation
                  Lottie.asset(
                    'assets/lottie/loading_med.json',
                    width: screenSize.width * 0.35,
                    height: screenSize.width * 0.35,
                  ),
                  
                  // Welcome Text
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      children: [
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to continue',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Login Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Username field
                        Obx(() => _buildTextField(
                          controller.usernameController,
                          'Username',
                          Icons.person_outline,
                          false,
                          controller.usernameError.value,
                          controller,
                        )),
                        const SizedBox(height: 20),
                        
                        // Password field
                        Obx(() => _buildTextField(
                          controller.passwordController,
                          'Password',
                          Icons.lock_outline,
                          true,
                          controller.passwordError.value,
                          controller,
                        )),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 35),
                  
                  // Login Button
                  Obx(() => _buildLoginButton(controller)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController fieldController,
    String hint,
    IconData icon,
    bool isPassword,
    String errorText,
    LoginController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: errorText.isNotEmpty ? Colors.red : Colors.grey.shade200,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: fieldController,
            obscureText: isPassword ? controller.isPasswordHidden.value : false,
            style: TextStyle(fontSize: 16, color: Colors.blueGrey[700]),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.blueGrey[300]),
              prefixIcon: Icon(icon, color: Colors.blueGrey[400]),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        controller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.blueGrey[300],
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
            ),
          ),
        ),
        if (errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildLoginButton(LoginController controller) {
    return GestureDetector(
      onTap: controller.isLoading.value ? null : controller.loginNow,
      child: Container(
        width: 200,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: controller.isLoading.value
              ? LinearGradient(
                  colors: [Colors.grey.shade300, Colors.grey.shade400],
                )
              : LinearGradient(
                  colors: [Colors.blueGrey[300]!, Colors.blueGrey[600]!],
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: controller.isLoading.value
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}