import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/api_provider.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/modules/login/user.dart';
import 'package:flying_horse/app/routes/app_pages.dart';
import 'package:flying_horse/app/widgets/dialogs.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  FocusNode usernameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  RxBool obsecureCreatePassword = true.obs;
  @override
  void onInit() {
    super.onInit();
  }

  String? validateUserName(String text) {
    return text.length > 4 ? null : "Please enter valid username";
  }

  String? validatePassword(String text) {
    return text.length > 5 ? null : "Please enter valid password";
  }

  void validateAndContinue() {
    FocusManager.instance.primaryFocus?.unfocus();
    final FormState form = loginFormKey.currentState!;
    if (form.validate()) {
      //if form valid
      loginApiCall();
    } else {
      //form is invalid
      print('Form is invalid');
    }
  }

  Future<void> loginApiCall() async {
    Get.dialog(
        Center(child: CupertinoActivityIndicator(color: AppColors.primary)),
        barrierDismissible: false);

    var res = await ApiProvider().signIn({
      'email': usernameController.text,
      'password': passwordController.text,
    });

    Get.back();
    if (res['success'] ?? false) {
      UserData userData = LoginResponse.fromJson(res).data!;
      GetStorage().write('token', userData.token);
      GetStorage().write('userId', userData.user!.id);
      GetStorage().write('userName', userData.user!.name);
      Get.offAllNamed(
        Routes.MAIN_NAVIGATION,
      );
    } else {
      Widgets.showAppDialog(description: res['message'] ?? '');
    }
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
