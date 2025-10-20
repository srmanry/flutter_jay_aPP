import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:spotem/feature/map/service/location_services.dart';
import '../../../core/service/local/token_manager.dart';

class LocationController extends GetxController {
  var lat = 0.0.obs;
  var lng = 0.0.obs;
  var markers = <Marker>{}.obs;
  var isLoading = false.obs;
  GoogleMapController? mapController;
  var selectedMarkerData = Rx<Map<String, dynamic>?>(null);


  String formatTimestamp(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return "Invalid Date";
    }
  }

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
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(lat.value, lng.value), 16),
      );
    }
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
        markers.clear();

        for (var report in data) {
          final coords = report['coordinates'];
          final latValue = coords[1];
          final lngValue = coords[0];
          final type = report['type'] ?? "Report";
          final title = report['title'] ?? "Report";
          final description = report['description'] ?? "Report";
          final time = report['timestamp'] ?? "Report";

          markers.add(
            Marker(
              markerId: MarkerId("${type}_${latValue}_${lngValue}"),
              position: LatLng(latValue, lngValue),
              icon: _getMarkerIcon(type),
              infoWindow: const InfoWindow(title: ''),
              onTap: () {
                selectedMarkerData.value = {
                  "title": title,
                  "type": type,
                  "description": description,
                  "time": time,
                  "lat": latValue,
                  "lng": lngValue,
                };
              },
            ),
          );



        }


        if (markers.isNotEmpty) {
          mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(markers.first.position, 16),
          );
        }
      } else {
        //Get.snackbar("Error", "Failed to fetch report markers");
      }
    } catch (e) {
     // Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

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
