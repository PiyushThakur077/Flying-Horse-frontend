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
  RxInt current_page = 1.obs;
  RxInt last_page = 1.obs;
  @override
  void onInit() {
    super.onInit();
    scrollControllerListner();
    getUsers(current_page.value);
  }

  scrollControllerListner() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (current_page.value < last_page.value) {
          current_page.value++;
          getUsers(current_page.value);
        }
      }
    });
  }

  getUsers(int page) {
    if (page == 1) {
      users.clear();
      isLoading.value = true;
    } else {
      Get.dialog(
          Center(
              child: CupertinoActivityIndicator( 
            color: AppColors.primary,
          )),
          barrierDismissible: false);
    }
    ApiProvider().getUsers(page.toString()).then((resp) {
      if (page == 1) {
        isLoading.value = false;
      } else {
        Get.back();
      }
      users.addAll(UsersResponse.fromJson(resp).data!);
      if (UsersResponse.fromJson(resp).data!.length == 10) {
        last_page.value++;
      }
      users.refresh();
    }, onError: (err) {
      isLoading.value = false;
    });
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
