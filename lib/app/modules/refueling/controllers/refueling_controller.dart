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
    loadSelectedDateRange(); // Load stored date range
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
          GetStorage().write('cardNumber', trip['card_number']);
          GetStorage().write('tripNumber', trip['trip_number']);
          GetStorage().write('truckNumber', trip['truck_number']);
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
    await fetchTrips(); // Ensure fetchTrips() is awaited
  }
}
