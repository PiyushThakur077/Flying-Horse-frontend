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
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(children: [
                  const SizedBox(
                    width: 18,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Here is the list of',
                            style: AppTextStyle.regularStyle(
                                fontSize: 20,
                                color: const Color(0xffBDBDBD),
                                height: 1.0)),
                        Text(
                          'All',
                          style: AppTextStyle.regularStyle(
                              fontSize: 26,
                              color: const Color(0xffBDBDBD),
                              height: 1.0),
                        ),
                        Text('Refueling',
                            style: AppTextStyle.semiBoldStyle(
                                fontSize: 32,
                                color: Colors.black,
                                height: 1.0)),
                        Text('Location',
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
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Trip Details',
                          style: AppTextStyle.semiBoldStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                print("Filter");
                              },
                              child: const Icon(
                                Icons.tune_rounded,
                                size: 24.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    print("navigation Card clicked");
                  },
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Scania, 9.5 DDT",
                                    style: TextStyle(
                                        color: Color(0xff000000),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const Text(
                                    "15 July, 2024",
                                    style: TextStyle(color: Color(0xff646464)),
                                  )
                                ],
                              ),
                              const Icon(
                                Icons.adjust_rounded,
                                size: 24.0,
                                color: Colors.green,
                              ),
                            ],
                          ),
                          const Divider(
                            color: Color(0xffC5C5C5),
                          ),
                          Row(
                            children: [
                              Text("John S",
                                  style: AppTextStyle.mediumStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  )),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text("|",
                                  style: AppTextStyle.mediumStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  )),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text("Bob Jr.",
                                  style: AppTextStyle.mediumStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  )),
                                  
                            ],
                            
                          ),
                          const SizedBox(
                                height: 10.0,
                              ),
                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 24.0,
                                    color: Colors.black,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Fairmont Hotel Macdonald, Edmonton, AB T5J 0N6, Canada",
                                      style: TextStyle(
                                          color: const Color(0xffE50000),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                  ),
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
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Total fuel filled : 1,000 ltrs",
                                            style: TextStyle(
                                                color: const Color(0xff646464),
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text("Total amount : \$1530",
                                              style: TextStyle(
                                                  color: const Color(0xff646464),
                                                  fontWeight: FontWeight.w600))
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 24.0,
                                    color: Colors.black,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Fairmont Hotel Macdonald, Edmonton, AB T5J 0N6, Canada",
                                      style: TextStyle(
                                          color: const Color(0xff00970F),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            AppButton(
              padding: const EdgeInsets.symmetric(vertical: 20),
              onPressed: () {
                Get.to(() => RefuelView(), binding: RefuelBinding());
              },
              title: 'Add New Trip Detail',
            ),
          ],
        ),
      ),
    );
  }
}
