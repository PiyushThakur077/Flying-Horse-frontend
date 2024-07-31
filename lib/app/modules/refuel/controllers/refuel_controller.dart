import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/api_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

class RefuelController extends GetxController {
  late GoogleMapController mapController;
  final LatLng initialPosition = const LatLng(45.521563, -122.677433);

  var currentLocation = LatLng(0, 0).obs;
  var isLoading = true.obs;
  var selectedFuelType = 'diesel'.obs;

  var truckNumber = ''.obs;
  var odometerReadingUnit = 'KM'.obs;
  var odometerReading = 0.0.obs;
  var fuelQuantityUnit = 'liters'.obs;
  var fuelQuantity = 0.0.obs;
  var amountPaid = 0.0.obs;
  var tripNumber = ''.obs;
  var cardDetail = ''.obs;

  // Define the controllers for the country, state, city, and site name
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController siteNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _prefillDetailsFromStorage();
  }

  void _prefillDetailsFromStorage() {
    final storage = GetStorage();
    truckNumber.value = storage.read<String>('truckNumber') ?? '';
    tripNumber.value = storage.read<String>('tripNumber') ?? '';
    cardDetail.value = storage.read<String>('cardNumber') ?? '';
  }

  void setSelectedFuelType(String value) {
    selectedFuelType.value = value;
  }

  bool validateFields() {
    if (truckNumber.value.isEmpty ||
        odometerReading.value <= 0 ||
        fuelQuantity.value <= 0 ||
        amountPaid.value <= 0 ||
        tripNumber.value.isEmpty ||
        cardDetail.value.isEmpty ||
        countryController.text.isEmpty ||
        stateController.text.isEmpty ||
        cityController.text.isEmpty ||
        siteNameController.text.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return false;
    }
    return true;
  }

  Future<void> saveFuelDetails(BuildContext context) async {
    if (!validateFields()) return;

    isLoading.value = true;
    final map = {
      "trip_number": tripNumber.value,
      "fuel_type": selectedFuelType.value.toLowerCase(),
      "odometer_reading_unit": odometerReadingUnit.value,
      "odometer_reading": odometerReading.value,
      "fuel_quantity_unit": fuelQuantityUnit.value,
      "fuel_quantity": fuelQuantity.value,
      "amount_paid": amountPaid.value,
      "fuel_station_address": jsonEncode({
        "country": countryController.text,
        "state": stateController.text,
        "city": cityController.text,
        "site_name": siteNameController.text,
      }),
    };
    try {
      var response = await ApiProvider().saveFuelDetails(map);

      if (response is String) {
        response = jsonDecode(response);
      }

      if (response is Map<String, dynamic> && response['success'] == true) {
        Get.snackbar("Success", "Fuel details saved successfully");

        // Clear all fields
        truckNumber.value = '';
        odometerReading.value = 0.0;
        fuelQuantity.value = 0.0;
        amountPaid.value = 0.0;
        tripNumber.value = '';
        cardDetail.value = '';
        countryController.clear();
        stateController.clear();
        cityController.clear();
        siteNameController.clear();

        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop(true); 
        });
      } else {
        Get.snackbar(
            "Error", response['message'] ?? "Failed to save fuel details");
      }
    } catch (e) {
      print("Failed to save fuel details: $e");
      Get.snackbar("Error", "Failed to save fuel details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    siteNameController.dispose();
    super.onClose();
  }
}
