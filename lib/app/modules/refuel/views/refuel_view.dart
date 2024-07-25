import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/widgets/app_button.dart';
import 'package:flying_horse/app/widgets/common_text_input.dart';
import 'package:get/get.dart';
import '../controllers/refuel_controller.dart';

class RefuelView extends GetView<RefuelController> {
  const RefuelView({Key? key}) : super(key: key);

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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fuel Type',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Obx(() => Container(
                      width: double.infinity,
                      child: SegmentedButton<String>(
                        showSelectedIcon: false, // Hide the tick icon
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return AppColors.primary;
                              }
                              return Color(0xFFEEEEEE);
                              return null;
                            },
                          ),
                          foregroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.white;
                              }
                              return AppColors.black;
                            },
                          ),
                        ),
                        segments: const <ButtonSegment<String>>[
                          ButtonSegment<String>(
                            value: 'Diesel',
                            label: Text('Diesel'),
                          ),
                          ButtonSegment<String>(
                            value: 'DEF',
                            label: Text('DEF'),
                          ),
                        ],
                        selected: <String>{controller.selectedFuelType.value},
                        onSelectionChanged: (Set<String> newSelection) {
                          if (newSelection.isNotEmpty) {
                            controller.setSelectedFuelType(newSelection.first);
                          }
                        },
                      ),
                    )),
                const SizedBox(height: 5),
                CommonTextInput(
                  labelText: 'Truck number',
                  hintText: 'ONTARIO 8AHM 202',
                  onChanged: (value) => controller.truckNumber.value = value,
                ),
                const SizedBox(height: 10),
                CommonTextInput(
                  labelText: 'Odometer Reading',
                  hintText: 'Enter odometer reading',
                  showSegmentedTabs: true,
                  segments: ['KM', 'Miles'],
                  onChanged: (value) => controller.odometerReading.value =
                      double.tryParse(value) ?? 0.0,
                  onSegmentChanged: (index) => controller
                      .odometerReadingUnit.value = ['KM', 'Miles'][index],
                ),
                const SizedBox(height: 10),
                CommonTextInput(
                  labelText: 'Fuel Quantity',
                  hintText: 'Enter fuel quantity',
                  showSegmentedTabs: true,
                  segments: ['Liter', 'Gallon'],
                  onChanged: (value) => controller.fuelQuantity.value =
                      double.tryParse(value) ?? 0.0,
                  onSegmentChanged: (index) => controller
                      .fuelQuantityUnit.value = ['Liter', 'Gallon'][index],
                ),
                const SizedBox(height: 10),
                CommonTextInput(
                  labelText: 'Amount Paid',
                  hintText: 'Enter amount here',
                  onChanged: (value) => controller.amountPaid.value =
                      double.tryParse(value) ?? 0.0,
                ),
                const SizedBox(height: 10),
                CommonTextInput(
                  labelText: 'Trip Number',
                  hintText: 'Enter trip number',
                  onChanged: (value) => controller.tripNumber.value = value,
                ),
                const SizedBox(height: 10),
                CommonTextInput(
                  labelText: 'Card Detail',
                  hintText: 'Enter card detail',
                  onChanged: (value) => controller.cardDetail.value = value,
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(
              () => AppButton(
                title: 'Submit',
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.saveFuelDetails(),
                buttonWidth: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
