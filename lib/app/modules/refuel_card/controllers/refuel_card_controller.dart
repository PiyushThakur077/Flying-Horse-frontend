import 'dart:convert';

import 'package:flying_horse/app/data/api_provider.dart';
import 'package:flying_horse/app/modules/refueling/controllers/refueling_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class RefuelCardController extends GetxController {
  var tripDetails = {}.obs;
  var isLoading = true.obs;
  var isEditable = true.obs;  
  var apiProvider = ApiProvider();

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

      // Update the editability based on status_name
      isEditable.value = tripDetails['status_name'] != 'cancelled';
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
      
      Get.find<RefuelingController>().fetchTrips();
    } catch (e) {
      print('Error deleting fuel detail: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateFuelDetail(int id, Map<String, dynamic> updatedData) async {
  isLoading.value = true;
  try {
    // Construct the address map correctly
    Map<String, dynamic> fuelStationAddress = {
      "country": countryController.text,
      "state": stateController.text,
      "city": cityController.text,
      "site_name": siteNameController.text,
    };

    // Convert the map to a JSON string using jsonEncode, which uses double quotes correctly
    updatedData['fuel_station_address'] = jsonEncode(fuelStationAddress);

    // Make the API call to update the fuel details
    await apiProvider.updateFuelDetails(id, updatedData);

    // Update the local refuelings list
    var updatedRefuelings = tripDetails['refuelings'] as List;
    int index = updatedRefuelings.indexWhere((refuel) => refuel['id'] == id);
    if (index != -1) {
      updatedRefuelings[index] = updatedData;
      tripDetails['refuelings'] = updatedRefuelings;
      tripDetails['total_amount_paid'] = _calculateTotalAmountPaid(updatedRefuelings);
      tripDetails['total_fuel_in_liters'] = _calculateTotalFuelInLiters(updatedRefuelings);
    }
    
    // Refresh the trips
    Get.find<RefuelingController>().fetchTrips();
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