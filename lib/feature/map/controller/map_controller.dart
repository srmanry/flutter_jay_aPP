import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:spotem/core/network/api_service/token_meneger.dart';

import '../service/location_services.dart';

class LocationController extends GetxController {
  var lat = 0.0.obs;
  var lng = 0.0.obs;
  var markers = <Marker>{}.obs;
  var isLoading = false.obs;
  var hasPermission = false.obs;
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
      baseUrl: "https://backend-jay-xeye.onrender.com",
      // baseUrl: "https://api.spotem365.com/api/v1",
      // baseUrl: "http://localhost:8001/api/v1",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> moveCamera() async {
    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat.value, lng.value), 16));
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

      final token = await TokenManager.getToken();

      final response = await dioClient.get(
        "/report/coordinates",
        options: Options(headers: {"Authorization": "Bearer $token"}, validateStatus: (status) => status != null && status < 500),
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
              //   consumeTapEvents: true,
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
          mapController?.animateCamera(CameraUpdate.newLatLngZoom(markers.first.position, 16));
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

  // old=============
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

  Future<BitmapDescriptor> getMarkerFromIcon(IconData iconData, Color color) async {
    const size = 40.0;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final textPainter = TextPainter(textDirection: ui.TextDirection.ltr);

    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(fontSize: size, fontFamily: iconData.fontFamily, color: color),
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  Future<void> fetchNearbyPlaces() async {
    const apiKey = "AIzaSyALWWWVRTpQHw1A8okK1Mxx6lCgFRyGRPI";
    final types = ["hospital", "police", "fire_station"];

    for (var type in types) {
      final url =
          "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${lat.value},${lng.value}&radius=3000&type=$type&key=$apiKey";

      try {
        final response = await Dio().get(url);
        if (response.statusCode == 200 && response.data["results"] != null) {
          final results = response.data["results"] as List;

          for (var place in results) {
            final name = place["name"] ?? type.capitalizeFirst!;
            final geometry = place["geometry"]["location"];
            final placeLat = geometry["lat"];
            final placeLng = geometry["lng"];

            BitmapDescriptor icon;
            switch (type) {
              case "hospital":
                icon = await getMarkerFromIcon(Icons.local_hospital_outlined, Colors.pink);
                break;
              case "police":
                icon = await getMarkerFromIcon(Icons.local_police, Colors.blue);
                break;
              case "fire_station":
                icon = await getMarkerFromIcon(Icons.local_fire_department, Colors.red);
                break;
              default:
                icon = BitmapDescriptor.defaultMarker;
            }

            markers.add(
              Marker(
                markerId: MarkerId("${type}_${placeLat}_$placeLng"),
                position: LatLng(placeLat, placeLng),
                icon: icon,
                infoWindow: InfoWindow(title: name),
                onTap: () {
                  selectedMarkerData.value = {
                    "title": name,
                    "type": type.capitalizeFirst,
                    "lat": placeLat,
                    "lng": placeLng,
                    "time": DateTime.now().toString(),
                  };
                },
              ),
            );
          }
        }
      } catch (e) {
        print("Error fetching $type places: $e");
      }
    }

    markers.refresh();
  }

  //  Permission check + load location
  Future<void> checkPermissionAndLoadLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    hasPermission.value = permission == LocationPermission.always || permission == LocationPermission.whileInUse;

    if (hasPermission.value) {
      await loadLocation();
    }
  }
}
