import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/utils/text_style.dart';
import 'package:flying_horse/app/widgets/app_button.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/login_background1.png',
                fit: BoxFit.cover,
              ),
            ),
            // Overlay color
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            // Main content
            SafeArea(
              child: Obx(
                () => Form(
                  key: controller.loginFormKey,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Image.asset(
                          'assets/images/login_top.png',
                          height: 215,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 60),
                      Text(
                        'Username',
                        style: AppTextStyle.semiBoldStyle(
                            fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: controller.usernameController,
                        maxLines: 1,
                        textAlignVertical: TextAlignVertical.center,
                        focusNode: controller.usernameFocus,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: AppTextStyle.mediumStyle(
                            fontSize: 14, color: Color(0xffffffff)),
                        validator: (v) {
                          return controller.validateUserName(v ?? '');
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.3),
                          hintText: 'Username',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          hintStyle: AppTextStyle.regularStyle(
                              fontSize: 13, color: Color(0xffffffff)),
                        ),
                        onChanged: (val) {},
                        onFieldSubmitted: (v) {
                          FocusScope.of(context)
                              .requestFocus(controller.passwordFocus);
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Password',
                        style: AppTextStyle.semiBoldStyle(
                            fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: controller.passwordController,
                        maxLines: 1,
                        onChanged: (val) {},
                        validator: (v) {
                          return controller.validateUserName(v ?? '');
                        },
                        obscureText: controller.obsecureCreatePassword.value,
                        textAlignVertical: TextAlignVertical.center,
                        style: AppTextStyle.mediumStyle(
                            fontSize: 14, color: Color(0xffffffff)),
                        focusNode: controller.passwordFocus,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.3),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obsecureCreatePassword.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.primary,
                            ),
                            onPressed: () {
                              controller.obsecureCreatePassword.value =
                                  !controller.obsecureCreatePassword.value;
                            },
                          ),
                          hintStyle: AppTextStyle.regularStyle(
                              fontSize: 13, color: Color(0xffffffff)),
                          hintText: 'Password',
                        ),
                      ),
                      AppButton(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        onPressed: () {
                          controller.validateAndContinue();
                        },
                        title: 'Login',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
