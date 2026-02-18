import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotem/feature/new_featuer/presentation/controller/new_feature_controller.dart';

class NewFeatureScreenView extends StatefulWidget {
  const NewFeatureScreenView({super.key});

  @override
  State<NewFeatureScreenView> createState() => _NewFeatureScreenViewState();
}

class _NewFeatureScreenViewState extends State<NewFeatureScreenView> {
  final newFeatureController = Get.put(NewFeatureController());

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
            /*  TextField(
              controller: newFeatureController.titleController,
              decoration: const InputDecoration(labelText: "Title", border: OutlineInputBorder()),
            ), */
            const SizedBox(height: 16),

            /// Description
            TextField(
              controller: newFeatureController.descriptionController,
              decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()),
            ),

            const SizedBox(height: 16),

            Obx(
              () => ElevatedButton(
                onPressed: newFeatureController.isCreateingReport.value
                    ? null
                    : () async {
                        newFeatureController.selectedOption.value = selectedType;

                        bool success = await newFeatureController.createReport(selectedPosition!.latitude, selectedPosition!.longitude);

                        if (success) {
                          setState(() {
                            _markers.add(
                              Marker(
                                markerId: MarkerId(DateTime.now().toString()),
                                position: selectedPosition!,
                                icon: _getMarkerIcon(),
                                infoWindow: InfoWindow(title: selectedType, snippet: newFeatureController.descriptionController.text),
                              ),
                            );
                          });

                          Navigator.pop(context);
                        }
                      },
                child: newFeatureController.isCreateingReport.value ? const CircularProgressIndicator() : const Text("Submit Report"),
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
