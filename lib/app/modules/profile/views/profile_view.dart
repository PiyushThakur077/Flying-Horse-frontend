import 'package:flutter/material.dart';
import 'package:flying_horse/app/routes/app_pages.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileView'),
        centerTitle: true,
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
    );
  }
}
