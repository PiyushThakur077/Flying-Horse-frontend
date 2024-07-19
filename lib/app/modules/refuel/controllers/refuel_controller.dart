import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RefuelController extends GetxController {
  late GoogleMapController mapController;
  final LatLng initialPosition = const LatLng(45.521563, -122.677433);

  var currentLocation = LatLng(0, 0).obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    currentLocation.value = LatLng(_locationData.latitude!, _locationData.longitude!);
    isLoading.value = false;
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
