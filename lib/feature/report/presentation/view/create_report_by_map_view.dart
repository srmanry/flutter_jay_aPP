/* 

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateReportByMapView extends StatefulWidget {
  const CreateReportByMapView({super.key});

  @override
  State<CreateReportByMapView> createState() => _CreateReportByMapViewState();
}

class _CreateReportByMapViewState extends State<CreateReportByMapView> {
  Set<Marker> _markers = {};
  String selectedType = "Fire";
  LatLng? selectedPosition;

  BitmapDescriptor _getMarkerIcon() {
    switch (selectedType) {
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

    showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => _buildReportSheet());
  }

  Widget _buildReportSheet() {
    TextEditingController descriptionController = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Create $selectedType Report", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _markers.add(
                    Marker(
                      markerId: MarkerId(DateTime.now().toString()),
                      position: selectedPosition!,
                      icon: _getMarkerIcon(),
                      infoWindow: InfoWindow(title: selectedType, snippet: descriptionController.text),
                    ),
                  );
                });

                Navigator.pop(context);
              },
              child: const Text("Submit Report"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ///  Google Map
          GoogleMap(
            initialCameraPosition: const CameraPosition(target: LatLng(23.8103, 90.4125), zoom: 12),
            markers: _markers,
            onTap: _onMapTap,
          ),

          ///  Right Marker Selector
          Positioned(
            right: 16,
            top: 150,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
              ),
              child: Column(
                children: [
                  _buildTypeButton("ICE", Colors.green),
                  _buildTypeButton("Fire", Colors.red),
                  _buildTypeButton("Police", Colors.blue),
                  _buildTypeButton("Ambulance", Colors.orange),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton(String type, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Icon(Icons.location_on, color: selectedType == type ? color : color.withOpacity(0.4), size: 32),
      ),
    );
  }
}
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:spotem/feature/report/presentation/controller/create_report_map_controller.dart';

class CreateReportByMapView extends StatefulWidget {
  const CreateReportByMapView({super.key});

  @override
  State<CreateReportByMapView> createState() => _CreateReportByMapViewState();
}

class _CreateReportByMapViewState extends State<CreateReportByMapView> {
  final ReportControllerByMap reportController = Get.put(ReportControllerByMap());

  Set<Marker> _markers = {};
  String selectedType = "Fire";
  LatLng? selectedPosition;

  BitmapDescriptor _getMarkerIcon() {
    switch (selectedType) {
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
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => _buildReportSheet());
  }

  Widget _buildReportSheet() {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Create $selectedType Report", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            /// Title
            TextField(
              controller: reportController.titleController,
              decoration: const InputDecoration(labelText: "Title", border: OutlineInputBorder()),
            ),

            const SizedBox(height: 16),

            /// Description
            TextField(
              controller: reportController.descriptionController,
              decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()),
            ),

            const SizedBox(height: 16),

            /// Submit Button
            Obx(
              () => ElevatedButton(
                onPressed: reportController.isCreateingReport.value
                    ? null
                    : () async {
                        reportController.selectedOption.value = selectedType;

                        bool success = await reportController.createReport(selectedPosition!.latitude, selectedPosition!.longitude);

                        if (success) {
                          setState(() {
                            _markers.add(
                              Marker(
                                markerId: MarkerId(DateTime.now().toString()),
                                position: selectedPosition!,
                                icon: _getMarkerIcon(),
                                infoWindow: InfoWindow(title: selectedType, snippet: reportController.descriptionController.text),
                              ),
                            );
                          });

                          Navigator.pop(context);
                        }
                      },
                child: reportController.isCreateingReport.value ? const CircularProgressIndicator() : const Text("Submit Report"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String type, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Icon(Icons.location_on, color: selectedType == type ? color : color.withOpacity(0.4), size: 32),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(target: LatLng(23.8103, 90.4125), zoom: 12),
            markers: _markers,
            onTap: _onMapTap,
          ),

          /// Right Side Selector
          Positioned(
            right: 16,
            top: 150,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
              ),
              child: Column(
                children: [
                  _buildTypeButton("ICE", Colors.green),
                  _buildTypeButton("Fire", Colors.red),
                  _buildTypeButton("Police", Colors.blue),
                  _buildTypeButton("Ambulance", Colors.orange),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
