

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
    setState(() {
      selectedPosition = position;
    });

    _showReportBottomSheet();
  }

  void _showReportBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _buildReportContent(),
        );
      },
    );
  }

  Widget _buildReportContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Report $selectedType Incident", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),

                // Description field
                TextField(
                  controller: newFeatureController.descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Describe what happened, location details, severity etc...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  maxLines: 6,
                  minLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                ),

                const SizedBox(height: 32),

                // Buttons
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: newFeatureController.isCreateingReport.value
                          ? null
                          : () async {
                              newFeatureController.selectedOption.value = selectedType;

                              final success = await newFeatureController.createReport(
                                selectedPosition!.latitude,
                                selectedPosition!.longitude,
                              );

                              if (success) {
                                setState(() {
                                  _markers.add(
                                    Marker(
                                      markerId: MarkerId(DateTime.now().toString()),
                                      position: selectedPosition!,
                                      icon: _getMarkerIcon(),
                                      infoWindow: InfoWindow(
                                        title: selectedType,
                                        snippet: newFeatureController.descriptionController.text.trim(),
                                      ),
                                    ),
                                  );
                                });
                                if (mounted) Navigator.pop(context);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getButtonColor(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      child: newFeatureController.isCreateingReport.value
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                          : Text("Submit $selectedType Report", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel", style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getButtonColor() {
    switch (selectedType) {
      case "Fire":
        return Colors.red.shade700;
      case "Police":
        return Colors.blue.shade700;
      case "Ambulance":
        return Colors.orange.shade700;
      case "ICE":
        return Colors.green.shade700;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Widget _buildTypeButton(String type, Color color) {
    final isSelected = selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),

        //margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : null,
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? Border.all(color: color, width: 2) : null,
        ),
        child: Icon(Icons.location_on, color: isSelected ? color : color.withOpacity(0.5), size: 25),
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
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),

          // Type selector panel
          Positioned(
            right: 16,
            top: 100,
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Column(
                  spacing: 20,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTypeButton("Fire", Colors.red),
                    _buildTypeButton("Police", Colors.blue),
                    _buildTypeButton("Ambulance", Colors.orange),
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
}
