import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotem/core/utils/app_colors.dart';
import 'package:spotem/feature/alert/controller/alert_controller.dart';
import 'package:spotem/feature/alert/model/alert_model.dart';

class AlertMapScreen extends StatelessWidget {
  final AlertController controller = Get.find<AlertController>();

  AlertMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios_rounded),
        ),
        centerTitle: true,
        title: const Text("Alert Map"),
      ),
      body: Obx(() {
        final alerts = controller.alerts.value.data;

        if (alerts.isEmpty) {
          return const Center(child: Text("No alerts found!"));
        }

        // ✅ প্রথম alert এর location নাও initial position হিসেবে
        final first = alerts.first;
        final double initialLat =
            first.location.coordinates[1] ?? first.location.coordinates[1];
        final double initialLng =
            first.location.coordinates[0] ?? first.location.coordinates[0];

        // ✅ সব alert marker তৈরি করো
        final Set<Marker> markers = alerts.map((alert) {
          final lat = alert.location.coordinates[1] ?? alert.location.coordinates[1];
          final lng = alert.location.coordinates[0] ?? alert.location.coordinates[0];

          return Marker(
            markerId: MarkerId(alert.id),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: alert.report?.title ?? alert.type.value,
              snippet: alert.report?.description ?? "",
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          );
        }).toSet();

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(initialLat, initialLng),
            zoom: 13,
          ),
          markers: markers,
          mapType: MapType.normal,
          zoomControlsEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        );
      }),
    );
  }
}
