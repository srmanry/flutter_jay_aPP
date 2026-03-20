import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

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

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final LocationController locationController = Get.find<LocationController>();

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
  void initState() {
    super.initState();
    _checkPermissionAndLoadLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
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
                      onPressed: _checkPermissionAndLoadLocation,
                      child: const Text('Allow Location'),
                    ),
                  ],
                ),
              );
            }

            return GoogleMap(
              // padding: const EdgeInsets.only(bottom: 220),
              initialCameraPosition: CameraPosition(target: LatLng(locationController.lat.value, locationController.lng.value), zoom: 14),
              markers: Set<Marker>.from(locationController.markers),
              polylines: Set<Polyline>.from(locationController.polylines),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              onMapCreated: (controller) async {
                locationController.setMapController(controller);
                await locationController.fetchReportMarker();
                // await locationController.fetchNearbyPlaces();
              },
            );
          }),

          // My Location Button
          /*    Positioned(
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
          ), */
        ],
      ),
    );
  }
}
