import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../map/controller/map_controller.dart';
import '../controller/new_feature_controller.dart';

import '../widgets/report_create_Bottom_sheet.dart';
import '../widgets/type_selector_widget.dart';

class CleancodeNewFeatureScreenView extends StatelessWidget {
  final controller = Get.find<NewFeatureController>();
  final LocationController locationController = Get.find<LocationController>();

  CleancodeNewFeatureScreenView({super.key}) {
    // Only once when widget is created
    controller.fetchReports();
    locationController.checkPermissionAndLoadLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 1.5, title: const Text(""), backgroundColor: Colors.black.withValues(alpha: 0.9), elevation: 0),
      body: Obx(() {
        if (!locationController.hasPermission.value || locationController.lat.value == 0.0 || locationController.lng.value == 0.0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('Location permission required', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                const Text('Please allow location permission and enable GPS'),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: locationController.checkPermissionAndLoadLocation,
                  child: const Text('Allow Location'),
                ),
              ],
            ),
          );
        }

        final LatLng userLocation = LatLng(locationController.lat.value, locationController.lng.value);
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
