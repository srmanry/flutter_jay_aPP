import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotem/feature/map/controller/map_controller.dart';


class GoogleMapScreen extends StatelessWidget {
  //final locationController = Get.find<LocationController>();
  final LocationController locationController  = Get.put(LocationController());

  GoogleMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Map"),elevation: 0,),
      body: Obx(() {
        if (!locationController.isPermissionGranted.value ||
            locationController.latitude.value == 0.0) {
          return Center(child: CircularProgressIndicator());
        }

        LatLng userLatLng = LatLng(
          locationController.latitude.value,
          locationController.longitude.value,
        );

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: userLatLng,
            zoom: 15,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: {
            Marker(
              markerId: MarkerId('user'),
              position: userLatLng,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            ),
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await locationController.requestLocationPermission(context);
        },
        child: Icon(Icons.gps_fixed),
      ),
    );
  }
}
