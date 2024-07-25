import 'package:flying_horse/app/data/api_provider.dart';
import 'package:get/get.dart';

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
        trips.assignAll(response.map((e) => e as Map<String, dynamic>).toList());
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch trips');
    } finally {
      isLoading(false);
    }
  }
}
