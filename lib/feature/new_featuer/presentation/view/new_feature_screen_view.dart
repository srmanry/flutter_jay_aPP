import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controller/new_feature_controller.dart';
import 'dart:math';

class NewFeatureScreen extends StatefulWidget {
  const NewFeatureScreen({super.key});

  @override
  State<NewFeatureScreen> createState() => _NewFeatureScreenState();
}

class _NewFeatureScreenState extends State<NewFeatureScreen> {
  final controller = Get.find<NewFeatureController>();
  Set<Marker> markers = {};
  LatLng? selectedPosition;

  // User location
  LatLng userLocation = const LatLng(23.8103, 90.4125); // default Dhaka

  @override
  void initState() {
    super.initState();
    controller.fetchReports().then((_) => _addMarkers());
    controller.reports.listen((_) {
      if (!mounted) return;
      _addMarkers();
    });
  }

  // Haversine formula for distance in meters
  double _distanceInMeters(LatLng p1, LatLng p2) {
    const double R = 6371000; // Earth radius in meters
    final dLat = _degToRad(p2.latitude - p1.latitude);
    final dLng = _degToRad(p2.longitude - p1.longitude);
    final a = sin(dLat / 2) * sin(dLat / 2) + cos(_degToRad(p1.latitude)) * cos(_degToRad(p2.latitude)) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double deg) => deg * pi / 180;

  void _addMarkers() {
    if (!mounted) return;

    markers.clear();
    int count = 0;
    const maxDistance = 20500; // 1.5 km

    for (var report in controller.reports) {
      final reportPos = LatLng(report.location.lat, report.location.lng);
      final distance = _distanceInMeters(userLocation, reportPos);

      // Only add markers within 1.5 km
      if (distance <= maxDistance) {
        markers.add(
          Marker(
            markerId: MarkerId("${report.id}-${report.title}"),
            position: reportPos,
            icon: _getMarkerIcon(report.type),
            infoWindow: InfoWindow(title: report.title, snippet: report.description),
          ),
        );
        count++;
      }

      // Safety: max 50 markers to prevent crash
      if (count >= 50) break;
    }

    setState(() {});
  }

  BitmapDescriptor _getMarkerIcon(String type) {
    switch (type) {
      case "Fire":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case "Police":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case "Ambulance":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case "ICE":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  void _onMapTap(LatLng position) {
    selectedPosition = position;
    _showBottomSheet();
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: _buildBottomSheet(),
      ),
    );
  }

  Widget _buildTypeButton(String type, Color color) {
    return Obx(() {
      final isSelected = controller.selectedType.value == type;

      return GestureDetector(
        onTap: () => controller.selectedType.value = type,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.0) : null,
            borderRadius: BorderRadius.circular(10),
            border: isSelected ? Border.all(color: color, width: 2) : null,
          ),
          child: Icon(Icons.location_on, color: isSelected ? color : color, size: 25),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: userLocation, zoom: 14),
            markers: markers,
            onTap: _onMapTap,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            right: 16,
            top: 100,
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTypeButton("Fire", Colors.red),
                    const SizedBox(height: 8),
                    _buildTypeButton("Police", Colors.blue),
                    const SizedBox(height: 8),
                    _buildTypeButton("Ambulance", Colors.orange),
                    const SizedBox(height: 8),
                    _buildTypeButton("ICE", Colors.green),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Drag Handle
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),

            /// Title
            //   Text("Create Report", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Obx(
              () =>
                  Text("Create ${controller.selectedType.value} Report", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),

            /// Title Field
            TextField(
              controller: controller.titleController,
              decoration: InputDecoration(
                labelText: "Report Title",
                prefixIcon: const Icon(Icons.title),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 15),

            /// Description Field
            TextField(
              controller: controller.descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Description",
                prefixIcon: const Icon(Icons.description),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 25),

            /// Submit Button
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          if (selectedPosition == null) return;

                          final report = await controller.createReport(selectedPosition!.latitude, selectedPosition!.longitude);

                          if (report != null && mounted) {
                            Navigator.pop(context);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.zero,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Colors.blue, Colors.blueAccent]),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Submit Report",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* Widget _buildBottomSheet() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          
          Color textColor;
          switch (controller.selectedType.value) {
            case "Fire":
              textColor = Colors.red;
              break;
            case "Police":
              textColor = Colors.blue;
              break;
            case "Ambulance":
              textColor = Colors.orange;
              break;
            case "ICE":
              textColor = Colors.green;
              break;
            default:
              textColor = Colors.black;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create ${controller.selectedType.value} Report",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor, // type অনুযায়ী color
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller.titleController,
                decoration: const InputDecoration(labelText: "Title", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller.descriptionController,
                decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          if (selectedPosition == null) return;
                          final report = await controller.createReport(selectedPosition!.latitude, selectedPosition!.longitude);
                          if (report != null && mounted) Navigator.pop(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // button color fixed
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: controller.isLoading.value ? const CircularProgressIndicator(color: Colors.white) : const Text("Submit"),
                ),
              ),
            ],
          );
        }),
      ),
    ); */
  // }
}
