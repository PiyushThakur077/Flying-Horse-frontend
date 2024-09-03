import 'dart:convert';
import 'package:flying_horse/app/data/api_provider.dart';
import 'package:flying_horse/app/modules/refuel/models/country.dart';
import 'package:flying_horse/app/modules/refueling/controllers/refueling_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class RefuelCardController extends GetxController {
  var tripDetails = {}.obs;
  var isLoading = true.obs;
  var isEditable = true.obs;
  var apiProvider = ApiProvider();
 var trailers = <Map<String, dynamic>>[].obs; 
  var provinces = <Province>[].obs;
  var selectedProvince = Province().obs;
  var selectedCity = Cities().obs;
  var selectedCountry = ''.obs;
  var selectedFuelType = ''.obs;
  var selectedFuelFilledTo = ''.obs;
  RxString odometerReadingUnit = 'KM'.obs;
  RxString fuelQuantityUnit = 'liters'.obs;


  TextEditingController siteNameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  final Map<String, String> countryIso2Map = {
    'Canada': 'CA',
    'United States': 'US',
    'Mexico': 'MX',
  };

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments['id'];
    fetchTripDetails(int.parse(id));
    selectedFuelType.value = _getDefaultFuelType();
  }

  @override
  void onClose() {
    siteNameController.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    super.onClose();
  }

  void setSelectedFuelType(String value) {
    print('Setting selected fuel type to: $value');
    selectedFuelType.value = value;
  }

  void setSelectedFuelFilledTo(String value) {
    selectedFuelFilledTo.value = value;
  }

  String _getDefaultFuelType() {
    return 'diesel';
  }

  Future<void> fetchTripDetails(int id) async {
    try {
      print('Fetching trip details for ID: $id');
      var details = await apiProvider.getTripId(id);
      print('Received trip details: $details');
      tripDetails.value = details;

      // Fetch trailer details if available
      if (details['trailers'] != null) {
        trailers.value = List<Map<String, dynamic>>.from(details['trailers']);
      } else {
        trailers.clear();
      }

      // Update the editability based on status_name
      isEditable.value = tripDetails['status_name'] != 'cancelled';
    } catch (e) {
      print('Error fetching trip details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProvinces(String iso2CountryCode) async {
    if (iso2CountryCode.isEmpty) return;

    try {
      final response = await apiProvider.getProvincesByCountry(iso2CountryCode);
      if (response is List<dynamic>) {
        final fetchedProvinces =
            response.map((item) => Province.fromJson(item)).toList();
        provinces.value = fetchedProvinces;
        if (fetchedProvinces.isNotEmpty) {
          selectedProvince.value = fetchedProvinces.first;
        }
      } else {
        Get.snackbar("Error", "Failed to fetch provinces.");
      }
    } catch (e) {
      print("Error fetching provinces: $e");
      Get.snackbar("Error", "Failed to fetch provinces: $e");
    }
  }

  void onCountrySelected(String? country) {
    if (country != null) {
      selectedProvince.value = Province();
      selectedCity.value = Cities();
      selectedCountry.value = country;
      fetchProvinces(countryIso2Map[country]!);
    }
  }

  void onProvinceSelected(Province? value) {
    if (value != null) {
      selectedProvince.value = value;
      selectedCity.value = Cities();
    }
  }

  void onCitySelected(Cities? value) async {
    if (value != null) {
      selectedCity.value = value;
      print('Selected City: ${value.name}');

      if (value.sites != null && value.sites!.isNotEmpty) {
        if (value.sites!.length > 1) {
          // If there are multiple sites, show the dialog to select one
          final selectedSite =
              await showSiteSelectionDialog(Get.context!, value.sites!);
          if (selectedSite != null) {
            siteNameController.text =
                '${selectedSite.siteCode}, ${selectedSite.siteName}';
            print(
                'Selected Site: ${selectedSite.siteName}, Site Code: ${selectedSite.siteCode}');
          }
        } else {
          var firstSite = value.sites!.first;
          siteNameController.text =
              '${firstSite.siteCode}, ${firstSite.siteName}';
          print(
              'Site Name: ${firstSite.siteName}, Site Code: ${firstSite.siteCode}');
        }
      } else {
        print('No sites available for the selected city');
      }
    }
  }

  Province? getProvinceByName(String name) {
    return provinces.firstWhere(
      (province) => province.name == name,
      orElse: () => Province(name: ''),
    );
  }

  Cities? getCityByName(String name) {
    return selectedProvince.value.cities?.firstWhere(
      (city) => city.name == name,
      orElse: () => Cities(name: ''),
    );
  }

  Future<Sites?> showSiteSelectionDialog(
      BuildContext context, List<Sites> sites) async {
    return showDialog<Sites>(
      context: context,
      builder: (BuildContext context) {
        List<Sites> filteredSites = sites;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Select a Site'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      hintText: 'Enter site name or code',
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredSites = sites
                            .where((site) =>
                                (site.siteName
                                        ?.toLowerCase()
                                        .contains(value.toLowerCase()) ??
                                    false) ||
                                (site.siteCode
                                        ?.toLowerCase()
                                        .contains(value.toLowerCase()) ??
                                    false))
                            .toList();
                      });
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListBody(
                        children: filteredSites.map((site) {
                          return ListTile(
                            title: Text('${site.siteCode}, ${site.siteName}'),
                            onTap: () {
                              Navigator.pop(
                                  context, site); // Return the selected site
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context); // Dismiss without returning a site
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> deleteFuelDetail(int id) async {
    isLoading.value = true;
    try {
      await apiProvider.deleteFuelDetails(id);
      var updatedRefuelings = (tripDetails['refuelings'] as List)
          .where((refuel) => refuel['id'] != id)
          .toList();
      tripDetails['refuelings'] = updatedRefuelings;
      tripDetails['total_amount_paid'] =
          _calculateTotalAmountPaid(updatedRefuelings);
      tripDetails['total_fuel_in_liters'] =
          _calculateTotalFuelInLiters(updatedRefuelings);

      Get.find<RefuelingController>().fetchTrips();
    } catch (e) {
      print('Error deleting fuel detail: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateFuelDetail(
      int id, Map<String, dynamic> updatedData) async {
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
        tripDetails['total_amount_paid'] =
            _calculateTotalAmountPaid(updatedRefuelings);
        tripDetails['total_fuel_in_liters'] =
            _calculateTotalFuelInLiters(updatedRefuelings);
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
  Future<void> refreshTrips() async {
    try {
      isLoading.value = true;
      final id = Get.arguments['id'];
      await fetchTripDetails(int.parse(id));
      // Get.snackbar('Success', 'Trip details refreshed successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to refresh trip details: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
