import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:get/get.dart';
import '../controllers/main_navigation_controller.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        body: controller.bottomNavigationBarItems
            .elementAt(controller.getSelectedIndex),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          child: GestureDetector(
            onTap: () {},
            child: BottomAppBar(
              height: 58,
              shape: CircularNotchedRectangle(),
              color: Colors.white,
              elevation: 0.0,
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                showUnselectedLabels: true,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                elevation: 0.0,
                showSelectedLabels: true,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: Colors.black,
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/tab_home.png',
                      height: 24,
                    ),
                    label: "home".tr,
                    activeIcon: Image.asset(
                      'assets/images/tab_home.png',
                      color: AppColors.primary,
                      height: 24,
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/tab_users.png',
                      height: 24,
                    ),
                    label: 'users'.tr,
                    activeIcon: Image.asset(
                      'assets/images/tab_users.png',
                      color: AppColors.primary,
                      height: 24,
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/tab_fuel.png',
                      height: 24,
                    ),
                    label: 'REFUEL'.tr,
                    activeIcon: Image.asset(
                      'assets/images/tab_fuel.png',
                      color: AppColors.primary,
                      height: 24,
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/tab_profile.png',
                      height: 24,
                    ),
                    label: 'profile'.tr,
                    activeIcon: Image.asset(
                      'assets/images/tab_profile.png',
                      color: AppColors.primary,
                      height: 24,
                    ),
                  ),
                ],
                currentIndex: controller.getSelectedIndex,
                onTap: (index) async {
                  controller.setSelectedIndex(index);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
