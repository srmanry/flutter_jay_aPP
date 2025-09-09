import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:spotem/feature/map/controller/map_controller.dart';


class MapScreenView extends StatelessWidget {
  MapScreenView({super.key});

  final locationController = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Map View"), elevation: 0),
      body: Obx(() {
        // যদি location নাও, loading দেখাও
        if (!locationController.isPermissionGranted.value ||
            locationController.latitude.value == 0.0) {
          return const Center(child: CircularProgressIndicator());
        }

        LatLng userLatLng = LatLng(
            locationController.latitude.value, locationController.longitude.value);

        return FlutterMap(
          options: MapOptions(
          /*  center: userLatLng,
            zoom: 15,*/
          ),
          children: [
           /* TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.example.app',
            ),*/
            MarkerLayer(
              markers: [
                Marker(
                  point: userLatLng,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.my_location,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await locationController.requestLocationPermission(context);
        },
        child: const Icon(Icons.gps_fixed),
      ),
    );
  }
}
