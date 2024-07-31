import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/api_provider.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/modules/login/user.dart';
import 'package:flying_horse/app/modules/users/users_response.dart';
import 'package:get/get.dart';

class UsersController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<User> users = <User>[].obs;
  ScrollController scrollController = ScrollController();
  RxInt currentPage = 1.obs;
  RxInt lastPage = 1.obs;

  @override
  void onInit() {
    super.onInit();
    getUsers(currentPage.value);
    scrollControllerListener();
  }

  void scrollControllerListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (currentPage.value < lastPage.value && !isLoading.value) {
          currentPage.value++;
          getUsers(currentPage.value);
        }
      }
    });
  }

  Future<void> getUsers(int page) async {
    if (page == 1) {
      users.clear();  
      isLoading.value = true;
    } else {
      Get.dialog(
        Center(
          child: CupertinoActivityIndicator(
            color: AppColors.primary,
          ),
        ),
        barrierDismissible: false,
      );
    }

    try {
      var resp = await ApiProvider().getUsers(page.toString());
      print('API response: $resp'); // Debug print

      var usersResponse = UsersResponse.fromJson(resp);
      print('Parsed users: ${usersResponse.data}'); // Debug print

      if (page == 1) {
        isLoading.value = false;
      } else {
        Get.back();
      }

      if (usersResponse.data != null) {
        users.addAll(usersResponse.data!);
      }

      if (usersResponse.data != null && usersResponse.data!.length == 10) {
        lastPage.value = currentPage.value;  // Ensure lastPage value is correctly updated
      }

      users.refresh();
      print('Users list updated: ${users.length}'); // Debug print
    } catch (err) {
      isLoading.value = false;
      if (page != 1) Get.back();
      print('Error: $err'); // Debug print
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
