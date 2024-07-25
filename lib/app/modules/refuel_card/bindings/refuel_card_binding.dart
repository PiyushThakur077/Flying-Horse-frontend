import 'package:get/get.dart';

import '../controllers/refuel_card_controller.dart';

class RefuelCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RefuelCardController>(
      () => RefuelCardController(),
    );
  }
}
