import 'package:flying_horse/app/data/api_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RefuelingController extends GetxController {
  var trips = <Map<String, dynamic>>[].obs; // List of maps to hold trip data
  var isLoading = true.obs;
  final apiProvider = ApiProvider();

  @override
  void onInit() {
    super.onInit();
    fetchTrips();
  }

  void fetchTrips() async {
    try {
      isLoading(true);
      var response = await apiProvider.getTrip();
      if (response != null && response is List) {
        var sortedTrips =
            response.map((e) => e as Map<String, dynamic>).toList()
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

        // Save the data to Get Storage if status_name is inprogress
        for (var trip in sortedTrips) {
          if (trip['status_name'] == 'inprogress') {
            GetStorage().write('cardNumber', trip['card_number']);
            GetStorage().write('tripNumber', trip['trip_number']);
            GetStorage().write('truckNumber', trip['truck_number']);
            break;
          }
        }
      }
    } catch (e) {
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
      var filterParams = {
        'trip_start_date': startDate.toIso8601String(),
        'trip_end_date': endDate.toIso8601String(),
      };
      var response = await apiProvider.filterTrips(filterParams);
      if (response != null && response is List) {
        var filteredTrips =
            response.map((e) => e as Map<String, dynamic>).toList();
        trips.assignAll(filteredTrips);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to filter trips');
    } finally {
      isLoading(false);
    }
  }

  void refreshTrips() {
    fetchTrips();
  }
}
