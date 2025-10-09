import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotem/feature/map/service/location_services.dart';

import '../../../core/network/local/token_manager.dart';

class LocationController extends GetxController {
  var lat = 0.0.obs;
  var lng = 0.0.obs;
  var markers = <Marker>{}.obs;
    var isLoading = false.obs;
  GoogleMapController? mapController;



  final Dio dioClient = Dio(
    BaseOptions(
      baseUrl: "https://backend-jay.onrender.com/api/v1",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> moveCamera() async {
    if (mapController == null) return;
    mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat.value, lng.value), 16),
    );
  }

  Future<void> loadLocation() async {
    final position = await LocationServices().getUserLocation();
    if (position != null) {
      lat.value = position.latitude;
      lng.value = position.longitude;
      await moveCamera();
    }
  }
Future<void> fetchReportMarker() async {
  try {
    isLoading.value = true;

    final token = await TokenManager.getAccessToken();

    final response = await dioClient.get(
      "/report/coordinates",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data['data'] as List;

      // Clear existing markers
      markers.clear();

      for (var report in data) {
        final coords = report['coordinates']; // [longitude, latitude]
        final latValue = coords[1];
        final lngValue = coords[0];
        final type = report['type'] ?? "Report";

        markers.add(Marker(
          markerId: MarkerId("${type}_${latValue}_${lngValue}"),
          position: LatLng(latValue, lngValue),
          infoWindow: InfoWindow(
            title: type,
            snippet: "Lat: $latValue, Lng: $lngValue",
          ),
          icon: _getMarkerIcon(type),
        ));
      }

      // Optionally move camera to first report
      if (markers.isNotEmpty && mapController != null) {
        final firstMarker = markers.first;
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(firstMarker.position, 12),
        );
      }

    } else {
      Get.snackbar("Error", "Failed to fetch report markers");
    }
  } catch (e) {
    Get.snackbar("Error", "Something went wrong: $e");
  } finally {
    isLoading.value = false;
  }
}

// Optional: type অনুযায়ী marker color
BitmapDescriptor _getMarkerIcon(String type) {
  switch (type) {
    case "Fire":
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    case "Police":
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    case "Ambulance":
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    case "ICE":
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    default:
      return BitmapDescriptor.defaultMarker;
  }
}


}
