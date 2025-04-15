import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Tambahkan import ini

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi GetStorage
  await GetStorage.init();
  
  // Inisialisasi format tanggal untuk locale Indonesia
  await initializeDateFormatting('id_ID', null);
  
  // Set locale default untuk GetX
  Get.updateLocale(const Locale('id', 'ID'));

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Posyandu",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      locale: const Locale('id', 'ID'), // Tetapkan locale default
      fallbackLocale: const Locale('en', 'US'), // Locale fallback jika 'id_ID' tidak tersedia
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
    ),
  );
}