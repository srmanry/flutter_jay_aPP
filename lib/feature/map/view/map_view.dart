import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotem/feature/home/controller/home_controller.dart';
import '../controller/map_controller.dart';

class GoogleMapScreen extends StatelessWidget {
  GoogleMapScreen({super.key});

  final LocationController locationController = Get.put(LocationController());
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(locationController.lat.value, locationController.lng.value),
              zoom: 16,
            ),
            markers: Set<Marker>.from(locationController.markers),

            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (controller) async {
              locationController.setMapController(controller);
              await locationController.loadLocation();
              await locationController.fetchReportMarker();
             // await homeController.fetchReports();
            },
          ),

          // Optional: Loading indicator overlay
          Obx(() => locationController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox.shrink(child: Column(children: [
                Text("No markers found"),
          ],),

          )),
        ],
      ),
    );
  }
}
