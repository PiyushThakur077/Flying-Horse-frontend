import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/modules/refuel/bindings/refuel_binding.dart';
import 'package:flying_horse/app/modules/refuel/views/refuel_view.dart';
import 'package:flying_horse/app/utils/text_style.dart';
import 'package:flying_horse/app/widgets/app_button.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:get/get.dart';
import '../controllers/refueling_controller.dart';

class RefuelingView extends GetView<RefuelingController> {
  const RefuelingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Refueling'),
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
                            fontSize: 20,
                            color: Color(0xffBDBDBD),
                            height: 1.0)),
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trip Detail',
                    style: AppTextStyle.mediumStyle(
                        fontSize: 18, color: Colors.black),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          print("Filter");
                        },
                        child: Row(
                          children: [
                            Text(
                              "Filter",
                              style: AppTextStyle.mediumStyle(
                                  fontSize: 18, color: Colors.black),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Icon(
                              Icons.tune,
                              size: 24.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    print("navigation Card clicked");
                  },
                  child: Container(
                    width: 345,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    decoration: BoxDecoration(color: Color(0xffffffff)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text("Scania, 9.5 DDT"),
                              Text("15 July, 2024")
                            ]),
                            Icon(
                              Icons.adjust_rounded,
                              size: 24.0,
                              color: Colors.green,
                            ),
                          ],
                        ),
                        Divider(
                          color: Color(0xffC5C5C5),
                        ),
                        Row(
                          children: [
                            Text("John S"),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text("|"),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text("Bob Jr.")
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 24.0,
                                  color: Colors.black,
                                ),
                                Expanded(
                                    child: Text(
                                  "Fairmont Hotel Macdonald, Edmonton, AB T5J 0N6, Canada",
                                )),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: DottedLine(
                                    direction: Axis.vertical,
                                    lineThickness: 1.0,
                                    dashLength: 4.0,
                                    dashColor: Colors.black,
                                    dashRadius: 0.0,
                                    dashGapLength: 4.0,
                                    dashGapColor: Colors.transparent,
                                    dashGapRadius: 0.0,
                                    lineLength: 60.0,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Total fuel filled : 1,000 ltrs"),
                                        Text("Total amount : 1530")
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 24.0,
                                  color: Colors.black,
                                ),
                                Expanded(
                                    child: Text(
                                  "Fairmont Hotel Macdonald, Edmonton, AB T5J 0N6, Canada",
                                )),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                AppButton(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  onPressed: () {
                    Get.to(() => RefuelView(), binding: RefuelBinding());
                  },
                  title: 'Add New Trip Detail',
                ),
              ],
            ),
          ],
        ));
  }
}
