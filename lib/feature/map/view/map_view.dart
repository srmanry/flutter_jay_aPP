/*
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

          ],),

          )),
        ],
      ),
    );
  }
}
*/


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../controller/map_controller.dart';
import 'package:spotem/feature/home/controller/home_controller.dart';
// Top-level helper to format ISO timestamp strings to readable form.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Obx(() => GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                locationController.lat.value == 0.0 ? 23.8103 : locationController.lat.value,
                locationController.lng.value == 0.0 ? 90.4125 : locationController.lng.value,
              ),
              zoom: 14,
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
            },
            onTap: (_) {
              // Tap anywhere to hide custom info card
              locationController.selectedMarkerData.value = null;
            },
          )),


          Obx(() => locationController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox.shrink()),


          Obx(() {
            final data = locationController.selectedMarkerData.value;
            if (data == null) return const SizedBox.shrink();

            Color cardColor;
            IconData cardIcon;

            switch (data["type"]) {
              case "Fire":
                cardColor = Colors.deepOrange;
                cardIcon = Icons.local_fire_department;
                break;
              case "Police":
                cardColor = Colors.blue.shade200;
                cardIcon = Icons.local_police;
                break;
              case "Ambulance":
                cardColor = Colors.orange.shade200;
                cardIcon = Icons.local_hospital;
                break;
              default:
                cardColor = Colors.grey.shade200;
                cardIcon = Icons.location_on;
            }

            return Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 300),
                child: Card(
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 10,
                  shadowColor: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row (Icon + Type)
                        Row(
                          children: [
                            Icon(cardIcon, color: Colors.black87, size: 26),
                            const SizedBox(width: 8),
                            Text(
                              data["type"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Title
                        Text(
                          data["title"],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Description
                        Text(
                          data["description"],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Time Row
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 16, color: Colors.black54),
                            const SizedBox(width: 4),
                            Text(
                              "Time: ${formatTimestamp(data["time"])}",
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 13),
                            ),

                          ],
                        ),
                        const SizedBox(height: 12),

                        // Button
                     /*   Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              padding:
                              const EdgeInsets.symmetric(horizontal: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Get.snackbar(
                                "More Details",
                                "Lat: ${data["lat"]}, Lng: ${data["lng"]}",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            child: const Text(
                              "More Details",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
