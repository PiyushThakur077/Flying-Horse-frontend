import 'dart:async';

import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 10.obs;
  Rx<Duration> duration = Duration().obs;
  Timer? timer;
  RxBool isCountDown = true.obs;
  @override
  void onInit() {
    super.onInit();
  }

  void reset() {
    duration.value = Duration();
  }

  void addTime() {
    final addSecond = 1;
    final seconds = duration.value.inSeconds + addSecond;
    duration.value = Duration(seconds: seconds);
  }

  void startTimer() {
    reset();
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
