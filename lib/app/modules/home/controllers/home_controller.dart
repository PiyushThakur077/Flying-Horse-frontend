import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flying_horse/app/data/api_provider.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/modules/home/user_detail_response.dart';
import 'package:flying_horse/app/modules/login/user.dart';
import 'package:flying_horse/app/widgets/dialogs.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 10.obs;
  Rx<Duration> duration = Duration().obs;
  Timer? timer;
  RxBool isCountDown = true.obs;
  RxBool isLoading = false.obs;
  Rx<User> user = User().obs;
  @override
  void onInit() {
    super.onInit();
    getUser();
  }

  void reset() {
    duration.value = Duration();
  }

  void addTime() {
    final addSecond = 1;
    final seconds = duration.value.inSeconds + addSecond;
    duration.value = Duration(seconds: seconds);
  }

  getUser() {
    stopTimer();
    isLoading.value = true;
    ApiProvider().getUser().then((resp) {
      isLoading.value = false;
      user.value = UserDetailResponse.fromJson(resp).data!;
      if (user.value.statusId != null)
        duration.value =
            DateTime.now().difference(DateTime.parse(user.value.updatedAt!));
      selectedIndex.value = (user.value.statusId ?? 10) - 1;
      if (user.value.statusId != null) resumeTimer();
      // duration.value = DateTime.now().difference(DateTime(2023, 09, 21));
    }, onError: (err) {
      isLoading.value = false;
    });
  }

  Future<void> changeStatusApi(int status) async {
    Get.dialog(
        Center(
            child: CupertinoActivityIndicator(
          color: AppColors.primary,
        )),
        barrierDismissible: false);
    startTimer();
    var res = await ApiProvider().updateStatus({
      'status_id': (status + 1),
    });
    Get.back();
    if (res['success'] ?? false) {
      // UserData userData = LoginResponse.fromJson(res).data!;
      selectedIndex.value = status;
    } else {
      Widgets.showAppDialog(description: res['message'] ?? '');
    }
  }

  void startTimer() {
    stopTimer();
    reset();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      addTime();
    });
  }

  void resumeTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      addTime();
    });
  }

  void stopTimer() {
    timer?.cancel();
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
