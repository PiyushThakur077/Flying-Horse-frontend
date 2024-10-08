import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/api_provider.dart';
import 'package:flying_horse/app/modules/refuel/models/country.dart';
import 'package:flying_horse/app/modules/refueling/controllers/refueling_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class RefuelController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var currentLocation = LatLng(0, 0).obs;
  var isLoading = false.obs;
  var isProvinceLoading = false.obs;
  var selectedFuelType = 'diesel'.obs;
  var selectedFuelFilledTo = 'truck'.obs;
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
  var effectiveDate = ''.obs;
  var pricePerLitre = 0.0.obs;
  var pricePerGallon = 0.0.obs;
  var provinces = <Province>[].obs;
  var selectedProvince = Province().obs;
  var selectedCity = Cities().obs;
  var selectedCountry = ''.obs;
  var siteName = ''.obs;
  var tripId = 0.obs;
  var prod = ''.obs;
  var fedralTax = ''.obs;
  var stateTax = ''.obs;
  var cost = 0.0.obs;
  var freight = 0.0.obs;
  var other = 0.0.obs;
  var basePrice = 0.0.obs;
  var fet = ''.obs;
  var pft = ''.obs;
  var pct = ''.obs;
  var local = ''.obs;
  var fuelPrice = 0.0.obs;
  var salesTax = 0.0.obs;
  var inTaxPrice = 0.0.obs;
  var qst = 0.0.obs;
  var totalCost = 0.0.obs;
  var retailPrice = 0.0.obs;
  var savings = 0.0.obs;

  // Update these to store two trailer names and numbers
  var trailerNumber1 = ''.obs;
  var trailerNumber2 = ''.obs;
  var trailerName1 = ''.obs;
  var trailerName2 = ''.obs;

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

  @override
  void onInit() {
    super.onInit();
    _prefillDetailsFromStorage();
    fetchProvinces(selectedCountry.value);
  }

  void _prefillDetailsFromStorage() {
    isLoading.value = true;
    final storage = GetStorage();
    tripId.value = GetStorage().read<int>('tripId') ?? 0;
    truckNumber.value = storage.read<String>('truckNumber') ?? '';
    tripNumber.value = storage.read<String>('tripNumber') ?? '';
    cardDetail.value = storage.read<String>('cardNumber') ?? '';
    fuelQuantity.value = storage.read<double>('fuelQuantity') ?? 0.0;

    // Read both trailer names and trailer numbers
    trailerNumber1.value = storage.read<String>('trailerNumber1') ?? '';
    trailerNumber2.value = storage.read<String>('trailerNumber2') ?? '';
    trailerName1.value = storage.read<String>('trailerName1') ?? '';
    trailerName2.value = storage.read<String>('trailerName2') ?? '';

    isLoading.value = false;
  }

  Future<void> fetchProvinces(String iso2CountryCode) async {
    if (iso2CountryCode.isEmpty) return;

    isProvinceLoading.value = true; // Start loading
    try {
      final response =
          await ApiProvider().getProvincesByCountry(iso2CountryCode);
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
    } finally {
      isProvinceLoading.value = false; // Stop loading
    }
  }

  void onCountrySelected(String? country) {
    if (country != null) {
      selectedProvince.value = Province();
      selectedCity.value = Cities();
      selectedCountry.value = country;

      siteNameController.clear();

      if (countryIso2Map[country] == 'US') {
        fuelQuantityUnit.value = 'gallon';
        odometerReadingUnit.value = 'Miles';
        pricePerGallon.value = pricePerGallon.value;
      } else {
        fuelQuantityUnit.value = 'liters';
        odometerReadingUnit.value = 'KM';
        pricePerLitre.value = pricePerLitre.value;
      }

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
        Sites? selectedSite;

        if (value.sites!.length > 1) {
          // If there are multiple sites, show the dialog to select one
          selectedSite =
              await showSiteSelectionDialog(Get.context!, value.sites!);
        } else {
          // If there is only one site, select it automatically
          selectedSite = value.sites!.first;
        }

        if (selectedSite != null) {
          siteNameController.text =
              '${selectedSite.siteCode}, ${selectedSite.siteName}';
          print(
              'Selected Site: ${selectedSite.siteName}, Site Code: ${selectedSite.siteCode}');

          // Convert your_price to a double and save it
          yourPrice.value =
              double.tryParse(selectedSite.yourPrice ?? '0.0') ?? 0.0;
          effectiveDate.value = selectedSite.effectiveDate ?? '';
          prod.value = selectedSite.prod ?? '';
          fedralTax.value = selectedSite.fedralTax ?? '';
          stateTax.value = selectedSite.stateTax ?? '';
          cost.value = double.tryParse(selectedSite.cost ?? '0.0') ?? 0.0;
          ;
          freight.value =
              double.tryParse(selectedSite.yourPrice ?? '0.0') ?? 0.0;
          other.value = double.tryParse(selectedSite.other ?? '0.0') ?? 0.0;
          basePrice.value =
              double.tryParse(selectedSite.basePrice ?? '0.0') ?? 0.0;
          fet.value = selectedSite.fet ?? '';
          pft.value = selectedSite.pft ?? '';
          pct.value = selectedSite.pct ?? '';
          local.value = selectedSite.local ?? '';
          fuelPrice.value =
              double.tryParse(selectedSite.fuelPrice ?? '0.0') ?? 0.0;
          salesTax.value =
              double.tryParse(selectedSite.salesTax ?? '0.0') ?? 0.0;
          inTaxPrice.value =
              double.tryParse(selectedSite.intaxPrice ?? '0.0') ?? 0.0;
          qst.value = double.tryParse(selectedSite.qst ?? '0.0') ?? 0.0;
          totalCost.value =
              double.tryParse(selectedSite.totalCost ?? '0.0') ?? 0.0;
          retailPrice.value =
              double.tryParse(selectedSite.retailPrice ?? '0.0') ?? 0.0;
          savings.value = double.tryParse(selectedSite.savings ?? '0.0') ?? 0.0;

          print('Your Price: ${yourPrice.value}');
          print('Effective Date: ${effectiveDate.value}');
        }
      } else {
        print('No sites available for the selected city');
      }
    }
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
                  Container(
                    width: double.infinity,
                    height: 75,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Search',
                        hintText: 'Enter site name or code',
                        filled: true,
                        fillColor: const Color(0xFFEEEEEE),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 20.0,
                        ),
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

  void setSelectedFuelType(String value) {
    selectedFuelType.value = value;
  }

  void setSelectedFuelFilledTo(String value) {
    selectedFuelFilledTo.value = value;
  }

  String? validateCountry(String text) {
    return text.isNotEmpty ? null : "Please select a valid country";
  }

  String? validateState(String text) {
    return text.isNotEmpty ? null : "Please select a valid state";
  }

  String? validateCity(String text) {
    return text.isNotEmpty ? null : "Please select a valid city";
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

  String? validateReceiptNumber(String text) {
    return text.isNotEmpty ? null : "Please enter a valid receipt number";
  }

  String? validatePricePerLiter(double value) {
    return value > 0 ? null : "Please enter a valid price per liter";
  }

  String? validatePricePerGallon(double value) {
    return value > 0 ? null : "Please enter a valid price per liter";
  }

  bool validateFields() {
    if (validateTruckNumber(truckNumber.value) != null ||
        validateOdometerReading(odometerReading.value) != null ||
        validateFuelQuantity(fuelQuantity.value) != null ||
        validateTripNumber(tripNumber.value) != null ||
        validateCardDetail(cardDetail.value) != null ||
        validateSiteName(siteNameController.text) != null ||
        validateCountry(selectedCountry.value) != null ||
        validateState(selectedProvince.value.name ?? '') != null ||
        validateCity(selectedCity.value.name ?? '') != null ||
        validateReceiptNumber(receiptNumber.value) != null) {
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
      "trip_id": tripId.value,
      "trip_number": tripNumber.value,
      "fuel_type": selectedFuelType.value.toLowerCase(),
      "odometer_reading_unit": odometerReadingUnit.value,
      "odometer_reading": odometerReading.value,
      "fuel_quantity_unit": fuelQuantityUnit.value,
      "fuel_quantity": fuelQuantity.value,
      "receipt_number": receiptNumber.value,
      "fuel_station_address": jsonEncode({
        "country": selectedCountry.value,
        "state": selectedProvince.value.name ?? '',
        "city": selectedCity.value.name ?? '',
        "site_name": siteNameController.text,
      }),
      "your_price": yourPrice.value,
      "price_per_liter": pricePerLitre.value,
      "price_per_gallon": pricePerGallon.value,
      "timezone": DateTime.now().timeZoneName,
      "local_time": localTime,
      "effective_date": effectiveDate.value,
      "amount_paid": amountPaid.value > 0 ? amountPaid.value : null,
      "fuel_filled_to": selectedFuelFilledTo.value,
      "prod": prod.value,
      "fedral_tax": fedralTax.value,
      "state_tax": stateTax.value,
      "cost": cost.value,
      "freight": freight.value,
      "other": other.value,
      "base_price": basePrice.value,
      "fet": fet.value,
      "pft": pft.value,
      "pct": pct.value,
      "local": local.value,
      "fuel_price": fuelPrice.value,
      "sales_tax": salesTax.value,
      "intax_price": inTaxPrice.value,
      "qst": qst.value,
      "total_cost": totalCost.value,
      "retail_price": retailPrice.value,
      "savings": savings.value,
    };

    print("Submitted Data: $map"); // Debug output

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

        final storage = GetStorage();
        storage.write('fuelQuantity', fuelQuantity.value);

        notifyRefuelingController();

        truckNumber.value = '';
        odometerReading.value = 0.0;
        fuelQuantity.value = 0.0;
        amountPaid.value = 0.0;
        tripNumber.value = '';
        cardDetail.value = '';
        receiptNumber.value = '';
        pricePerLitre.value = 0.0;
        countryController.clear();
        stateController.clear();
        cityController.clear();
        pricePerGallon.value = 0.0;
        siteNameController.clear();
        yourPrice.value = 0.0;
        prod.value = '';
       

        Future.delayed(Duration(milliseconds: 5), () {
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
