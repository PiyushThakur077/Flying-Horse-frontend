import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/api_provider.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RefuelController extends GetxController {
  late GoogleMapController mapController;
  final LatLng initialPosition = const LatLng(45.521563, -122.677433);

  var currentLocation = LatLng(0, 0).obs;
  var isLoading = true.obs;
  var selectedFuelType = 'Diesel'.obs;

  var truckNumber = ''.obs;
  var odometerReadingUnit = 'KM'.obs;
  var odometerReading = 0.0.obs;
  var fuelQuantityUnit = 'Liter'.obs;
  var fuelQuantity = 0.0.obs;
  var amountPaid = 0.0.obs;
  var tripNumber = ''.obs;
  var cardDetail = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void setSelectedFuelType(String value) {
    selectedFuelType.value = value;
  }

  Future<void> saveFuelDetails() async {
    isLoading.value = true;
    final map = {
      "trip_number": tripNumber.value,
      "fuel_type": selectedFuelType.value.toLowerCase(),
      "odometer_reading_unit": odometerReadingUnit.value,
      "odometer_reading": odometerReading.value,
      "fuel_quantity_unit": fuelQuantityUnit.value,
      "fuel_quantity": fuelQuantity.value,
      "amount_paid": amountPaid.value,
      "fuel_station_address":
          "Fairmat Hotel Macdonald, Edmonton AB T5J ON6, Canada",
    };
    try {
      await ApiProvider().saveFuelDetails(map);
      Get.snackbar("Success", "Fuel details saved successfully");
      Get.back(); // Navigate back to the previous screen
    } catch (e) {
      Get.snackbar("Error", "Failed to save fuel details");
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
    super.onClose();
  }
}
