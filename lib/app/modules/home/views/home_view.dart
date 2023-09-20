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
          title: const Text('HomeView'),
          centerTitle: true,
        ),
        body: Obx(
          () => ListView(
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
                      Text('Hi John,',
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
                              fontSize: 32, color: Colors.black, height: 1.0)),
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
                  itemBuilder: (context, index) => Dismissible(
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          controller.selectedIndex.value = index;
                          return false;
                        }
                      },
                      key: Key(index.toString()),
                      child: controller.selectedIndex.value == index
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
                                  Image.asset(
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
                                  SizedBox(
                                    width: 9,
                                  )
                                ],
                              ),
                            )),
                  separatorBuilder: (context, index) => SizedBox(
                        height: 15,
                      ),
                  itemCount: 4),
            ],
          ),
        ));
  }
}
