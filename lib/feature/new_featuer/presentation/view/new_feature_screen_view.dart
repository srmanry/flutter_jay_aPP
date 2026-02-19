import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controller/new_feature_controller.dart';

class NewFeatureScreen extends StatefulWidget {
  const NewFeatureScreen({super.key});

  @override
  State<NewFeatureScreen> createState() => _NewFeatureScreenState();
}

class _NewFeatureScreenState extends State<NewFeatureScreen> {
  final controller = Get.find<NewFeatureController>();

  Set<Marker> markers = {};
  LatLng? selectedPosition;

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

  Widget _buildBottomSheet() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          if (selectedPosition == null) return;

                          final report = await controller.createReport(selectedPosition!.latitude, selectedPosition!.longitude);

                          if (report != null) {
                            setState(() {
                              markers.add(
                                Marker(
                                  markerId: MarkerId(report.title),
                                  position: LatLng(report.location.lat, report.location.lng),
                                  icon: _getMarkerIcon(report.type),
                                  infoWindow: InfoWindow(title: report.title, snippet: report.description),
                                ),
                              );
                            });

                            Navigator.pop(context);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: controller.isLoading.value ? const CircularProgressIndicator(color: Colors.white) : const Text("Submit"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String type, Color color) {
    final isSelected = controller.selectedType.value == type;
    return GestureDetector(
      onTap: () => controller.selectedType.value = type,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
}
