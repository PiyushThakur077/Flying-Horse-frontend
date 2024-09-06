import 'package:flying_horse/app/data/api_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RefuelingController extends GetxController {
  var trips = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  final apiProvider = ApiProvider();
  var fuelQuantity = 0.0.obs;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  @override
  void onInit() {
    super.onInit();
    fetchTrips();
    fetchFuelQuantity();
    loadSelectedDateRange(); 
  }

  void fetchFuelQuantity() {
    final storage = GetStorage();
    fuelQuantity.value = storage.read<double>('fuelQuantity') ?? 0.0;
  }

  Future<void> fetchTrips() async {
    try {
      isLoading(true);
      var response = await apiProvider.getTrip();
      if (response != null && response is List) {
        var sortedTrips = response.map((e) => e as Map<String, dynamic>).toList()
          ..sort((a, b) {
            if (a['status_name'] == 'inprogress' &&
                b['status_name'] != 'inprogress') {
              return -1;
            } else if (a['status_name'] != 'inprogress' &&
                b['status_name'] == 'inprogress') {
              return 1;
            } else {
              return 0;
            }
          });
        trips.assignAll(sortedTrips);

        for (var trip in sortedTrips) {
          if (trip['status_name'] == 'inprogress') {
            // Save trip details to GetStorage
            GetStorage().write('tripId', trip['id'] as int);
            GetStorage().write('cardNumber', trip['card_number']);
            GetStorage().write('tripNumber', trip['trip_number']);
            GetStorage().write('truckNumber', trip['truck_number']);
            GetStorage().write('truckName', trip['truck_name']);

            // Save trailer details to GetStorage if available and not empty
            if (trip['trailers'] != null && trip['trailers'] is List && trip['trailers'].isNotEmpty) {
              var trailer1 = trip['trailers'][0]; // First trailer

              if (trailer1['trailer_name'] != null && trailer1['trailer_name'].toString().isNotEmpty) {
                GetStorage().write('trailerName1', trailer1['trailer_name']);
              } else {
                GetStorage().remove('trailerName1'); // Remove if no valid trailer name
              }

              if (trailer1['trailer_number'] != null && trailer1['trailer_number'].toString().isNotEmpty) {
                GetStorage().write('trailerNumber1', trailer1['trailer_number']);
              } else {
                GetStorage().remove('trailerNumber1'); // Remove if no valid trailer number
              }

              // Optionally store trailer type if needed
              if (trailer1['trailer_type'] != null && trailer1['trailer_type'].toString().isNotEmpty) {
                GetStorage().write('trailerType1', trailer1['trailer_type']);
              } else {
                GetStorage().remove('trailerType1'); // Remove if no valid trailer type
              }

              // Handle second trailer if it exists
              if (trip['trailers'].length > 1) {
                var trailer2 = trip['trailers'][1]; // Second trailer

                if (trailer2['trailer_name'] != null && trailer2['trailer_name'].toString().isNotEmpty) {
                  GetStorage().write('trailerName2', trailer2['trailer_name']);
                } else {
                  GetStorage().remove('trailerName2'); // Remove if no valid trailer name
                }

                if (trailer2['trailer_number'] != null && trailer2['trailer_number'].toString().isNotEmpty) {
                  GetStorage().write('trailerNumber2', trailer2['trailer_number']);
                } else {
                  GetStorage().remove('trailerNumber2'); // Remove if no valid trailer number
                }

                // Optionally store trailer type if needed
                if (trailer2['trailer_type'] != null && trailer2['trailer_type'].toString().isNotEmpty) {
                  GetStorage().write('trailerType2', trailer2['trailer_type']);
                } else {
                  GetStorage().remove('trailerType2'); // Remove if no valid trailer type
                }
              } else {
                // Clear storage if the second trailer does not exist
                GetStorage().remove('trailerName2');
                GetStorage().remove('trailerNumber2');
                GetStorage().remove('trailerType2');
              }
            } else {
              // Clear trailer data if no valid trailer information is found
              GetStorage().remove('trailerName1');
              GetStorage().remove('trailerNumber1');
              GetStorage().remove('trailerType1');
              GetStorage().remove('trailerName2');
              GetStorage().remove('trailerNumber2');
              GetStorage().remove('trailerType2');
            }
          }
        }
      } else if (response == null) {
        print('No response from API');
        Get.snackbar('Error', 'No response from API');
      } else {
        print('Unexpected response format: $response');
        Get.snackbar('Error', 'Unexpected response format');
      }
    } catch (e) {
      print('Error fetching trips: $e'); // This will help you debug
      Get.snackbar('Error', 'Failed to fetch trips');
    } finally {
      isLoading(false);
    }
  }

  void updateTotalAmountPaid(String tripId, double amount) {
    var index = trips.indexWhere((trip) => trip['id'] == tripId);
    if (index != -1) {
      trips[index]['total_amount_paid'] = amount;
      trips.refresh();
    }
  }

  void filterTrips(DateTime startDate, DateTime endDate) async {
    try {
      isLoading(true);
      selectedStartDate = startDate;
      selectedEndDate = endDate;
      saveSelectedDateRange(); // Save selected date range
      var filterParams = {
        'trip_start_date': startDate.toIso8601String(),
        'trip_end_date': endDate.toIso8601String(),
      };
      var response = await apiProvider.filterTrips(filterParams);
      if (response != null && response is List) {
        var filteredTrips = response.map((e) => e as Map<String, dynamic>).toList();
        trips.assignAll(filteredTrips);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to filter trips');
    } finally {
      isLoading(false);
    }
  }

  void clearFilter() {
    selectedStartDate = null;
    selectedEndDate = null;
    GetStorage().remove('selectedStartDate');
    GetStorage().remove('selectedEndDate');
    fetchTrips(); // Fetch all trips again to clear the filter
  }

  void loadSelectedDateRange() {
    final storage = GetStorage();
    selectedStartDate = storage.read<DateTime>('selectedStartDate');
    selectedEndDate = storage.read<DateTime>('selectedEndDate');
  }

  void saveSelectedDateRange() {
    final storage = GetStorage();
    if (selectedStartDate != null && selectedEndDate != null) {
      storage.write('selectedStartDate', selectedStartDate);
      storage.write('selectedEndDate', selectedEndDate);
    }
  }

  Future<void> refreshTrips() async {
    await fetchTrips(); 
  }
}
