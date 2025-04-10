import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
Widget build(BuildContext context) {
  HomeController controller = Get.put(HomeController());
    return Scaffold(
      backgroundColor: HexColor('#feeee8'),
      body: Center( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.network(
                ('assets/lottie/loading_med.json'),
                width: 250,
                height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Aplikasi Posyandu',
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}