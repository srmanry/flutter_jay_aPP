/* import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/new_feature_controller.dart';
import '../widgets/report_Bottom_sheet.dart';
import '../widgets/type_selector_widget.dart';

class CleancodeNewFeatureScreenView extends StatelessWidget {
  final controller = Get.find<NewFeatureController>();

  final LatLng userLocation = const LatLng(23.8103, 90.4125);

  CleancodeNewFeatureScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchReports();
    return Scaffold(
      appBar: AppBar(title: Text("New clean code  screen")),
      body: Obx(() {
        final markers = controller.generateMarkers(userLocation);

        return Stack(
          children: [
            /*   GoogleMap(
              initialCameraPosition: CameraPosition(target: userLocation, zoom: 14),
              // markers: markers,
              onTap: (pos) {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  context: context,
                  builder: (_) => ReportBottomSheet(position: pos),
                );
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ), */
            GoogleMap(
              initialCameraPosition: CameraPosition(target: userLocation, zoom: 14),
              markers: markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onTap: (pos) {
                // Open bottom sheet to create report
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => ReportBottomSheet(position: pos),
                ).whenComplete(() {
                  // Refresh markers after bottom sheet closes
                  controller.fetchReports();
                });
              },
            ),
            Positioned(right: 16, top: 100, child: TypeSelector(controller: controller)),
          ],
        );
      }),
    );
  }
}
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/new_feature_controller.dart';
import '../widgets/report_Bottom_sheet.dart';
import '../widgets/type_selector_widget.dart';

class CleancodeNewFeatureScreenView extends StatelessWidget {
  final controller = Get.find<NewFeatureController>();
  final LatLng userLocation = const LatLng(23.8103, 90.4125);

  CleancodeNewFeatureScreenView({super.key}) {
    // Only once when widget is created
    controller.fetchReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New clean code screen")),
      body: Obx(() {
        final markers = controller.generateMarkers(userLocation);

        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: userLocation, zoom: 14),
              markers: markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onTap: (pos) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => ReportBottomSheet(position: pos),
                ).whenComplete(() {
                  controller.fetchReports(); // Refresh after creating new report
                });
              },
            ),
            Positioned(right: 16, top: 100, child: TypeSelector(controller: controller)),
          ],
        );
      }),
    );
  }
}
