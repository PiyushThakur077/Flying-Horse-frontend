import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/api_provider.dart';
import 'package:flying_horse/app/data/colors.dart';
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
    getUsers(1);
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
      var resp = await ApiProvider().getUsers(page, perPage: 50);

      // Map response to the new UsersListResponse model
      UserResponse usersListResponse = UserResponse.fromJson(resp);

      if (page == 1) {
        users.clear();
      }

      // Loop through teams and add users to the list
      for (var team in usersListResponse.data.teams) {
        users.addAll(team.users);
      }

      lastPage.value = (usersListResponse.data.total / usersListResponse.data.perPage).ceil();

    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
      if (page > 1) {
        Get.back();
      }
    }
  }
}

