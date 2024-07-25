import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/utils/text_style.dart';
import 'package:flying_horse/app/widgets/trip_detail_row.dart';
import 'package:get/get.dart';
import '../controllers/refuel_card_controller.dart';

class RefuelCardView extends GetView<RefuelCardController> {
  const RefuelCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text('Refuel'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final tripDetails = controller.tripDetails;
          final refuelings = tripDetails['refuelings'] ?? [];

          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Trip Detail",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                        ),
                        Text(
                          tripDetails['truck_name'] ?? '',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: const Image(
                        image: AssetImage('assets/images/horse_black.png'),
                        height: 100,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TripDetailRow(
                        leftText: "Trip Number",
                        rightText: tripDetails['trip_number'] ?? '',
                        spaceHeight: 15.0,
                      ),
                      TripDetailRow(
                        leftText: "Truck Number",
                        rightText: tripDetails['truck_number'] ?? '',
                        spaceHeight: 15.0,
                      ),
                      TripDetailRow(
                        leftText: "Fuel Type",
                        rightText: "Diesel",
                        spaceHeight: 15.0,
                      ),
                      ...refuelings.asMap().entries.map<Widget>((entry) {
                        int index = entry.key;
                        var refuel = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                "${_getFillingStationLabel(index)} Filling Station",
                                style: AppTextStyle.semiBoldStyle(
                                    color: Color(0xff676767), fontSize: 16),
                              ),
                            ),
                            TripDetailRow(
                              leftText: "Odometer Reading",
                              rightText: refuel['odometer_reading'] ?? '',
                              showDottedLine: false,
                              spaceHeight: 10.0,
                            ),
                            TripDetailRow(
                              leftText: "Quantity filled at ABC",
                              rightText: "${refuel['fuel_quantity']} ${refuel['fuel_quantity_unit']}",
                              showDottedLine: false,
                              spaceHeight: 10.0,
                            ),
                            TripDetailRow(
                              leftText: "Driver Name",
                              rightText: refuel['user_name'] ?? '',
                              showDottedLine: false,
                              spaceHeight: 10.0,
                            ),
                            TripDetailRow(
                              leftText: "Amount Paid",
                              rightText: "\$${refuel['amount_paid']}",
                              showDottedLine: false,
                              spaceHeight: 10.0,
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                "Fuel Pump Location",
                                style: AppTextStyle.regularStyle(
                                    color: Color(0xff676767), fontSize: 15),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 24.0,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    refuel['fuel_station_address'] ?? '',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            const DottedLine(),
                          ],
                        );
                      }).toList(),
                      TripDetailRow(
                        leftText: "Card Detail",
                        rightText: tripDetails['card_number'] ?? '',
                        spaceHeight: 15.0,
                      ),
                      TripDetailRow(
                        leftText: "Total Fuel Filled",
                        rightText:
                            '${tripDetails['total_fuel_in_liters'].toString()} liters',
                        spaceHeight: 15.0,
                      ),
                      TripDetailRow(
                        leftText: "Total Amount Paid",
                        rightText:
                            '\$${tripDetails['total_amount_paid'].toString()}',
                        spaceHeight: 15.0,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildIconButton(Icons.edit, onPressed: () {}),
                          _buildIconButton(Icons.print, onPressed: () {}),
                          _buildIconButton(Icons.download, onPressed: () {}),
                          _buildCloseButton(onPressed: () {
                            Get.back();
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  String _getFillingStationLabel(int index) {
    switch (index) {
      case 0:
        return "First";
      case 1:
        return "Second";
      case 2:
        return "Third";
      case 3:
        return "Fourth";
      case 4:
        return "Fifth";
      default:
        return "${index + 1}th";
    }
  }

  Widget _buildIconButton(IconData icon, {required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: Colors.white,
        iconSize: 24,
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(),
        splashRadius: 24,
      ),
    );
  }

  Widget _buildCloseButton({required VoidCallback onPressed}) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          'Close',
          style: AppTextStyle.regularStyle(
            color: Color(0xffffffff),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
