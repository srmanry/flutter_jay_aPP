import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotem/feature/map/controller/map_controller.dart';

class GoogleMapScreen extends StatelessWidget {
  GoogleMapScreen({super.key});
  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            locationController.lat.value,
            locationController.lng.value,
          ),
          zoom: 16,
        ),
        markers: locationController.markers.toSet(),
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          locationController.setMapController(controller);
        },
      )),
    );
  }
}
