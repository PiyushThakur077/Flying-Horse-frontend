import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/utils/text_style.dart';

import 'package:get/get.dart';

import '../controllers/refueling_controller.dart';

class RefuelingView extends GetView<RefuelingController> {
  const RefuelingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RefuelingView'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      body: ListView(
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
                          fontSize: 20, color: Color(0xffBDBDBD), height: 1.0)),
                  Text(
                    'All',
                    style: AppTextStyle.regularStyle(
                        fontSize: 26, color: Color(0xffBDBDBD), height: 1.0),
                  ),
                  Text('Refueling',
                      style: AppTextStyle.semiBoldStyle(
                          fontSize: 32, color: Colors.black, height: 1.0)),
                  Text('Location',
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
        ],
      ),
    );
  }
}
