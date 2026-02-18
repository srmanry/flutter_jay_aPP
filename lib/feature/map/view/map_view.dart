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
          /// 🔹 GOOGLE MAP (FULL SCREEN)
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

          /*           /// 🔹 NICE BOTTOM CONTAINER
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, -4))],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nearby Reports", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text("Tap on a marker to see details.", style: TextStyle(color: Colors.black54)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.to(() => ViewReportByMap());
                          },
                          child: Text("View All Reports"),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => const CreateReportByMapView());
                          },
                          child: Row(children: [Text("Create Reports"), Icon(Icons.add_location_alt_rounded)]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ), */

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
