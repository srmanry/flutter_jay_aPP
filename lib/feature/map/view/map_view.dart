import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:spotem/feature/home/controller/home_controller.dart';

import '../controller/map_controller.dart';
import 'package:geolocator/geolocator.dart';

String formatTimestamp(String? timestamp) {
  if (timestamp == null) return "Unknown time";
  try {
    final dateTime = DateTime.parse(timestamp).toLocal();
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  } catch (e) {
    return "Invalid Date";
  }
}

class GoogleMapScreen extends StatelessWidget {
  GoogleMapScreen({super.key});

  final LocationController locationController = Get.put(LocationController());
  final HomeController homeController = Get.put(HomeController());

  Future<void> _checkPermissionAndLoadLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    locationController.hasPermission.value = permission == LocationPermission.always || permission == LocationPermission.whileInUse;

    if (locationController.hasPermission.value) {
      await locationController.loadLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkPermissionAndLoadLocation(); // permission check and load location at build

    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            if (!locationController.hasPermission.value) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_off, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Location permission required', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Please enable location access to view the map'),
                  ],
                ),
              );
            }

            // Use default location (Bangladesh - Dhaka) if location not loaded yet
            final double displayLat = locationController.lat.value != 0.0
                ? locationController.lat.value
                : 23.8103; // Default: Dhaka, Bangladesh
            final double displayLng = locationController.lng.value != 0.0
                ? locationController.lng.value
                : 90.4125; // Default: Dhaka, Bangladesh

            return GoogleMap(
              padding: const EdgeInsets.only(bottom: 220),
              initialCameraPosition: CameraPosition(target: LatLng(displayLat, displayLng), zoom: 13),
              markers: Set<Marker>.from(locationController.markers),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              onMapCreated: (controller) async {
                locationController.setMapController(controller);
                await locationController.fetchReportMarker();
                await locationController.fetchNearbyPlaces();
              },
            );
          }),

          // My Location Button
          Positioned(
            right: 16,
            bottom: 240,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                final double targetLat = locationController.lat.value != 0.0 ? locationController.lat.value : 23.8103;
                final double targetLng = locationController.lng.value != 0.0 ? locationController.lng.value : 90.4125;
                locationController.mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(targetLat, targetLng), 16));
              },
              child: const Icon(Icons.my_location, color: Colors.blue, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
