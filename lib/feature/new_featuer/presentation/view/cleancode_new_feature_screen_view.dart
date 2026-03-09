import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../map/controller/map_controller.dart';
import '../controller/new_feature_controller.dart';

import '../widgets/report_create_Bottom_sheet.dart';
import '../widgets/type_selector_widget.dart';

class CleancodeNewFeatureScreenView extends StatelessWidget {
  final controller = Get.find<NewFeatureController>();
  final LatLng defaultLocation = const LatLng(23.8103, 90.4125);
  final LocationController locationController = Get.find<LocationController>();

  CleancodeNewFeatureScreenView({super.key}) {
    // Only once when widget is created
    controller.fetchReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 1.5, title: const Text(""), backgroundColor: Colors.black.withValues(alpha: 0.9), elevation: 0),
      body: Obx(() {
        final LatLng userLocation = (locationController.lat.value != 0.0 && locationController.lng.value != 0.0)
            ? LatLng(locationController.lat.value, locationController.lng.value)
            : defaultLocation;
        final markers = controller.generateMarkers(userLocation);

        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: userLocation, zoom: 14),
              markers: markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              polylines: Set<Polyline>.from(locationController.polylines),
              /* onMapCreated: (GoogleMapController googleController) {
                controller.setMapController(googleController); 
              }, */
              onMapCreated: (GoogleMapController googleController) async {
                controller.setMapController(googleController);
                locationController.setMapController(googleController);
                await locationController.checkPermissionAndLoadLocation();
              },
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
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(4)),
                child: TypeSelector(controller: controller),
              ),
            ),
          ],
        );
      }),
    );
  }
}
