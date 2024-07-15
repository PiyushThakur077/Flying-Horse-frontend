import 'package:flying_horse/app/modules/home/controllers/home_controller.dart';
import 'package:flying_horse/app/modules/profile/controllers/profile_controller.dart';
import 'package:flying_horse/app/modules/refueling/controllers/refueling_controller.dart';
import 'package:flying_horse/app/modules/users/controllers/users_controller.dart';
import 'package:get/get.dart';

import '../controllers/main_navigation_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavigationController>(
      () => MainNavigationController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<UsersController>(
      () => UsersController(),
    );
     Get.lazyPut<RefuelingController>(
      () => RefuelingController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
   
  }
}
