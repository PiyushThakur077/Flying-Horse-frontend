import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/api_provider.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/modules/refueling/controllers/refueling_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class RefuelController extends GetxController {
  late GoogleMapController mapController;
  final LatLng initialPosition = const LatLng(45.521563, -122.677433);

  var currentLocation = LatLng(0, 0).obs;
  var isLoading = true.obs;
  var selectedFuelType = 'diesel'.obs;
  var siteSuggestions = <String>[].obs;

  var truckNumber = ''.obs;
  var odometerReadingUnit = 'KM'.obs;
  var odometerReading = 0.0.obs;
  var fuelQuantityUnit = 'liters'.obs;
  var fuelQuantity = 0.0.obs;
  var amountPaid = 0.0.obs;
  var tripNumber = ''.obs;
  var cardDetail = ''.obs;
  var receiptNumber = ''.obs;
  var siteCode = ''.obs;
  var yourPrice = 0.0.obs;

  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController siteNameController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  final Map<String, String> countryIso2Map = {
    'Canada': 'CA',
    'United States': 'US',
    'Mexico': 'MX',
  };

  final Map<String, String> stateIso2Map = {
    'Alberta': 'AB',
    'British Columbia': 'BC',
    'Manitoba': 'MB',
    'New Brunswick': 'NB',
    'Newfoundland and Labrador': 'NL',
    'Northwest Territories': 'NT',
    'Nova Scotia': 'NS',
    'Nunavut': 'NU',
    'Ontario': 'ON',
    'Prince Edward Island': 'PE',
    'Quebec': 'QC',
    'Saskatchewan': 'SK',
    'Yukon': 'YT',
    // United States
    'Alabama': 'AL',
    'Alaska': 'AK',
    'Arizona': 'AZ',
    'Arkansas': 'AR',
    'California': 'CA',
    'Colorado': 'CO',
    'Connecticut': 'CT',
    'Delaware': 'DE',
    'Florida': 'FL',
    'Georgia': 'GA',
    'Hawaii': 'HI',
    'Idaho': 'ID',
    'Illinois': 'IL',
    'Indiana': 'IN',
    'Iowa': 'IA',
    'Kansas': 'KS',
    'Kentucky': 'KY',
    'Louisiana': 'LA',
    'Maine': 'ME',
    'Maryland': 'MD',
    'Massachusetts': 'MA',
    'Michigan': 'MI',
    'Minnesota': 'MN',
    'Mississippi': 'MS',
    'Missouri': 'MO',
    'Montana': 'MT',
    'Nebraska': 'NE',
    'Nevada': 'NV',
    'New Hampshire': 'NH',
    'New Jersey': 'NJ',
    'New Mexico': 'NM',
    'New York': 'NY',
    'North Carolina': 'NC',
    'North Dakota': 'ND',
    'Ohio': 'OH',
    'Oklahoma': 'OK',
    'Oregon': 'OR',
    'Pennsylvania': 'PA',
    'Rhode Island': 'RI',
    'South Carolina': 'SC',
    'South Dakota': 'SD',
    'Tennessee': 'TN',
    'Texas': 'TX',
    'Utah': 'UT',
    'Vermont': 'VT',
    'Virginia': 'VA',
    'Washington': 'WA',
    'West Virginia': 'WV',
    'Wisconsin': 'WI',
    'Wyoming': 'WY',
    // Mexico
    'Aguascalientes': 'AG',
    'Baja California': 'BC',
    'Baja California Sur': 'BS',
    'Campeche': 'CM',
    'Chiapas': 'CS',
    'Chihuahua': 'CH',
    'Coahuila': 'CO',
    'Colima': 'CL',
    'Durango': 'DG',
    'Guanajuato': 'GT',
    'Guerrero': 'GR',
    'Hidalgo': 'HG',
    'Jalisco': 'JA',
    'Mexico City': 'DF',
    'Mexico State': 'EM',
    'Michoacán': 'MI',
    'Morelos': 'MO',
    'Nayarit': 'NA',
    'Nuevo León': 'NL',
    'Oaxaca': 'OA',
    'Puebla': 'PU',
    'Querétaro': 'QT',
    'Quintana Roo': 'QR',
    'San Luis Potosí': 'SL',
    'Sinaloa': 'SI',
    'Sonora': 'SO',
    'Tabasco': 'TB',
    'Tamaulipas': 'TM',
    'Tlaxcala': 'TL',
    'Veracruz': 'VE',
    'Yucatán': 'YU',
    'Zacatecas': 'ZA',
  };

  @override
  void onInit() {
    super.onInit();
    _prefillDetailsFromStorage();
    setupListeners();
  }

  void _prefillDetailsFromStorage() {
    final storage = GetStorage();
    truckNumber.value = storage.read<String>('truckNumber') ?? '';
    tripNumber.value = storage.read<String>('tripNumber') ?? '';
    cardDetail.value = storage.read<String>('cardNumber') ?? '';
    fuelQuantity.value = storage.read<double>('fuelQuantity') ?? 0.0;
  }

  void setupListeners() {
    countryController.addListener(_fetchSiteDetails);
    stateController.addListener(_fetchSiteDetails);
    cityController.addListener(_fetchSiteDetails);
  }

  Future<List<String>> fetchSiteSuggestions(String query) async {
    List<String> suggestions = [];

    if (query.isNotEmpty) {
      final filterParams = {
        "query": query,
        "country": countryIso2Map[countryController.text] ?? '',
        "state": stateIso2Map[stateController.text] ?? '',
        "city": cityController.text,
      };

      try {
        var response =
            await ApiProvider().getPetroleumSiteSuggestions(filterParams);

        if (response is String) {
          response = jsonDecode(response);
        }

        if (response is List<dynamic>) {
          if (response.isEmpty) {
            Get.snackbar("Info", "No site suggestions found.");
          } else {
            // Extract the 'site_name' from each map in the list
            suggestions = response.map<String>((item) {
              if (item is Map<String, dynamic>) {
                return item['site_name'] as String;
              }
              return ''; // Fallback in case of unexpected structure
            }).toList();
          }
        } else {
          // Get.snackbar("Error", "Failed to fetch site suggestions.");
        }
      } catch (e) {
        print("Failed to fetch site suggestions: $e");
        Get.snackbar("Error", "Failed to fetch site suggestions: $e");
      }
    }

    return suggestions;
  }

  Future<void> _fetchSiteDetails() async {
    final country = countryController.text;
    final state = stateController.text;
    final city = cityController.text;

    if (country.isNotEmpty && state.isNotEmpty && city.isNotEmpty) {
      final countryIso2 = countryIso2Map[country] ?? '';
      final stateIso2 = stateIso2Map[state] ?? '';

      if (countryIso2.isEmpty || stateIso2.isEmpty) {
        Get.snackbar("Error", "Invalid country or state");
        return;
      }

      final filterParams = {
        "country": countryIso2,
        "state": stateIso2,
        "city": city
      };
      try {
        var response = await ApiProvider().filterPetroleumSites(filterParams);

        if (response is String) {
          response = jsonDecode(response);
        }

        // Debug prints to trace the data
        print('Raw Response: $response');
        if (response is Map<String, dynamic>) {
          print('Parsed Response: $response');

          // Accessing site details correctly
          final countryData = response[countryIso2];
          if (countryData == null) {
            print('Country data not found for $countryIso2');
            return;
          }

          final stateData = countryData[stateIso2];
          if (stateData == null) {
            print('State data not found for $stateIso2');
            return;
          }

          // Use a case-insensitive lookup for city data
          final cityKey = stateData.keys.firstWhere(
              (k) => k.toLowerCase() == city.toLowerCase(),
              orElse: () => '');

          if (cityKey.isEmpty) {
            print('City data not found for $city');
            return;
          }

          final cityData = stateData[cityKey];
          if (cityData == null || cityData.isEmpty) {
            print('City data not found for $cityKey');
            return;
          }

          if (cityData.length == 1) {
            // Only one site available
            final siteDetails = cityData[0];
            _setSiteDetails(siteDetails);
          } else {
            // Multiple sites available, show selection dialog
            _showSiteSelectionDialog(cityData);
          }
        } else {
          Get.snackbar("Error", "Failed to fetch site details");
        }
      } catch (e) {
        print("Failed to fetch site details: $e");
        Get.snackbar("Error", "Failed to fetch site details: $e");
      }
    }
  }

  void _setSiteDetails(Map<String, dynamic> siteDetails) {
    final siteName = siteDetails['site_name'] ?? '';
    final siteCodeValue = siteDetails['site_code'] ?? '';
    final siteYourPrice =
        double.tryParse(siteDetails['your_price'].toString()) ?? 0.0;

    siteNameController.text = '$siteCodeValue, $siteName'; // Set combined value
    siteCode.value = siteCodeValue;
    yourPrice.value = siteYourPrice;

    final storage = GetStorage();
    storage.write('siteName', siteName);
    storage.write('siteCode', siteCodeValue);
    storage.write('yourPrice', siteYourPrice);
  }

  void _showSiteSelectionDialog(List<dynamic> sites) {
    searchController.clear(); // Clear search field when opening dialog
    List<dynamic> filteredSites = sites;

    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Column(
                children: [
                  Text('Select Site'),
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by site name or code',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            filteredSites = sites;
                          });
                        },
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredSites = sites.where((site) {
                          final siteName =
                              site['site_name']?.toLowerCase() ?? '';
                          final siteCode =
                              site['site_code']?.toLowerCase() ?? '';
                          return siteName.contains(value.toLowerCase()) ||
                              siteCode.contains(value.toLowerCase());
                        }).toList();
                      });
                    },
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredSites.length,
                  itemBuilder: (BuildContext context, int index) {
                    final siteDetails = filteredSites[index];
                    final siteName = siteDetails['site_name'] ?? '';
                    final siteCode = siteDetails['site_code'] ?? '';

                    return ListTile(
                      title: Text(
                          '$siteCode: $siteName'), // Display site code and name
                      onTap: () {
                        _setSiteDetails(siteDetails);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void setSelectedFuelType(String value) {
    selectedFuelType.value = value;
  }

  String? validateTruckNumber(String text) {
    return text.isNotEmpty ? null : "Please enter a valid truck number";
  }

  String? validateOdometerReading(double value) {
    return value > 0 ? null : "Please enter a valid odometer reading";
  }

  String? validateFuelQuantity(double value) {
    return value > 0 ? null : "Please enter a valid fuel quantity";
  }

  String? validateAmountPaid(double value) {
    return value > 0 ? null : "Please enter a valid amount paid";
  }

  String? validateTripNumber(String text) {
    return text.isNotEmpty ? null : "Please enter a valid trip number";
  }

  String? validateCardDetail(String text) {
    return text.isNotEmpty ? null : "Please enter a valid card detail";
  }

  String? validateSiteName(String text) {
    return text.isNotEmpty ? null : "Please enter a valid site name";
  }

  bool validateFields() {
    if (validateTruckNumber(truckNumber.value) != null ||
        validateOdometerReading(odometerReading.value) != null ||
        validateFuelQuantity(fuelQuantity.value) != null ||
        validateTripNumber(tripNumber.value) != null ||
        validateCardDetail(cardDetail.value) != null ||
        validateSiteName(siteNameController.text) != null ||
        countryController.text.isEmpty ||
        stateController.text.isEmpty ||
        cityController.text.isEmpty) {
      Get.snackbar(
        backgroundColor: Colors.red.shade500,
        colorText: Colors.white,
        "Error",
        "All fields are required except Amount Paid",
        icon: const Icon(
          Icons.error,
          color: Colors.white,
        ),
      );

      return false;
    }
    return true;
  }

  void notifyRefuelingController() {
    RefuelingController refuelingController = Get.find<RefuelingController>();
    refuelingController.refreshTrips();
  }

  Future<void> saveFuelDetails(BuildContext context) async {
    if (!validateFields()) return;

    isLoading.value = true;

    final localTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    final map = {
      "trip_number": tripNumber.value,
      "fuel_type": selectedFuelType.value.toLowerCase(),
      "odometer_reading_unit": odometerReadingUnit.value,
      "odometer_reading": odometerReading.value,
      "fuel_quantity_unit": fuelQuantityUnit.value,
      "fuel_quantity": fuelQuantity.value,
      "receipt_number": receiptNumber.value,
      "fuel_station_address": jsonEncode({
        "country": countryController.text,
        "state": stateController.text,
        "city": cityController.text,
        "site_name": siteNameController.text,
      }),
      "your_price": yourPrice.value,
      "timezone": DateTime.now().timeZoneName, // Hidden field for timezone
      "local_time": localTime,
    };

    // Include amount_paid only if it has a valid value
    if (amountPaid.value > 0) {
      map["amount_paid"] = amountPaid.value;
    }

    // Print the submitted data
    print("Submitted Data: $map");

    try {
      var response = await ApiProvider().saveFuelDetails(map);

      if (response is String) {
        response = jsonDecode(response);
      }

      if (response is Map<String, dynamic> && response['success'] == true) {
        Get.snackbar(
            backgroundColor: Colors.green.shade500,
            colorText: Colors.white,
            "Success",
            "Fuel details saved successfully");

        // Save fuelQuantity in GetStorage
        final storage = GetStorage();
        storage.write('fuelQuantity', fuelQuantity.value);

        // Notify RefuelingController
        notifyRefuelingController();

        // Clear all fields
        truckNumber.value = '';
        odometerReading.value = 0.0;
        fuelQuantity.value = 0.0;
        amountPaid.value = 0.0;
        tripNumber.value = '';
        cardDetail.value = '';
        receiptNumber.value = '';
        countryController.clear();
        stateController.clear();
        cityController.clear();
        siteNameController.clear();
        yourPrice.value = 0.0; // Clear your_price

        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context, true);
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
  void onClose() {
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    siteNameController.dispose();
    super.onClose();
  }
}