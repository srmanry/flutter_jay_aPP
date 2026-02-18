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

  Future<void> _checkPermission() async {
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
    _checkPermission(); // permission check at build

    return Scaffold(
      body: Stack(
        children: [
      
          Obx(() {
            if (!locationController.hasPermission.value) {
              return const SizedBox.shrink();
            }

            if (locationController.lat.value == 0.0 || locationController.lng.value == 0.0) {
              return const SizedBox.shrink();
            }

            return GoogleMap(
              padding: const EdgeInsets.only(bottom: 220),
              initialCameraPosition: CameraPosition(target: LatLng(locationController.lat.value, locationController.lng.value), zoom: 13),
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

          ///
          Positioned(
            bottom: 220,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                if (locationController.lat.value != 0.0 && locationController.lng.value != 0.0) {
                  locationController.mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(LatLng(locationController.lat.value, locationController.lng.value), 16),
                  );
                }
              },
              child: const Icon(Icons.my_location, color: Colors.blue, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
