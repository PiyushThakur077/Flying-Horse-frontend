import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      // loginApiCall(id: Uuid().v4());
    } else {
      //form is invalid
      print('Form is invalid');
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
