import 'dart:convert';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/modules/refuel/models/country.dart';
import 'package:flying_horse/app/utils/text_style.dart';
import 'package:flying_horse/app/widgets/app_button.dart';
import 'package:flying_horse/app/widgets/common_text_input.dart';
import 'package:flying_horse/app/widgets/trip_detail_row.dart';
import 'package:get/get.dart';
import '../controllers/refuel_card_controller.dart';
import 'package:intl/intl.dart';

class RefuelCardView extends GetView<RefuelCardController> {
  const RefuelCardView({Key? key}) : super(key: key);

  String convertUtcToLocal(String utcDate) {
    DateTime utcDateTime = DateTime.parse(utcDate).toUtc(); // Parse as UTC
    DateTime localDateTime = utcDateTime.toLocal(); // Convert to local time
    String formattedDate = DateFormat('dd MMM yyyy, hh:mm a')
        .format(localDateTime); // Format to desired output
    return formattedDate;
  }

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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CupertinoActivityIndicator(
            color: AppColors.primary,
          ));
        } else {
          final tripDetails = controller.tripDetails;
          final refuelings = tripDetails['refuelings'] ?? [];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Trip Details',
                                    style: AppTextStyle.mediumStyle(
                                      fontSize: 24,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    tripDetails['truck_name'] ?? '',
                                    style: AppTextStyle.mediumStyle(
                                      fontSize: 18,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.symmetric(horizontal: 15),
                              //   child: Text(

                              //     style: TextStyle(
                              //         fontSize: 18,
                              //         fontWeight: FontWeight.w600,
                              //         color: Colors.black),
                              //   ),
                              // ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: const Image(
                              image:
                                  AssetImage('assets/images/horse_black.png'),
                              height: 100,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                              leftText: "Card Detail",
                              rightText: tripDetails['card_number'] ?? '',
                              spaceHeight: 15.0,
                            ),
                            ...refuelings.asMap().entries.map<Widget>((entry) {
                              int index = entry.key;
                              var refuel = entry.value;

                              String fuelStationAddressString =
                                  refuel['fuel_station_address'] ?? '';

                              Map<String, dynamic> fuelStationAddress = {};
                              if (fuelStationAddressString.isNotEmpty) {
                                try {
                                  fuelStationAddress =
                                      jsonDecode(fuelStationAddressString);
                                } catch (e) {
                                  print(
                                      'Error decoding fuel station address: $e');
                                }
                              }

                              String address = '';
                              if (fuelStationAddress.isNotEmpty) {
                                address = '${fuelStationAddress['site_name']}, '
                                    '${fuelStationAddress['city']}, '
                                    '${fuelStationAddress['state']}, '
                                    '${fuelStationAddress['country']}';
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2),
                                        child: Text(
                                          "${_getFillingStationLabel(index)} Filling Station",
                                          style: AppTextStyle.semiBoldStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Obx(() => IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: controller
                                                    .isEditable.value
                                                ? () {
                                                    showDeleteConfirmationDialog(
                                                        context, refuel['id']);
                                                  }
                                                : null, // Disable the button if not editable
                                          )),
                                    ],
                                  ),
                                  // Padding(
                                  //   padding: EdgeInsets.symmetric(vertical: 5),
                                  //   child: Text(
                                  //     "Fuel Pump Location",
                                  //     style: AppTextStyle.regularStyle(
                                  //         color: Color(0xff676767),
                                  //         fontSize: 15),
                                  //   ),
                                  // ),
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
                                          address,
                                          style: TextStyle(
                                              color: Color(0xff333333),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TripDetailRow(
                                    leftText: "Date",
                                    rightText: refuel['created_at'] != null
                                        ? convertUtcToLocal(
                                            refuel['created_at'])
                                        : 'N/A',
                                    showDottedLine: false,
                                    spaceHeight: 10.0,
                                  ),
                                  TripDetailRow(
                                    leftText: "Quantity filled",
                                    rightText:
                                        "${refuel['fuel_quantity']} ${refuel['fuel_quantity_unit'].toString().substring(0, 1).toUpperCase()}${refuel['fuel_quantity_unit'].toString().substring(1)}",
                                    showDottedLine: false,
                                    spaceHeight: 10.0,
                                  ),
                                  TripDetailRow(
                                    leftText: "Fuel Type",
                                    rightText: (refuel['fuel_type'] ?? 'Diesel')
                                            .toString()
                                            .substring(0, 1)
                                            .toUpperCase() +
                                        (refuel['fuel_type'] ?? 'Diesel')
                                            .toString()
                                            .substring(1),
                                    showDottedLine: false,
                                    spaceHeight: 10.0,
                                  ),
                                  TripDetailRow(
                                    leftText: "Filled In",
                                    rightText: (refuel['fuel_filled_to'] ??
                                                'Truck')
                                            .toString()
                                            .substring(0, 1)
                                            .toUpperCase() +
                                        (refuel['fuel_filled_to'] ?? 'Truck')
                                            .toString()
                                            .substring(1),
                                    showDottedLine: false,
                                    spaceHeight: 10.0,
                                  ),
                                  TripDetailRow(
                                    leftText: "Odometer Reading",
                                    rightText:
                                        "${refuel['odometer_reading']} ${refuel['odometer_reading_unit'].toString().substring(0, 1).toUpperCase()}${refuel['odometer_reading_unit'].toString().substring(1)}",
                                    showDottedLine: false,
                                    spaceHeight: 10.0,
                                  ),

                                  TripDetailRow(
                                    leftText: "Driver Name",
                                    rightText:
                                        "${refuel['user_name'].toString().substring(0, 1).toUpperCase()}${refuel['user_name'].toString().substring(1)}",
                                    showDottedLine: false,
                                    spaceHeight: 10.0,
                                  ),

                                  TripDetailRow(
                                    leftText: "Receipt Number",
                                    rightText: refuel['receipt_number'] != null
                                        ? "${refuel['receipt_number']}"
                                        : "N/A",
                                    showDottedLine: false,
                                    spaceHeight: 10.0,
                                  ),
                                  TripDetailRow(
                                    leftText: refuel['fuel_type'] == "def"
                                        ? "Price Per Litre"
                                        : "Amount Paid",
                                    rightText: refuel['fuel_type'] == "def"
                                        ? (refuel['price_per_liter'] != null
                                            ? "\$${refuel['price_per_liter']}"
                                            : "N/A")
                                        : (refuel['amount_paid'] != null
                                            ? "\$${refuel['amount_paid']}"
                                            : "N/A"),
                                    showDottedLine: false,
                                    spaceHeight: 10.0,
                                  ),

                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  const DottedLine(),
                                ],
                              );
                            }).toList(),
                            TripDetailRow(
                              leftText: "Total Diesel Filled",
                              rightText:
                                  '${tripDetails['total_fuel_in_liters_diesel'].toString()} Liters',
                              spaceHeight: 15.0,
                            ),
                            TripDetailRow(
                              leftText: "Total Def Filled",
                              rightText:
                                  '${tripDetails['total_fuel_in_liters_def'].toString()} Liters',
                              spaceHeight: 15.0,
                            ),
                            TripDetailRow(
                              leftText: "Total Amount Paid",
                              rightText:
                                  '\$${tripDetails['total_amount_paid'].toString()}',
                              spaceHeight: 15.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(() {
                      final refuelCardController =
                          Get.find<RefuelCardController>();
                      return _buildIconButton(
                        Icons.edit,
                        onPressed: refuelCardController.isEditable.value
                            ? () {
                                showEditModal(context, refuelings, controller);
                              }
                            : null,
                        enabled: refuelCardController.isEditable.value,
                      );
                    }),
                    _buildCloseButton(onPressed: () {
                      Get.back();
                    }),
                  ],
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  void showEditModal(
      BuildContext context, List refuelings, RefuelCardController controller) {
    String? selectedStation = refuelings.isNotEmpty ? '0' : null;
    var selectedRefuel = refuelings.isNotEmpty ? refuelings[0] : null;
    TextEditingController odometerController = TextEditingController();
    TextEditingController fuelQuantityController = TextEditingController();
    TextEditingController amountPaidController = TextEditingController();
    TextEditingController driverNameController = TextEditingController();
    TextEditingController receiptNumberController = TextEditingController();
    TextEditingController pricePerLitreController = TextEditingController();

    String odometerReadingUnit = 'KM';
    String fuelQuantityUnit = 'liters';

    // Initialize the controllers with the selectedRefuel values if not null
    if (selectedRefuel != null) {
      var address = jsonDecode(selectedRefuel['fuel_station_address']);
      controller.siteNameController.text = address['site_name'] ?? '';
      controller.countryController.text = address['country'] ?? '';
      controller.stateController.text = address['state'] ?? '';
      controller.cityController.text = address['city'] ?? '';

      odometerController.text =
          selectedRefuel['odometer_reading']?.toString() ?? '';
      fuelQuantityController.text =
          double.parse(selectedRefuel['fuel_quantity']?.toString() ?? '0.0')
              .toStringAsFixed(2);
      amountPaidController.text =
          selectedRefuel['amount_paid']?.toString() ?? '';
      driverNameController.text = selectedRefuel['user_name'] ?? '';
      receiptNumberController.text = selectedRefuel['receipt_number'] ?? '';

      odometerReadingUnit = selectedRefuel['odometer_reading_unit'] ?? 'KM';
      fuelQuantityUnit = selectedRefuel['fuel_quantity_unit'] ?? 'liters';
      pricePerLitreController.text =
          selectedRefuel['price_per_liter']?.toString() ?? '';

      controller.selectedFuelType.value =
          selectedRefuel['fuel_type'] ?? 'diesel';
      controller.selectedFuelFilledTo.value =
          selectedRefuel['fuel_filled_to'] ?? 'truck';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              backgroundColor: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.edit,
                          color: AppColors.primary,
                          size: 35.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Edit Trip Details',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    DropdownButton<String>(
                      dropdownColor: Colors.grey[200],
                      hint: Text(
                        selectedStation != null
                            ? "Selected: ${_getFillingStationLabel(int.parse(selectedStation!))}"
                            : "Select Filling Station",
                      ),
                      value: selectedStation,
                      isExpanded: true,
                      items: refuelings.asMap().entries.map((entry) {
                        int index = entry.key;
                        var refuel = entry.value;
                        return DropdownMenuItem<String>(
                          value: index.toString(),
                          child: Text(
                            "${_getFillingStationLabel(index)} Filling Station",
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStation = value;
                          selectedRefuel = refuelings[int.parse(value!)];
                          var address = jsonDecode(
                              selectedRefuel['fuel_station_address']);
                          controller.siteNameController.text =
                              address['site_name'] ?? '';
                          controller.countryController.text =
                              address['country'] ?? '';
                          controller.stateController.text =
                              address['state'] ?? '';
                          controller.cityController.text =
                              address['city'] ?? '';
                          odometerController.text =
                              selectedRefuel['odometer_reading']?.toString() ??
                                  '';
                          fuelQuantityController.text = double.parse(
                                  selectedRefuel['fuel_quantity']?.toString() ??
                                      '0.0')
                              .toStringAsFixed(2);
                          amountPaidController.text =
                              selectedRefuel['amount_paid']?.toString() ?? '';
                          driverNameController.text =
                              selectedRefuel['user_name'] ?? '';
                          receiptNumberController.text =
                              selectedRefuel['receipt_number'] ?? '';
                          pricePerLitreController.text =
                              selectedRefuel['price_per_liter']?.toString() ??
                                  '';

                          odometerReadingUnit =
                              selectedRefuel['odometer_reading_unit'] ?? 'KM';
                          fuelQuantityUnit =
                              selectedRefuel['fuel_quantity_unit'] ?? 'liters';

                          controller.selectedFuelType.value =
                              selectedRefuel['fuel_type'] ?? 'diesel';
                          controller.selectedFuelFilledTo.value =
                              selectedRefuel['fuel_filled_to'] ?? 'truck';
                        });
                      },
                    ),
                    if (selectedRefuel != null) ...[
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              CommonTextInput(
                                labelText: 'Driver Name',
                                hintText: 'Enter Driver Name',
                                controller: driverNameController,
                                readOnly: true,
                                height: 60,
                              ),
                              SizedBox(height: 10),
                              CommonTextInput(
                                labelText: 'Country',
                                hintText: 'Select Country',
                                controller: controller.countryController,
                                readOnly: true,
                                height: 60,
                              ),
                              const SizedBox(height: 10),
                              CommonTextInput(
                                labelText: 'State',
                                hintText: 'Select State',
                                controller: controller.stateController,
                                readOnly: true,
                                height: 60,
                              ),
                              const SizedBox(height: 10),
                              CommonTextInput(
                                labelText: 'City',
                                hintText: 'Select City',
                                controller: controller.cityController,
                                readOnly: true,
                                height: 60,
                              ),
                              CommonTextInput(
                                labelText: 'Site Name',
                                hintText: '',
                                controller: controller.siteNameController,
                                readOnly: true,
                                height: 60,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 11),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Filled In',
                                    style: AppTextStyle.mediumStyle(
                                      fontSize: 15,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ),
                              Obx(() => Container(
                                    height: 50,
                                    width: double.infinity,
                                    child: SegmentedButton<String>(
                                      showSelectedIcon: false,
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.selected)) {
                                              return AppColors.primary;
                                            }
                                            return Color(0xFFEEEEEE);
                                          },
                                        ),
                                        foregroundColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.selected)) {
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
                                            style: AppTextStyle.mediumStyle(
                                                fontSize: 16),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        ButtonSegment<String>(
                                          value: 'reefer',
                                          label: Text(
                                            'Reefer',
                                            style: AppTextStyle.mediumStyle(
                                                fontSize: 16),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                      selected: <String>{
                                        controller.selectedFuelFilledTo.value
                                      },
                                      onSelectionChanged:
                                          (Set<String> newSelection) {
                                        if (newSelection.isNotEmpty) {
                                          controller.selectedFuelFilledTo(
                                              newSelection.first);
                                        }
                                      },
                                    ),
                                  )),
                              const SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 11),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Fuel Type',
                                    style: AppTextStyle.mediumStyle(
                                      fontSize: 15,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ),
                              Obx(() => Container(
                                    height: 50,
                                    width: double.infinity,
                                    child: SegmentedButton<String>(
                                      showSelectedIcon: false,
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.selected)) {
                                              return AppColors.primary;
                                            }
                                            return Color(0xFFEEEEEE);
                                          },
                                        ),
                                        foregroundColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.selected)) {
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
                                            style: AppTextStyle.mediumStyle(
                                                fontSize: 16),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        ButtonSegment<String>(
                                          value: 'def',
                                          label: Text(
                                            'DEF',
                                            style: AppTextStyle.mediumStyle(
                                                fontSize: 16),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                      selected: <String>{
                                        controller.selectedFuelType.value
                                      },
                                      onSelectionChanged:
                                          (Set<String> newSelection) {
                                        if (newSelection.isNotEmpty) {
                                          controller.setSelectedFuelType(
                                              newSelection.first);
                                        }
                                      },
                                    ),
                                  )),

                              const SizedBox(height: 10),
                               Obx(() => controller.selectedFuelType.value ==
                                      'def'
                                  ? Column(
                                      children: [
                                        CommonTextInput(
                                          labelText: 'Price per Liter',
                                          hintText: 'Enter price per liter',
                                          controller: pricePerLitreController,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          height: 60,
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    )
                                  : SizedBox.shrink()),
                              SizedBox(height: 10),
                                  
                              
                              CommonTextInput(
                                labelText: 'Odometer Reading',
                                hintText: 'Enter Odometer Reading',
                                controller: odometerController,
                                showSegmentedTabs: true,
                                segments: ['KM', 'Miles'],
                                selectedSegment: odometerReadingUnit,
                                onSegmentSelected: (value) {
                                  setState(() {
                                    odometerReadingUnit = value;
                                  });
                                },
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                height: 60,
                              ),
                              SizedBox(height: 10),
                              CommonTextInput(
                                labelText: 'Fuel Quantity',
                                hintText: 'Enter Fuel Quantity',
                                controller: fuelQuantityController,
                                showSegmentedTabs: true,
                                segments: ['liters', 'gallon'],
                                selectedSegment: fuelQuantityUnit,
                                onSegmentSelected: (value) {
                                  setState(() {
                                    fuelQuantityUnit = value;
                                  });
                                },
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                height: 60,
                              ),
                              SizedBox(height: 10),
                              CommonTextInput(
                                labelText: 'Receipt Number',
                                hintText: 'Enter Receipt Number',
                                controller: receiptNumberController,
                                keyboardType: TextInputType.text,
                                height: 60,
                              ),
                              SizedBox(height: 10),
                             
                              Obx(() => controller.selectedFuelType.value !=
                                      'def'
                                  ? Column(
                                      children: [
                                        CommonTextInput(
                                          labelText: 'Amount Paid',
                                          hintText: 'Enter Amount Paid',
                                          controller: amountPaidController,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          height: 60,
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    )
                                  : SizedBox.shrink()),
                              SizedBox(height: 20),
                              TextButton(
                                child: Text('Save'),
                                onPressed: () async {
                                  String createdAt =
                                      DateFormat("yyyy-MM-ddTHH:mm:ss'Z'")
                                          .format(DateTime.now().toUtc());

                                  // Prepare the updated data map
                                  Map<String, dynamic> updatedData = {
                                    "id": selectedRefuel['id'],
                                    'fuel_type':
                                        controller.selectedFuelType.value,
                                    'fuel_filled_to':
                                        controller.selectedFuelFilledTo.value,
                                    "fuel_quantity":
                                        fuelQuantityController.text,
                                    "fuel_quantity_unit": fuelQuantityUnit,
                                    "amount_paid": amountPaidController.text,
                                    "receipt_number":
                                        receiptNumberController.text,
                                    "odometer_reading": odometerController.text,
                                    "odometer_reading_unit":
                                        odometerReadingUnit,
                                    "user_name": driverNameController.text,
                                    "created_at": createdAt,
                                    "price_per_liter":
                                        controller.selectedFuelType.value ==
                                                'def'
                                            ? pricePerLitreController.text
                                            : '0.0',
                                    "fuel_station_address": jsonEncode(
                                      {
                                        "country":
                                            controller.selectedCountry.value,
                                        "state": controller
                                            .selectedProvince.value.name,
                                        "city":
                                            controller.selectedCity.value.name,
                                        "site_name":
                                            controller.siteNameController.text,
                                      },
                                    ),
                                  };

                                  await controller.updateFuelDetail(
                                    selectedRefuel['id'],
                                    updatedData,
                                  );
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildIconButton(IconData icon,
      {required void Function()? onPressed, required bool enabled}) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Container(
        width: 160,
        height: 50,
        decoration: BoxDecoration(
          color: enabled ? AppColors.primary : Colors.grey,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Edit',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton({required void Function()? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 160,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            'Close',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  String _getFillingStationLabel(int index) {
    int number = index + 1;
    if (number % 100 >= 11 && number % 100 <= 13) {
      return "${number}th";
    } else if (number % 10 == 1) {
      return "${number}st";
    } else if (number % 10 == 2) {
      return "${number}nd";
    } else if (number % 10 == 3) {
      return "${number}rd";
    } else {
      return "${number}th";
    }
  }

  void showDeleteConfirmationDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 80.0, // Set the diameter of the circle
                  height: 80.0, // Same as width to make it a perfect circle
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1), // Full opacity
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.delete,
                      color: AppColors.primary, // Set icon color for contrast
                      size: 45.0, // Adjust the size of the icon
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Confirm Deletion',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Are you sure you want to delete this fuel detail?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Get.back();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    TextButton(
                      child: Text('Delete'),
                      onPressed: () {
                        controller.deleteFuelDetail(id);
                        Get.back();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
