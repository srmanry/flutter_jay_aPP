import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotem/feature/map/controller/map_controller.dart';


class GoogleMapScreen extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());

  GoogleMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Map"), elevation: 0),
      body: Obx(() {
        if (!locationController.isPermissionGranted.value ||
            locationController.latitude.value == 0.0) {
          return Center(child: CircularProgressIndicator());
        }

        LatLng userLatLng = LatLng(
          locationController.latitude.value,
          locationController.longitude.value,
        );

        // Markers: user + reports
        Set<Marker> markers = {
          Marker(
            markerId: MarkerId('user'),
            position: userLatLng,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: InfoWindow(title: "You are here"),
          ),
        };

        markers.addAll(locationController.reports.map((report) {
          return Marker(
            markerId: MarkerId(report.title),
            position: LatLng(report.latitude, report.longitude),
            infoWindow: InfoWindow(title: report.title, snippet: report.description),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          );
        }));

        return GoogleMap(
          initialCameraPosition: CameraPosition(target: userLatLng, zoom: 15),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: markers,
        );
      }),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "permission",
            onPressed: () => locationController.requestLocationPermission(context),
            child: Icon(Icons.gps_fixed),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "report",
            onPressed: () async {
              // Example: Create a report
              await locationController.createReport(
                  "New Report", "This is a test report");
              Get.snackbar("Report Added", "Report location saved on map");
            },
            child: Icon(Icons.report),
          ),
        ],
      ),
    );
  }
}
