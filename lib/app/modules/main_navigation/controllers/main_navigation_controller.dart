import 'package:flutter/material.dart';
import 'package:flying_horse/app/modules/home/controllers/home_controller.dart';
import 'package:flying_horse/app/modules/home/views/home_view.dart';
import 'package:flying_horse/app/modules/profile/controllers/profile_controller.dart';
import 'package:flying_horse/app/modules/profile/views/profile_view.dart';
import 'package:flying_horse/app/modules/refueling/controllers/refueling_controller.dart';
import 'package:flying_horse/app/modules/refueling/views/refueling_view.dart';
import 'package:flying_horse/app/modules/users/controllers/users_controller.dart';
import 'package:flying_horse/app/modules/users/views/users_view.dart';
import 'package:get/get.dart';

class MainNavigationController extends GetxController {
  RxInt selectedIndex = 0.obs;
  List<Widget> bottomNavigationBarItems = [
    HomeView(),
    UsersView(),
    RefuelingView(),
    ProfileView(), 
  ];
  @override
  void onInit() {
    super.onInit();
  }

  get getSelectedIndex => selectedIndex.value;
  setSelectedIndex(int index) {
    if (index == 0) {
      Get.find<HomeController>().onInit();
    } else if (index == 1) {
      Get.find<UsersController>().getUsers(1);
    } else if (index == 2) {
      Get.find<RefuelingController>().onInit();
    }
    else if(index ==3){
      Get.find<ProfileController>().onInit();
    }
    this.selectedIndex.value = index;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
