import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../map/controller/map_controller.dart';
import '../controller/new_feature_controller.dart';

import '../widgets/report_create_Bottom_sheet.dart';
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
      appBar: AppBar(toolbarHeight: 1.5, title: const Text(""), backgroundColor: Colors.black.withOpacity(0.9), elevation: 0),
      body: Obx(() {
        final markers = controller.generateMarkers(userLocation);

        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: userLocation, zoom: 14),
              markers: markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              polylines: Get.find<LocationController>().polylines.value,
              /* onMapCreated: (GoogleMapController googleController) {
                controller.setMapController(googleController); 
              }, */
              onTap: (pos) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => ReportCreateBottomSheet(position: pos),
                ).whenComplete(() {
                  controller.fetchReports();
                });
              },
            ),
            Positioned(
              right: 16,
              top: 100,
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(.9), borderRadius: BorderRadius.circular(4)),
                child: TypeSelector(controller: controller),
              ),
            ),
          ],
        );
      }),
    );
  }
}
