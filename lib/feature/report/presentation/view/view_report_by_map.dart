/* import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/view_report_by_map_controller.dart';

class ViewReportByMap extends StatelessWidget {
  ViewReportByMap({super.key});

  final ViewReportByMapController controller = Get.find<ViewReportByMapController>();

  @override
  Widget build(BuildContext context) {
    const fallbackLocation = LatLng(23.8103, 90.4125);

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final initialPosition = controller.markers.isNotEmpty ? controller.markers.first.position : fallbackLocation;

        return GoogleMap(
          initialCameraPosition: CameraPosition(target: initialPosition, zoom: 13),
          markers: Set<Marker>.from(controller.markers),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
        );
      }),
    );
  }
}

 */