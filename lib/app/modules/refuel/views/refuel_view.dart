import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/utils/text_style.dart';
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
                CommonTextInput(
                  labelText: 'Site Name',
                  hintText: 'ONTARIO 8AHM 202',
                  controller: controller.siteNameController,
                ),
                const SizedBox(height: 10),
                CommonTextInput(
                  labelText: 'Select Location',
                  hintText: 'Select Country',
                  isCountryPicker: true,
                  countryController: controller.countryController,
                  stateController: controller.stateController,
                  cityController: controller.cityController,
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 11),
                  child: Text(
                    'Fuel Type',
                    style: AppTextStyle.mediumStyle(
                      fontSize: 15,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
                Obx(() => Container(
                      height: 50,
                      width: double.infinity,
                      child: SegmentedButton<String>(
                        showSelectedIcon: false,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return AppColors.primary;
                              }
                              return Color(0xFFEEEEEE);
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
                        segments: <ButtonSegment<String>>[
                          ButtonSegment<String>(
                            value: 'diesel',
                            label: Text(
                              'Diesel',
                              style: AppTextStyle.mediumStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ButtonSegment<String>(
                            value: 'def',
                            label: Text(
                              'DEF',
                              style: AppTextStyle.mediumStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
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
                  controller:
                      TextEditingController(text: controller.truckNumber.value),
                  onChanged: (value) => controller.truckNumber.value = value,
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                CommonTextInput(
                  labelText: 'Odometer Reading',
                  hintText: 'Enter odometer reading',
                  showSegmentedTabs: true,
                  segments: ['KM', 'Miles'],
                  selectedSegment: controller.odometerReadingUnit.value,
                  onChanged: (value) => controller.odometerReading.value =
                      double.tryParse(value) ?? 0.0,
                  onSegmentSelected: (value) =>
                      controller.odometerReadingUnit.value = value,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                CommonTextInput(
                  labelText: 'Fuel Quantity',
                  hintText: 'Enter fuel quantity',
                  showSegmentedTabs: true,
                  segments: ['liters', 'gallon'],
                  selectedSegment: controller.fuelQuantityUnit.value,
                  onChanged: (value) => controller.fuelQuantity.value =
                      double.tryParse(value) ?? 0.0,
                  onSegmentSelected: (value) =>
                      controller.fuelQuantityUnit.value = value,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                CommonTextInput(
                  labelText: 'Amount Paid',
                  hintText: 'Enter amount here',
                  onChanged: (value) => controller.amountPaid.value =
                      double.tryParse(value) ?? 0.0,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                CommonTextInput(
                  labelText: 'Trip Number',
                  hintText: 'Enter trip number',
                  controller:
                      TextEditingController(text: controller.tripNumber.value),
                  onChanged: (value) => controller.tripNumber.value = value,
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                CommonTextInput(
                  labelText: 'Card Detail',
                  hintText: 'Enter card detail',
                  controller:
                      TextEditingController(text: controller.cardDetail.value),
                  onChanged: (value) => controller.cardDetail.value = value,
                  readOnly: true,
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AppButton(
              title: 'Submit',
              onPressed: () {
                controller.saveFuelDetails(context);
                
              },
              buttonWidth: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
