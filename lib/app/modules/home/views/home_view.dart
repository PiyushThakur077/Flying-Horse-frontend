import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/utils/text_style.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          centerTitle: true,
        ),
        body: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CupertinoActivityIndicator(color: AppColors.primary),
                )
              : ListView(
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
                            Text('Hi ${GetStorage().read('userName')},',
                                style: AppTextStyle.regularStyle(
                                    fontSize: 20,
                                    color: Color(0xffBDBDBD),
                                    height: 1.0)),
                            Text(
                              'Choose Your',
                              style: AppTextStyle.regularStyle(
                                  fontSize: 26,
                                  color: Color(0xffBDBDBD),
                                  height: 1.0),
                            ),
                            Text('Status',
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text('To activate a status, slide to left',
                          style: AppTextStyle.regularStyle(
                              fontSize: 14, color: Colors.black, height: 1.0)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListView.separated(
                        padding: EdgeInsets.only(left: 20, right: 14),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => controller
                                    .selectedIndex.value ==
                                index
                            ? Container(
                                height: 64,
                                decoration: BoxDecoration(
                                    color: index == 0
                                        ? AppColors.available
                                        : index == 1
                                            ? AppColors.mayBe
                                            : index == 2
                                                ? AppColors.unavailable
                                                : AppColors.dnd,
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
                                      width: 8,
                                    ),
                                    Image.asset(
                                      'assets/images/thumb.png',
                                      color: Colors.white,
                                      height: 36,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                      child: Text(
                                        index == 0
                                            ? 'Available'
                                            : index == 1
                                                ? 'May Be Available'
                                                : index == 2
                                                    ? 'Unavailable'
                                                    : 'Do Not Disturb',
                                        style: AppTextStyle.mediumStyle(
                                            fontSize: 17, color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 9,
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                height: 64,
                                decoration: BoxDecoration(
                                    color: Color(0xffFAFAFA),
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
                                              text: index == 0
                                                  ? 'Available'
                                                  : index == 1
                                                      ? 'May Be Available'
                                                      : index == 2
                                                          ? 'Unavailable'
                                                          : 'Do Not Disturb',
                                              style: AppTextStyle.mediumStyle(
                                                  fontSize: 17,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Dismissible(
                                      confirmDismiss: (direction) async {
                                        if (direction ==
                                            DismissDirection.endToStart) {
                                          controller.selectedIndex.value =
                                              index;
                                          controller.startTimer();
                                          return false;
                                        }
                                      },
                                      key: Key(index.toString()),
                                      child: Image.asset(
                                        'assets/images/thumb_slide.png',
                                        color: index == 0
                                            ? AppColors.available
                                            : index == 1
                                                ? AppColors.mayBe
                                                : index == 2
                                                    ? AppColors.unavailable
                                                    : AppColors.dnd,
                                        height: 36,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 9,
                                    )
                                  ],
                                ),
                              ),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 15,
                            ),
                        itemCount: 4),
                    Container(
                        height: 125,
                        margin: EdgeInsets.all(20),
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
                        child: Column(children: [
                          Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(0xffE2E2E2),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5)),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                      child: Text(
                                    'Status',
                                    style:
                                        AppTextStyle.mediumStyle(fontSize: 20),
                                  )),
                                  Text(
                                    controller.selectedIndex.value == 0
                                        ? 'Available'
                                        : controller.selectedIndex.value == 1
                                            ? 'May Be Available'
                                            : controller.selectedIndex.value ==
                                                    2
                                                ? 'Unavailable'
                                                : controller.selectedIndex
                                                            .value ==
                                                        3
                                                    ? 'Do Not Disturb'
                                                    : 'Not Selected',
                                    style: AppTextStyle.regularStyle(
                                        fontSize: 14,
                                        color: controller.selectedIndex.value ==
                                                0
                                            ? AppColors.available
                                            : controller.selectedIndex.value ==
                                                    1
                                                ? AppColors.mayBe
                                                : controller.selectedIndex
                                                            .value ==
                                                        2
                                                    ? AppColors.unavailable
                                                    : controller.selectedIndex
                                                                .value ==
                                                            3
                                                        ? AppColors.dnd
                                                        : Colors.black),
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                ],
                              )),
                          Obx(() => buildTime())
                        ])),
                    // InkWell(
                    //   onTap: () {
                    //     controller.stopTimer();
                    //   },
                    //   child: Container(
                    //     height: 45,
                    //     margin: EdgeInsets.all(20),
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(5),
                    //         color: AppColors.primary),
                    //     child: Center(
                    //       child: Row(
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Text(
                    //             'Stop',
                    //             style: AppTextStyle.regularStyle(
                    //                 fontSize: 18, color: Colors.white),
                    //           ),
                    //           SizedBox(
                    //             width: 8,
                    //           ),
                    //           Image.asset(
                    //             'assets/images/stop.png',
                    //             height: 24,
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
        ));
  }

  Widget buildTime() {
    String twoDigit(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigit(controller.duration.value.inHours);
    final minutes = twoDigit(controller.duration.value.inMinutes.remainder(60));
    final seconds = twoDigit(controller.duration.value.inSeconds.remainder(60));
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            '$hours : $minutes : $seconds',
            style: AppTextStyle.semiBoldStyle(fontSize: 32),
          ),
          Text(
            'HOUR                 MIN                 SEC',
            style: AppTextStyle.regularStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
