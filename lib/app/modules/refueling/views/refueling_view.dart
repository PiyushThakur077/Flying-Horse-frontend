import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/modules/refuel/bindings/refuel_binding.dart';
import 'package:flying_horse/app/modules/refuel/views/refuel_view.dart';
import 'package:flying_horse/app/modules/refuel_card/bindings/refuel_card_binding.dart';
import 'package:flying_horse/app/modules/refuel_card/views/refuel_card_view.dart';
import 'package:flying_horse/app/utils/text_style.dart';
import 'package:flying_horse/app/widgets/app_button.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/refueling_controller.dart';

class RefuelingView extends GetView<RefuelingController> {
  const RefuelingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Refuel'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Here is the list of',
                                      style: AppTextStyle.regularStyle(
                                          fontSize: 20,
                                          color: const Color(0xffBDBDBD),
                                          height: 1.0)),
                                  Text('All',
                                      style: AppTextStyle.regularStyle(
                                          fontSize: 26,
                                          color: const Color(0xffBDBDBD),
                                          height: 1.0)),
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
                          ),
                          Image.asset(
                            'assets/images/horse_black.png',
                            height: screenHeight * 0.15,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 14),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.trips.length,
                        itemBuilder: (context, index) {
                          final trip = controller.trips[index];
                          final String status =
                              trip['status_name'] ?? 'unknown';

                          final Color iconColor =
                              (status.toLowerCase() == 'inprogress')
                                  ? Colors.green
                                  : Colors.red;

                          DateTime startDate =
                              DateTime.parse(trip['trip_start_date']);
                          DateTime endDate =
                              DateTime.parse(trip['trip_end_date']);

                          // Format dates
                          String formattedStartDate =
                              DateFormat('dd MMMM, yyyy').format(startDate);
                          String formattedEndDate =
                              DateFormat('dd MMMM, yyyy').format(endDate);

                          return InkWell(
                            onTap: () {
                              Get.to(
                                () => const RefuelCardView(),
                                arguments: {'id': trip['id'].toString()},
                                binding: RefuelCardBinding(),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 15.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                trip['truck_name'] ??
                                                    'Unknown Truck',
                                                style: const TextStyle(
                                                  color: Color(0xff000000),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Start Date: $formattedStartDate",
                                                    style: const TextStyle(
                                                      color: Color(0xff646464),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10.0),
                                                  Text(
                                                    "ETA: $formattedEndDate",
                                                    style: const TextStyle(
                                                      color: Color(0xff646464),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            Icons.adjust_rounded,
                                            size: 24.0,
                                            color: iconColor,
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        color: Color(0xffC5C5C5),
                                      ),
                                      Row(
                                        children: trip['users'] != null
                                            ? List<Widget>.generate(
                                                trip['users'].length, (index) {
                                                return Row(
                                                  children: [
                                                    Text(
                                                      trip['users'][index],
                                                      style: AppTextStyle
                                                          .mediumStyle(
                                                        fontSize: 17,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    if (index <
                                                        trip['users'].length -
                                                            1)
                                                      const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child: Text(
                                                          '|',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 17,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                );
                                              })
                                            : [const Text("No users")],
                                      ),
                                      const SizedBox(height: 10.0),
                                      Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                size: 24.0,
                                                color: Colors.black,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  trip['pickup_location'] ??
                                                      'Unknown Pickup Location',
                                                  style: const TextStyle(
                                                    color: Color(0xffE50000),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0),
                                                child: DottedLine(
                                                  direction: Axis.vertical,
                                                  lineThickness: 1.0,
                                                  dashLength: 4.0,
                                                  dashColor: Colors.black,
                                                  dashRadius: 0.0,
                                                  dashGapLength: 4.0,
                                                  dashGapColor:
                                                      Colors.transparent,
                                                  dashGapRadius: 0.0,
                                                  lineLength: 60.0,
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Total fuel filled: ${trip['total_fuel_quantity_liters'] ?? 0} ltrs",
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xff646464),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Total amount: \$${trip['total_amount_paid'] ?? 0}",
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xff646464),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                size: 24.0,
                                                color: Colors.black,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  trip['drop_location'] ??
                                                      'Unknown Drop Location',
                                                  style: const TextStyle(
                                                    color: Color(0xff00970F),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 80), // Space for the button
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 45,
            child: AppButton(
              padding: const EdgeInsets.symmetric(vertical: 35),
              onPressed: () {
                Get.to(() => const RefuelView(), binding: RefuelBinding());
              },
              title: 'Add New Refuel Detail',
            ),
          ),
        ],
      ),
    );
  }
}
