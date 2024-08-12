import 'dart:convert';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/utils/text_style.dart';
import 'package:flying_horse/app/widgets/common_text_input.dart';
import 'package:flying_horse/app/widgets/trip_detail_row.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/refuel_card_controller.dart';
import 'package:intl/intl.dart';

class RefuelCardView extends GetView<RefuelCardController> {
  const RefuelCardView({Key? key}) : super(key: key);

  String convertUtcToLocal(String utcDate) {
    DateTime utcDateTime = DateTime.parse(utcDate).toUtc();

    DateTime localDateTime = utcDateTime.toLocal();

    String formattedDate =
        DateFormat('dd MMM yyyy, hh:mm a').format(localDateTime);

    return formattedDate;
  }

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
                                child: Text(
                                  "Trip Detail",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  tripDetails['truck_name'] ?? '',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ),
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
                                    leftText: "Odometer Reading",
                                    rightText:
                                        "${refuel['odometer_reading']} ${refuel['odometer_reading_unit'].toString().substring(0, 1).toUpperCase()}${refuel['odometer_reading_unit'].toString().substring(1)}",
                                    showDottedLine: false,
                                    spaceHeight: 10.0,
                                  ),
                                  TripDetailRow(
                                    leftText: "Quantity filled at GS",
                                    rightText:
                                        "${refuel['fuel_quantity']} ${refuel['fuel_quantity_unit'].toString().substring(0, 1).toUpperCase()}${refuel['fuel_quantity_unit'].toString().substring(1)}",
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
                                    leftText: "Amount Paid",
                                    rightText: refuel['amount_paid'] != null
                                        ? "\$${refuel['amount_paid']}"
                                        : "N/A",
                                    showDottedLine: false,
                                    spaceHeight: 10.0,
                                  ),
                                  TripDetailRow(
                                    leftText: "Recipet Number",
                                    rightText: "${refuel['receipt_number']}",
                                    showDottedLine: false,
                                    spaceHeight: 10.0,
                                  ),

                                  TripDetailRow(
                                    leftText: "Filled at",
                                    rightText:
                                        convertUtcToLocal(refuel['created_at']),
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
                              leftText: "Card Detail",
                              rightText: tripDetails['card_number'] ?? '',
                              spaceHeight: 15.0,
                            ),
                            TripDetailRow(
                              leftText: "Total Fuel Filled",
                              rightText:
                                  '${tripDetails['total_fuel_in_liters'].toString()} Liters',
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
    String? selectedStation;
    var selectedRefuel = refuelings.isNotEmpty ? refuelings[0] : null;
    TextEditingController odometerController = TextEditingController();
    TextEditingController fuelQuantityController = TextEditingController();
    TextEditingController amountPaidController = TextEditingController();
    TextEditingController driverNameController = TextEditingController();
    TextEditingController receiptNumberController =
        TextEditingController(); // New controller

    String odometerReadingUnit = 'KM';
    String fuelQuantityUnit = 'liters';

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
      receiptNumberController.text = selectedRefuel['receipt_number'] ??
          ''; // Set receipt number if available

      odometerReadingUnit = selectedRefuel['odometer_reading_unit'] ?? 'KM';
      fuelQuantityUnit = selectedRefuel['fuel_quantity_unit'] ?? 'liters';
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

                          odometerReadingUnit =
                              selectedRefuel['odometer_reading_unit'] ?? 'KM';
                          fuelQuantityUnit =
                              selectedRefuel['fuel_quantity_unit'] ?? 'liters';
                        });
                      },
                    ),
                    if (selectedRefuel != null) ...[
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
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
                              CommonTextInput(
                                labelText: 'Driver Name',
                                hintText: 'Enter Driver Name',
                                controller: driverNameController,
                                readOnly: true,
                              ),
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
                                keyboardType: TextInputType.number,
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
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: 10),
                              CommonTextInput(
                                labelText: 'Amount Paid',
                                hintText: 'Enter Amount Paid',
                                controller: amountPaidController,
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: 10),
                              CommonTextInput(
                                labelText: 'Receipt Number', // New field
                                hintText:
                                    'Enter Receipt Number', // Hint text for receipt number
                                controller: receiptNumberController,
                                keyboardType: TextInputType.text,
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        TextButton(
                          child: Text('Save'),
                          onPressed: () {
                            if (selectedRefuel != null) {
                              var updatedData = {
                                'id': selectedRefuel['id'],
                                'odometer_reading': odometerController.text,
                                'odometer_reading_unit': odometerReadingUnit,
                                'fuel_quantity': fuelQuantityController.text,
                                'fuel_quantity_unit': fuelQuantityUnit,
                                'amount_paid': amountPaidController.text,
                                'receipt_number': receiptNumberController
                                    .text, // Include receipt number in data
                                'fuel_station_address': jsonEncode({
                                  "country": controller.countryController.text,
                                  "state": controller.stateController.text,
                                  "city": controller.cityController.text,
                                  "site_name":
                                      controller.siteNameController.text,
                                }),
                                'user_name': driverNameController.text,
                              };
                              controller.updateFuelDetail(
                                  selectedRefuel['id'], updatedData);
                            }
                            Get.back();
                          },
                        ),
                      ],
                    ),
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
    switch (index) {
      case 0:
        return "First";
      case 1:
        return "Second";
      case 2:
        return "Third";
      default:
        return "${index + 1}th";
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
