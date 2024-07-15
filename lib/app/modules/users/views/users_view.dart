import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/utils/text_style.dart';

import 'package:get/get.dart';

import '../controllers/users_controller.dart';

class UsersView extends GetView<UsersController> {
  const UsersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: AppColors.primary,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: AppColors.primary,
            systemNavigationBarDividerColor: AppColors.primary),
        child: Scaffold(
            appBar: AppBar(
              title: Text('Users'),
              centerTitle: true,
              backgroundColor: AppColors.primary,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
            ),
            body: Obx(
              () => controller.isLoading.value
                  ? Center(
                      child:
                          CupertinoActivityIndicator(color: AppColors.primary),
                    )
                  : ListView(
                      controller: controller.scrollController,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(children: [
                          SizedBox(
                            width: 18,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Here is the list of',
                                    style: AppTextStyle.regularStyle(
                                        fontSize: 20,
                                        color: Color(0xffBDBDBD),
                                        height: 1.0)),
                                Text(
                                  'All',
                                  style: AppTextStyle.regularStyle(
                                      fontSize: 26,
                                      color: Color(0xffBDBDBD),
                                      height: 1.0),
                                ),
                                Text('Users',
                                    style: AppTextStyle.semiBoldStyle(
                                        fontSize: 32,
                                        color: Colors.black,
                                        height: 1.0)),
                              ],
                            ),
                          ),
                          Image.asset(
                            'assets/images/horse_black.png',
                            height: 138,
                          )
                        ]),
                        SizedBox(
                          height: 20,
                        ),
                        ListView.separated(
                            padding: EdgeInsets.only(left: 20, right: 14),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => Container(
                                  height: 64,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: Offset(0, 0),
                                        ),
                                      ]),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    '${controller.users[index].name}, ',
                                                style: AppTextStyle.boldStyle(
                                                    fontSize: 17,
                                                    color: Colors.black),
                                              ),
                                              TextSpan(
                                                text: controller.users[index]
                                                            .statusId ==
                                                        1
                                                    ? 'Available'
                                                    : controller.users[index]
                                                                .statusId ==
                                                            2
                                                        ? 'May Be Available'
                                                        : controller
                                                                    .users[
                                                                        index]
                                                                    .statusId ==
                                                                3
                                                            ? 'Unavailable'
                                                            : controller
                                                                        .users[
                                                                            index]
                                                                        .statusId ==
                                                                    4
                                                                ? 'Do Not Disturb'
                                                                : '',
                                                style:
                                                    AppTextStyle.regularStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xffBDBDBD)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 64,
                                        decoration: BoxDecoration(
                                            color: controller.users[index]
                                                        .statusId ==
                                                    1
                                                ? AppColors.available
                                                : controller.users[index]
                                                            .statusId ==
                                                        2
                                                    ? AppColors.mayBe
                                                    : controller.users[index]
                                                                .statusId ==
                                                            3
                                                        ? AppColors.unavailable
                                                        : controller
                                                                    .users[
                                                                        index]
                                                                    .statusId ==
                                                                4
                                                            ? AppColors.dnd
                                                            : Colors.grey,
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(5),
                                                bottomRight:
                                                    Radius.circular(5))),
                                        width: 64,
                                      )
                                    ],
                                  ),
                                ),
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 15,
                                ),
                            itemCount: controller.users.length)
                      ],
                    ),
            )));
  }
}
