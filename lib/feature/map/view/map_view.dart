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
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    locationController.hasPermission.value =
        permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
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
            // permission না থাকলে map দেখাবে না
            if (!locationController.hasPermission.value) {
              return const SizedBox.shrink();
            }

            // location load না হলে map দেখাবে না
            if (locationController.lat.value == 0.0 ||
                locationController.lng.value == 0.0) {
              return const SizedBox.shrink();
            }

            // location available, map show
            return GoogleMap(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 12),
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  locationController.lat.value,
                  locationController.lng.value,
                ),
                zoom: 13, // city-level view
              ),
              markers: Set<Marker>.from(locationController.markers),
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              onMapCreated: (controller) async {
                locationController.setMapController(controller);
                await locationController.fetchReportMarker();
                await locationController.fetchNearbyPlaces();

                controller.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(
                      locationController.lat.value,
                      locationController.lng.value,
                    ),
                    13,
                  ),
                );
              },
              onTap: (_) {
                locationController.selectedMarkerData.value = null;
              },
            );
          }),

          Obx(() {
            final data = locationController.selectedMarkerData.value;
            if (data == null) return const SizedBox.shrink();

            Color cardColor;
            IconData cardIcon;
            Color? iconColor;
            Color? textColor;

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
                iconColor = Colors.orange;
                textColor = Colors.orange;
                break;
              default:
                cardColor = Colors.white;
                cardIcon = Icons.location_on_outlined;
                iconColor = const Color(0xFF2B7FD0);
                textColor = const Color(0xFF2B7FD0);
            }

            return Positioned(
              top: 100,
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
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 2,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(cardIcon, color: iconColor, size: 26),
                            const SizedBox(width: 8),
                            Text(
                              data["type"] ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data["title"] ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
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
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.black54,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Time: ${formatTimestamp(data["time"])}",
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          Positioned(
            bottom: 20,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () async {
                if (locationController.lat.value != 0.0 &&
                    locationController.lng.value != 0.0) {
                  locationController.mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      LatLng(
                        locationController.lat.value,
                        locationController.lng.value,
                      ),
                      16,
                    ),
                  );
                }
              },
              child: const Icon(
                Icons.my_location,
                color: Colors.blue,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}











// old code===========
/* String formatTimestamp(String? timestamp) {
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
          Obx(() {
            //if()
            if (locationController.lat.value == 0.0 ||
                locationController.lng.value == 0.0) {
              return Center(child: CircularProgressIndicator());
            }
            return GoogleMap(
              padding: EdgeInsets.symmetric(vertical: 80, horizontal: 12),
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  locationController.lat.value == 0.0
                      ? 0.0
                      : locationController.lat.value,
                  locationController.lng.value == 0.0
                      ? 0.0
                      : locationController.lng.value,
                ),
                zoom: 13,
              ),
              markers: Set<Marker>.from(locationController.markers),
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
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
            );
          }),

          Obx(
            () => locationController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SizedBox.shrink(),
          ),

          Obx(() {
            final data = locationController.selectedMarkerData.value;
            if (data == null) return SizedBox.shrink();

            Color cardColor;
            IconData cardIcon;
            Color? iconColor;
            Color? textColor;

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
                iconColor = Colors.orange;
                textColor = Colors.orange;
                break;
              default:
                cardColor = Colors.white;
                cardIcon = Icons.location_on_outlined;
                iconColor = Color(0xFF2B7FD0);
                textColor = Color(0xFF2B7FD0);
            }

            return Positioned(
              top: 100,
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
                    padding: EdgeInsets.all(16),
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
                              data["type"] ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8),
                        // Title
                        Text(
                          data["title"] ?? "",
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
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.black54,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Time: ${formatTimestamp(data["time"])}",
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          Positioned(
            bottom: 20,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () async {
                if (locationController.lat.value != 0.0 &&
                    locationController.lng.value != 0.0) {
                  locationController.mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      LatLng(
                        locationController.lat.value,
                        locationController.lng.value,
                      ),
                      16,
                    ),
                  );
                }
              },
              child: Icon(Icons.my_location, color: Colors.blue, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
 

 */





/* 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/common/widgets/time_formatting.dart';
import '../../home/controller/home_controller.dart';
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
          Obx(() {
            // Map দেখানোর আগে location load হলে camera সেট হবে
            LatLng initialLatLng = LatLng(
              locationController.lat.value != 0.0
                  ? locationController.lat.value
                  : 0.0,
              locationController.lng.value != 0.0
                  ? locationController.lng.value
                  : 0.0,
            );

            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialLatLng,
                zoom: 14,
              ),
              markers: Set<Marker>.from(locationController.markers),
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              onMapCreated: (controller) async {
                locationController.setMapController(controller);

                // প্রথমে location load কর
                await locationController.loadLocation();

                // যদি valid location থাকে, তখন camera animate কর
                if (locationController.lat.value != 0.0 &&
                    locationController.lng.value != 0.0) {
                  controller.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      LatLng(
                        locationController.lat.value,
                        locationController.lng.value,
                      ),
                      16,
                    ),
                  );
                }

                // Marker ও nearby places load কর
                await locationController.fetchReportMarker();
                await locationController.fetchNearbyPlaces();
              },
              onTap: (_) {
                locationController.selectedMarkerData.value = null;
              },
            );
          }),

          // Loading Indicator
          Obx(
            () => locationController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SizedBox.shrink(),
          ),

          // Marker Info Card
          Obx(() {
            final data = locationController.selectedMarkerData.value;
            if (data == null) return SizedBox.shrink();

            Color cardColor;
            IconData cardIcon;
            Color? iconColor;
            Color? textColor;

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
                iconColor = Colors.orange;
                textColor = Colors.orange;
                break;
              default:
                cardColor = Colors.white;
                cardIcon = Icons.location_on_outlined;
                iconColor = Color(0xFF2B7FD0);
                textColor = Color(0xFF2B7FD0);
            }

            return Positioned(
              top: 100,
              left: 20,
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 2,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(cardIcon, color: iconColor, size: 26),
                            SizedBox(width: 8),
                            Text(
                              data["type"] ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          data["title"] ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
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
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.black54,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Time: ${formatTimestamp(data["time"])}",
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          // My Location Button
          Positioned(
            bottom: 20,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () async {
                if (locationController.lat.value != 0.0 &&
                    locationController.lng.value != 0.0) {
                  locationController.mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      LatLng(
                        locationController.lat.value,
                        locationController.lng.value,
                      ),
                      16,
                    ),
                  );
                }
              },
              child: Icon(Icons.my_location, color: Colors.blue, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
 */