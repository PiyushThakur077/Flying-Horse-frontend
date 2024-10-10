import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/routes/app_pages.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: AppColors.primary,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: AppColors.primary,
            systemNavigationBarDividerColor: AppColors.primary),
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Profiless'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            GetStorage().erase();
            Get.offAllNamed(Routes.LOGIN);
          },
          child: Text(
            'Logout',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    ));
  }
}
