import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/modules/refuel/models/country.dart';
import 'package:flying_horse/app/utils/text_style.dart';
import 'package:flying_horse/app/widgets/app_button.dart';
import 'package:flying_horse/app/widgets/common_text_input.dart';
import 'package:flying_horse/app/widgets/trip_detail_row.dart';
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
        title: const Text('Fuel'),
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
                // Autocomplete<String>(
                //   optionsBuilder: (TextEditingValue textEditingValue) async {
                //     if (textEditingValue.text.isEmpty) {
                //       return const Iterable<String>.empty();
                //     }
                //     return await controller
                //         .fetchSiteSuggestions(textEditingValue.text);
                //   },
                //   onSelected: (String selection) {
                //     controller.siteNameController.text = selection;
                //   },
                //   fieldViewBuilder: (BuildContext context,
                //       TextEditingController textEditingController,
                //       FocusNode focusNode,
                //       VoidCallback onFieldSubmitted) {
                //     return TextField(
                //       controller: controller.siteNameController,
                //       focusNode: focusNode,
                //       decoration: InputDecoration(
                //         filled: true,
                //         fillColor: const Color(0xFFEEEEEE),
                //         border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(25.0),
                //   borderSide: BorderSide.none,
                // ),
                // enabledBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(25.0),
                //   borderSide: BorderSide.none,
                // ),
                // focusedBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(25.0),
                //   borderSide: BorderSide.none,
                // ),
                //         labelText: 'Site Name',
                //         hintText: 'ONTARIO 8AHM 202',

                //       ),
                //       onChanged: (value) {
                //         textEditingController.text = value;
                //         controller.siteNameController.text = value;
                //       },
                //     );
                //   },
                // ),
                TripDetailRow(
                  leftText: "Truck number",
                  rightText: controller.truckNumber.value,
                  showDottedLine: false,
                  spaceHeight: 10.0,
                ),
                TripDetailRow(
                  leftText: "Trip Number",
                  rightText: controller.tripNumber.value,
                  showDottedLine: false,
                  spaceHeight: 10.0,
                ),
                TripDetailRow(
                  leftText: "Card Detail",
                  rightText: controller.cardDetail.value,
                  showDottedLine: true,
                  spaceHeight: 10.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    child: Column(children: [
                      Text('Select Location', style: AppTextStyle.semiBoldStyle(fontSize: 15)),
                      Obx(() => DropdownButton<String>(
              value: controller.selectedCountry.value.isEmpty
                  ? null
                  : controller.selectedCountry.value,
              onChanged: (String? newValue) {
                controller.onCountrySelected(newValue);
              },
              items: controller.countryIso2Map.keys
                  .map<DropdownMenuItem<String>>((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(key),
                );
              }).toList(),
            )),
                Obx(() => DropdownButton<Province>(
                      value: controller.selectedProvince.value.name == null
                          ? null
                          : controller.selectedProvince.value,
                      onChanged: controller.onProvinceSelected,
                      items: controller.provinces
                          .map<DropdownMenuItem<Province>>((Province value) {
                        return DropdownMenuItem<Province>(
                          value: value,
                          child: Text(value.name ?? ""),
                        );
                      }).toList(),
                    )),
                Obx(() => DropdownButton<Cities>(
                      value: controller.selectedCity.value.name == null
                          ? null
                          : controller.selectedCity.value,
                      onChanged: controller.onCitySelected,
                      items: (controller.selectedProvince.value.cities ?? [])
                          .map<DropdownMenuItem<Cities>>((Cities value) {
                        return DropdownMenuItem<Cities>(
                          value: value,
                          child: Text(value.name ?? ""),
                        );
                      }).toList(),
                    )),
                    ],),
                ),

                // CommonTextInput(
                //   labelText: 'Select Location',
                //   hintText: 'Select Country',
                //   isCountryPicker: true,
                //   countryController: controller.countryController,
                //   stateController: controller.stateController,
                //   cityController: controller.cityController,
                //   readOnly: true,
                // ),
                const SizedBox(height: 10),
                CommonTextInput(
                  labelText: 'Site Name',
                  hintText: '',
                  controller: controller.siteNameController,
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
                  labelText: 'Receipt Number',
                  hintText: 'Enter receipt number here',
                  onChanged: (value) => controller.receiptNumber.value = value,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CommonTextInput(
                  labelText: 'Amount Paid',
                  hintText: 'Enter amount here',
                  onChanged: (value) => controller.amountPaid.value =
                      double.tryParse(value) ?? 0.0,
                  keyboardType: TextInputType.number,
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
