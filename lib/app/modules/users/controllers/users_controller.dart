import 'package:flying_horse/app/data/api_provider.dart';
import 'package:flying_horse/app/modules/login/user.dart';
import 'package:flying_horse/app/modules/users/users_response.dart';
import 'package:get/get.dart';

class UsersController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<User> users = <User>[].obs;
  @override
  void onInit() {
    super.onInit();
    getUsers(1);
  }

  getUsers(int page) {
    users.clear();
    isLoading.value = true;
    ApiProvider().getUsers().then((resp) {
      isLoading.value = false;
      users.addAll(UsersResponse.fromJson(resp).data!);
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
