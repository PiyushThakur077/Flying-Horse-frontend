import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/widgets/app_button.dart';
import 'package:flying_horse/app/widgets/common_text_input.dart';
import 'package:get/get.dart';
import '../controllers/refuel_controller.dart';

class RefuelView extends GetView<RefuelController> {
  const RefuelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RxString selectedFuelType = 'Diesel'.obs; // Observe the selected fuel type

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text('Refuel'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fuel Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => Container(
              width: double.infinity,
              child: SegmentedButton<String>(
                showSelectedIcon: false, // Hide the tick icon
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return AppColors.primary;
                      }
                      return null;
                    },
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.white;
                      }
                      return AppColors.primary;
                    },
                  ),
                ),
                segments: const <ButtonSegment<String>>[
                  ButtonSegment<String>(
                    value: 'Diesel',
                    label: Text('Diesel'),
                  ),
                  ButtonSegment<String>(
                    value: 'DEF',
                    label: Text('DEF'),
                  ),
                ],
                selected: <String>{selectedFuelType.value},
                onSelectionChanged: (Set<String> newSelection) {
                  if (newSelection.isNotEmpty) {
                    selectedFuelType.value = newSelection.first;
                  }
                },
              ),
            )),
            const SizedBox(height: 10),
            const CommonTextInput(
              labelText: 'Truck number',
              hintText: 'ONTARIO 8AHM 202',
            ),
            const SizedBox(height: 10),
            const CommonTextInput(
              labelText: 'Odometer Reading',
              hintText: 'Enter reading',
              showSegmentedTabs: true,
              segments: ['KM', 'Miles'],
            ),
            const SizedBox(height: 10),
            const CommonTextInput(
              labelText: 'Fuel Quantity',
              hintText: 'Enter fuel quantity',
              showSegmentedTabs: true,
              segments: ['Liter', 'Gallon'],
            ),
            const SizedBox(height: 10),
            const CommonTextInput(
              labelText: 'Trip Number',
              hintText: 'ONTARIO 8AHM 202',
            ),
            const SizedBox(height: 10),
            const CommonTextInput(
              labelText: 'Card Detail',
              hintText: 'ONTARIO 8AHM 202',
            ),
            Center(
              child: AppButton(
                title: 'Submit',
                onPressed: () {
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
