import 'package:get/get.dart';

import '../controllers/anak_controller.dart';

class AnakBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnakController>(
      () => AnakController(),
    );
  }
}
