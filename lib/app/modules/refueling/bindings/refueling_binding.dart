import 'package:get/get.dart';

import '../controllers/refueling_controller.dart';

class RefuelingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RefuelingController>(
      () => RefuelingController(),
    );
  }
}
