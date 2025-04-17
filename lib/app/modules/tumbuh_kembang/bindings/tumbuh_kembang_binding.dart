import 'package:get/get.dart';

import '../controllers/tumbuh_kembang_controller.dart';

class TumbuhKembangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TumbuhKembangController>(
      () => TumbuhKembangController(),
    );
  }
}
