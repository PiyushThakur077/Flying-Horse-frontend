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
          statusBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarDividerColor: Colors.white),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Image.asset(
                'assets/images/login_background.png',
                height: Get.height,
                width: Get.width,
                fit: BoxFit.cover,
              ),
              Obx(() => Form(
                    key: controller.loginFormKey,
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Image.asset(
                                'assets/images/horse_white.png',
                                height: 70,
                                width: 64,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Text(
                          'Username',
                          style: AppTextStyle.semiBoldStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: controller.usernameController,
                          maxLines: 1,
                          textAlignVertical: TextAlignVertical.center,
                          focusNode: controller.usernameFocus,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          style: AppTextStyle.mediumStyle(
                              fontSize: 14, color: Color(0xffD6D6D6)),
                          validator: (v) {
                            return controller.validateUserName(v ?? '');
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.5),
                            hintText: 'Username',
                            isDense: true,
                            hintStyle: AppTextStyle.regularStyle(
                                fontSize: 13, color: Color(0xffD6D6D6)),
                          ),
                          onChanged: (val) {},
                          onFieldSubmitted: (v) {
                            FocusScope.of(context)
                                .requestFocus(controller.passwordFocus);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Password',
                          style: AppTextStyle.semiBoldStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(
                          height: 8,
                        ),
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
                              fontSize: 14, color: Color(0xffD6D6D6)),
                          focusNode: controller.passwordFocus,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.5),
                              isDense: true,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  controller.obsecureCreatePassword.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.primary,
                                ),
                                onPressed: () {
                                  controller.obsecureCreatePassword.value =
                                      !controller.obsecureCreatePassword.value;

                                  // Update the state i.e. toogle the state of passwordVisible variable);
                                },
                              ),
                              hintStyle: AppTextStyle.regularStyle(
                                  fontSize: 13, color: Color(0xffD6D6D6)),
                              hintText: 'Password'),
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
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
