import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/imunisasi_controller.dart';

class ImunisasiView extends GetView<ImunisasiController> {
  const ImunisasiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ImunisasiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ImunisasiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
