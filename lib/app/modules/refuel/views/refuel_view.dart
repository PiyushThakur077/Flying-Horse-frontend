import 'package:flutter/cupertino.dart';
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

  String capitalize(String? text) {
    if (text == null || text.isEmpty) {
      return '';
    }
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

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
            child: Form(
              key: controller.formKey,
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
                    leftText: "Trip Number",
                    rightText: controller.tripNumber.value,
                    showDottedLine: false,
                    spaceHeight: 10.0,
                  ),
                  TripDetailRow(
                    leftText: "Truck number",
                    rightText: controller.truckNumber.value,
                    showDottedLine: false,
                    spaceHeight: 10.0,
                  ),
                Obx(
                    () {
                      // Check if trailer lists are not empty
                      if (controller.trailerNames.isEmpty ||
                          controller.trailerNumbers.isEmpty) {
                        return Center(
                          child: Text('No trailer details available'),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(controller.trailerNames.length,
                            (index) {
                          return Column(
                            children: [
                              TripDetailRow(
                                leftText: "Trailer name",
                                rightText: controller.trailerNames[index],
                                showDottedLine: false,
                                spaceHeight: 10.0,
                              ),
                              TripDetailRow(
                                leftText: "Trailer number",
                                rightText: controller.trailerNumbers[index],
                                showDottedLine: false,
                                spaceHeight: 10.0,
                              ),
                            ],
                          );
                        }),
                      );
                    },
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select Location',
                            style: AppTextStyle.semiBoldStyle(fontSize: 16)),
                        SizedBox(
                          height: 10,
                        ),
                        Obx(
                          () => Container(
                            width: double.infinity,
                            height: 85,
                            child: DropdownButtonFormField<String>(
                              value: controller.selectedCountry.value.isEmpty
                                  ? null
                                  : controller.selectedCountry.value,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFEEEEEE),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide.none,
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .red, // Red border for error state
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .red, // Red border for focused error state
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(15)
                              ),
                              onChanged: (String? newValue) {
                                controller.onCountrySelected(newValue);
                              },
                              items: [
                                DropdownMenuItem<String>(
                                  value: null,
                                  child: Center(
                                    child: Text(
                                      'Select Country',
                                      style: TextStyle(
                                        color: Colors
                                            .grey, // Optional: make the hint text lighter
                                      ),
                                    ),
                                  ),
                                ),
                                ...controller.countryIso2Map.keys
                                    .map<DropdownMenuItem<String>>(
                                  (String key) {
                                    return DropdownMenuItem<String>(
                                      value: key,
                                      child: Text(key),
                                    );
                                  },
                                ).toList(),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a country';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Obx(
                          () => Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 85,
                                child: DropdownButtonFormField<Province>(
                                  value:
                                      controller.selectedProvince.value.name ==
                                              null
                                          ? null
                                          : controller.selectedProvince.value,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFEEEEEE),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  onChanged: (Province? selectedProvince) {
                                    controller
                                        .onProvinceSelected(selectedProvince);
                                  },
                                  items: [
                                    DropdownMenuItem<Province>(
                                      value: null,
                                      child: Center(
                                        child: Text(
                                          'Select State',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ...controller.provinces
                                        .map<DropdownMenuItem<Province>>(
                                      (Province province) {
                                        return DropdownMenuItem<Province>(
                                          value: province,
                                          child: Text(province.name ?? ""),
                                        );
                                      },
                                    ).toList(),
                                  ],
                                  validator: (Province? value) {
                                    if (value == null ||
                                        value.name == null ||
                                        value.name!.isEmpty) {
                                      return 'Please select a state';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              if (controller.isProvinceLoading.value)
                                Positioned.fill(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CupertinoActivityIndicator(
                                          color: AppColors.primary,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Loading...',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Obx(() => Container(
                              width: double.infinity,
                              height: 85,
                              child: DropdownButtonFormField<Cities>(
                                value:
                                    controller.selectedCity.value.name == null
                                        ? null
                                        : controller.selectedCity.value,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFEEEEEE),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .red, // Red border when there's an error
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .red, // Red border when focused and there's an error
                                    ),
                                  ),
                                ),
                                onChanged: controller.onCitySelected,
                                items: [
                                  DropdownMenuItem<Cities>(
                                    value: null,
                                    child: Center(
                                      child: Text(
                                        'Select City',
                                        style: TextStyle(
                                          color: Colors
                                              .grey, // Optional: make the hint text lighter
                                        ),
                                      ),
                                    ),
                                  ),
                                  ...?controller.selectedProvince.value.cities
                                      ?.map<DropdownMenuItem<Cities>>(
                                          (Cities value) {
                                    return DropdownMenuItem<Cities>(
                                      value: value,
                                      child: Text(capitalize(value.name)),
                                    );
                                  }).toList(),
                                ],
                                // Adding validation
                                validator: (value) {
                                  if (value == null ||
                                      value.name == null ||
                                      value.name!.isEmpty) {
                                    return 'Please select a city';
                                  }
                                  return null;
                                },
                              ),
                            )),
                      ],
                    ),
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 11),
                    child: Text(
                      'Filled In',
                      style: AppTextStyle.mediumStyle(
                        fontSize: 15,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  Obx(() => Container(
                        height: 50, // Updated height
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
                              value: 'truck',
                              label: Text(
                                'Truck',
                                style: AppTextStyle.mediumStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ButtonSegment<String>(
                              value: 'reefer',
                              label: Text(
                                'Reefer',
                                style: AppTextStyle.mediumStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                          selected: <String>{
                            controller.selectedFuelFilledTo.value
                          },
                          onSelectionChanged: (Set<String> newSelection) {
                            if (newSelection.isNotEmpty) {
                              controller
                                  .selectedFuelFilledTo(newSelection.first);
                            }
                          },
                        ),
                      )),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      Obx(
                        () => Container(
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
                            selected: <String>{
                              controller.selectedFuelType.value
                            },
                            onSelectionChanged: (Set<String> newSelection) {
                              if (newSelection.isNotEmpty) {
                                controller
                                    .setSelectedFuelType(newSelection.first);
                                if (newSelection.first == 'def') {
                                  controller.amountPaid.value =
                                      0.0; // Reset amount paid when DEF is selected
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      Obx(
                        () => controller.selectedFuelType.value == 'def'
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: [
                                    CommonTextInput(
                                      labelText: 'Price per Liter',
                                      hintText: 'Enter price per liter',
                                      onChanged: (value) =>
                                          controller.pricePerLitre.value =
                                              double.tryParse(value) ?? 0.0,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      required: true,
                                      validator: (value) {
                                        double parsedValue =
                                            double.tryParse(value ?? '') ?? 0.0;
                                        return controller
                                            .validatePricePerLiter(parsedValue);
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),

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
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    required: true,
                    validator: (value) {
                      final parsedValue = double.tryParse(value ?? '');

                      if (parsedValue == null) {
                        return "Please enter a valid odometerReading";
                      }

                      return controller.validateOdometerReading(parsedValue);
                    },
                  ),
                  const SizedBox(height: 10),
                  CommonTextInput(
                    labelText: 'Fuel Quantity',
                    hintText: 'Enter fuel quantity',
                    showSegmentedTabs: true,
                    segments: ['Liters', 'Gallon'],
                    selectedSegment:
                        controller.fuelQuantityUnit.value == 'liters'
                            ? 'Liters'
                            : 'Gallon',
                    onChanged: (value) => controller.fuelQuantity.value =
                        double.tryParse(value) ?? 0.0,
                    onSegmentSelected: (value) {
                      controller.fuelQuantityUnit.value = value.toLowerCase();
                    },
                    required: true,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      final parsedValue = double.tryParse(value ?? '');

                      if (parsedValue == null) {
                        return "Please enter a valid fuel quantity";
                      }

                      return controller.validateFuelQuantity(parsedValue);
                    },
                  ),
                  const SizedBox(height: 10),
                  CommonTextInput(
                    labelText: 'Receipt Number',
                    hintText: 'Enter receipt number here',
                    onChanged: (value) =>
                        controller.receiptNumber.value = value,
                    required: true,
                    validator: (value) =>
                        controller.validateReceiptNumber(value ?? ''),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => controller.selectedFuelType.value != 'def'
                      ? Column(
                          children: [
                            CommonTextInput(
                              labelText: 'Amount Paid',
                              hintText: 'Enter amount here',
                              onChanged: (value) => controller.amountPaid
                                  .value = double.tryParse(value) ?? 0.0,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                            ),
                            const SizedBox(height: 10),
                          ],
                        )
                      : const SizedBox.shrink()),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(() => AppButton(
                  title: 'Submit',
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          if (controller.formKey.currentState!.validate()) {
                            controller.saveFuelDetails(context);
                          }
                        },
                  buttonWidth: double.infinity,
                  isLoading:
                      controller.isLoading.value, // Pass the loading state here
                )),
          ),
        ],
      ),
    );
  }
}
