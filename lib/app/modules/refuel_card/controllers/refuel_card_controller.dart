import 'dart:convert';

import 'package:flying_horse/app/data/api_provider.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Import this for TextEditingController

class RefuelCardController extends GetxController {
  var tripDetails = {}.obs;
  var isLoading = true.obs;
  var apiProvider = ApiProvider();

  // Define TextEditingControllers
  TextEditingController siteNameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments['id'];
    fetchTripDetails(int.parse(id));
  }

  @override
  void onClose() {
    // Dispose of controllers
    siteNameController.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    super.onClose();
  }

  void fetchTripDetails(int id) async {
    try {
      print('Fetching trip details for ID: $id');
      var details = await apiProvider.getTripId(id);
      print('Received trip details: $details');
      tripDetails.value = details;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteFuelDetail(int id) async {
    isLoading.value = true;
    try {
      await apiProvider.deleteFuelDetails(id);
      var updatedRefuelings = (tripDetails['refuelings'] as List)
          .where((refuel) => refuel['id'] != id)
          .toList();
      tripDetails['refuelings'] = updatedRefuelings;
      tripDetails['total_amount_paid'] = _calculateTotalAmountPaid(updatedRefuelings);
      tripDetails['total_fuel_in_liters'] = _calculateTotalFuelInLiters(updatedRefuelings);
    } catch (e) {
      print('Error deleting fuel detail: $e');
    } finally {
      isLoading.value = false;
    }
  }

 Future<void> updateFuelDetail(int id, Map<String, dynamic> updatedData) async {
  isLoading.value = true;
  try {
    updatedData['fuel_station_address'] = jsonEncode({
      "country": countryController.text,
      "state": stateController.text,
      "city": cityController.text,
      "site_name": siteNameController.text,
    });

    await apiProvider.updateFuelDetails(id, updatedData);
    var updatedRefuelings = tripDetails['refuelings'] as List;
    int index = updatedRefuelings.indexWhere((refuel) => refuel['id'] == id);
    if (index != -1) {
      updatedRefuelings[index] = updatedData;
      tripDetails['refuelings'] = updatedRefuelings;
      tripDetails['total_amount_paid'] = _calculateTotalAmountPaid(updatedRefuelings);
      tripDetails['total_fuel_in_liters'] = _calculateTotalFuelInLiters(updatedRefuelings);
    }
  } catch (e) {
    print('Error updating fuel detail: $e');
  } finally {
    isLoading.value = false;
  }
}

  double _calculateTotalAmountPaid(List refuelings) {
    double totalAmountPaid = 0.0;
    for (var refuel in refuelings) {
      totalAmountPaid += double.parse(refuel['amount_paid'] ?? '0');
    }
    return totalAmountPaid;
  }

  double _calculateTotalFuelInLiters(List refuelings) {
    double totalFuelInLiters = 0.0;
    for (var refuel in refuelings) {
      totalFuelInLiters += double.parse(refuel['fuel_quantity'] ?? '0');
    }
    return totalFuelInLiters;
  }
}
