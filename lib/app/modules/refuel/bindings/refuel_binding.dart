import 'package:get/get.dart';
import '../controllers/refuel_controller.dart';

class RefuelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RefuelController>(() => RefuelController());
  }
}
