
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
              await locationController.fetchNearbyPlaces();

            },
            onTap: (_) {
              // Tap anywhere to hide custom info card
              locationController.selectedMarkerData.value = null;
            },
          )),


          Obx(() => locationController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              :  SizedBox.shrink()),


          Obx(() {
            final data = locationController.selectedMarkerData.value;
            if (data == null) return  SizedBox.shrink();

            Color cardColor;
            IconData cardIcon;
            Color? iconColor;
            Color ?textColor;

            switch (data["type"]) {
              case "Fire":
                cardColor = Colors.white;
                cardIcon = Icons.local_fire_department;
                iconColor = Colors.red[400];
                textColor = Colors.red[400];
                break;
              case "Police":
                cardColor = Colors.white;
                cardIcon = Icons.local_police;
                iconColor = Colors.blue;
                textColor = Colors.blue;
                break;
              case "Ambulance":
                cardColor = Colors.white;
                cardIcon = Icons.car_crash_outlined;
                iconColor = Colors.orange.shade200;
                textColor = Colors.orange.shade200;
                break;
              default:
                cardColor = Colors.white;
                cardIcon = Icons.location_on;
                iconColor = Color(0xFF2B7FD0);
                textColor = Color(0xFF2B7FD0);
            }

            return Positioned(
              bottom: 100,
              left: 20,
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: 300,

                 decoration: BoxDecoration(
                   color: cardColor,
                   borderRadius: BorderRadius.circular(16),
                   shape: BoxShape.rectangle,
                   boxShadow: [
                     BoxShadow(
                       color: Colors.black26,
                       blurRadius: 2,
                       offset: const Offset(0, 0),
                     ),
                   ],
                 ),
                 // shape: RoundedRectangleBorder(
                 //    borderRadius: BorderRadius.circular(16),
                 //  ),
          /*        elevation: 10,
                  shadowColor: Colors.black54,*/
                  child: Padding(
                    padding:  EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row (Icon + Type)
                        Row(
                          children: [
                            Icon(cardIcon, color: iconColor, size: 26),
                            SizedBox(width: 8),
                            Text(
                              data["type"]?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: textColor,  // Using the textColor variable that's already defined
                              ),
                            ),
                          ],
                  ),

                        SizedBox(height: 8),
                        // Title
                        Text(
                          data["title"]?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Description
                        Text(
                          data["description"] ?? "",
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
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
                              style: const TextStyle(color: Colors.black54, fontSize: 13),
                            ),

                          ],
                        ),
                        const SizedBox(height: 12),

                  ]
                    ),
                  ),
                ),
              ));

          }),
        ],
      ),
    );
  }
}
