import 'package:flying_horse/app/data/api_provider.dart';
import 'package:get/get.dart';

class RefuelCardController extends GetxController {
  var tripDetails = {}.obs;
  var isLoading = true.obs;
  var apiProvider = ApiProvider();

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments['id'];
    fetchTripDetails(int.parse(id));
  }

  void fetchTripDetails(int id) async {
    try {
      var details = await apiProvider.getTripId(id);
      tripDetails.value = details;
    } finally {
      isLoading.value = false;
    }
  }
}
