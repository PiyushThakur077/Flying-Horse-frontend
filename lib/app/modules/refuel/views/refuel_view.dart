import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/refuel_controller.dart';

class RefuelView extends GetView<RefuelController> {
  const RefuelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: const Text('Refuel'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Column(
        children: [
          Expanded(child: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else {
              return GoogleMapWidget();
            }
          })),
        ],
      ),
    );
  }
}

class GoogleMapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RefuelController controller = Get.find<RefuelController>();
    return Obx(() {
      return GoogleMap(
        onMapCreated: controller.onMapCreated,
        initialCameraPosition: CameraPosition(
          target: controller.currentLocation.value,
          zoom: 11.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: {
          Marker(
            markerId: MarkerId('currentLocation'),
            position: controller.currentLocation.value,
          ),
        },
      );
    });
  }
}
