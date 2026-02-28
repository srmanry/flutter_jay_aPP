

import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:spotem/core/network/api_service/token_meneger.dart';

class LocationController extends GetxController {
  var lat = 0.0.obs;
  var lng = 0.0.obs;
  var markers = <Marker>{}.obs;
  var polylines = <Polyline>{}.obs; // RxSet<Polyline>

 
  static const String googleApiKey = "AIzaSyALWWWVRTpQHw1A8okK1Mxx6lCgFRyGRPI";

  final PolylinePoints polylinePoints = PolylinePoints(
    apiKey: googleApiKey,
  );

  var isLoading = false.obs;
  var hasPermission = false.obs;

  var selectedMarkerData = Rx<Map<String, dynamic>?>(null);
  GoogleMapController? mapController;

  Future<void> drawRoute(double destLat, double destLng) async {
    if (lat.value == 0.0 || lng.value == 0.0) {
      await loadLocation();
      if (lat.value == 0.0) {
        // Get.snackbar("লোকেশন", "বর্তমান লোকেশন পাওয়া যায়নি");
        return;
      }
    }

    
    polylines.clear();

    try {
      // নতুন ভার্সনের জন্য PolylineRequest তৈরি করো
      final request = PolylineRequest(
        origin: PointLatLng(lat.value, lng.value),
        destination: PointLatLng(destLat, destLng),
        mode: TravelMode.driving, // driving / walking / bicycling
        // অপশনাল: যদি চাও
        // wayPoints: [PointLatLng(...), ...],
        // avoidHighways: false,
        // avoidTolls: false,
        // avoidFerries: false,
      );

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: request,
        // timeout: Duration(seconds: 30),
      );

      if (result.points.isNotEmpty) {
        List<LatLng> polylineCoordinates = result.points.map((point) => LatLng(point.latitude, point.longitude)).toList();

        final Polyline routePolyline = Polyline(
          polylineId: PolylineId('route_${DateTime.now().millisecondsSinceEpoch}'),
          color: Colors.purpleAccent,
          width: 5,
          points: polylineCoordinates,
          geodesic: true,
        );

        polylines.add(routePolyline);
        polylines.refresh();

        // রুট ফিট করার জন্য ক্যামেরা অ্যাডজাস্ট (অপশনাল কিন্তু ভালো)
        if (mapController != null) {
          final bounds = _getBounds(polylineCoordinates);
          mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
        }
      } else {
        print("================  map  No route found: ${result.errorMessage}");
        // Get.snackbar("রুট", "রুট পাওয়া যায়নি: ${result.errorMessage ?? 'অজানা সমস্যা'}");
        _drawStraightLine(destLat, destLng);
      }
    } catch (e) {
      print("===================== map       Route draw error: $e");
      //Get.snackbar("রুট", "রুট আঁকতে সমস্যা হয়েছে");
      _drawStraightLine(destLat, destLng);
    }
  }

  // সোজা লাইন ফলব্যাক
  void _drawStraightLine(double destLat, double destLng) {
    final Polyline straightLine = Polyline(
      polylineId: const PolylineId('fallback_route'),
      points: [LatLng(lat.value, lng.value), LatLng(destLat, destLng)],
      color: Colors.blue,
      width: 6,
    );
    polylines.add(straightLine);
    polylines.refresh();
  }

  // Bounds ক্যালকুলেট (রুট ফিট করার জন্য)
  LatLngBounds _getBounds(List<LatLng> points) {
    double south = points[0].latitude;
    double north = points[0].latitude;
    double west = points[0].longitude;
    double east = points[0].longitude;

    for (var point in points) {
      if (point.latitude < south) south = point.latitude;
      if (point.latitude > north) north = point.latitude;
      if (point.longitude < west) west = point.longitude;
      if (point.longitude > east) east = point.longitude;
    }

    return LatLngBounds(southwest: LatLng(south, west), northeast: LatLng(north, east));
  }

  // পুরানো decode ফাংশন (যদি কখনো দরকার হয়)
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, lat = 0, lng = 0;

    while (index < encoded.length) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }

  final Dio dioClient = Dio(
    BaseOptions(
      baseUrl: "https://backend-jay-xeye.onrender.com/api/v1",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void onClose() {
    mapController?.dispose();
    mapController = null;
    super.onClose();
  }

  String formatTimestamp(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return "Invalid Date";
    }
  }

  Future<void> loadLocation() async {
    try {
      isLoading.value = true;

      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      lat.value = position.latitude;
      lng.value = position.longitude;

      if (mapController != null) {
        mapController!.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat.value, lng.value), 16));
      }
    } catch (e) {
      print("Error fetching current location: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkPermissionAndLoadLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    hasPermission.value = permission == LocationPermission.always || permission == LocationPermission.whileInUse;

    if (hasPermission.value) {
      await loadLocation();
    } else {
      Get.snackbar("পারমিশন", "লোকেশন পারমিশন দরকার");
    }
  }

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

  // কাস্টম আইকন ফাংশন (যদি ইউজ করো)
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

  Future<void> fetchReportMarker() async {
    isLoading.value = true;

    try {
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
              markerId: MarkerId("${type}_${latValue}_${lngValue}"),
              position: LatLng(latValue, lngValue),
              icon: _getMarkerIcon(type),
              infoWindow: const InfoWindow(title: ''),
              onTap: () {
                final distance = calculateDistance(lat.value, lng.value, latValue, lngValue);
                selectedMarkerData.value = {
                  "title": title,
                  "type": type,
                  "description": description,
                  "time": time,
                  "lat": latValue,
                  "lng": lngValue,
                  "distance": formatDistance(distance),
                  "distanceMeters": distance,
                };
              },
            ),
          );
        }

        if (markers.isNotEmpty && mapController != null) {
          mapController!.animateCamera(CameraUpdate.newLatLngZoom(markers.first.position, 16));
        }
      }
    } catch (e) {
      print("Error fetching report markers: $e");
    } finally {
      isLoading.value = false;
    }
  }

  double calculateDistance(double startLat, double startLng, double endLat, double endLng) {
    if (startLat == 0.0 && startLng == 0.0) return 0.0;
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  String formatDistance(double distanceInMeters) {
    if (distanceInMeters == 0.0) return "Calculating...";
    if (distanceInMeters < 1000) {
      return "${distanceInMeters.toStringAsFixed(0)} মি";
    } else {
      return "${(distanceInMeters / 1000).toStringAsFixed(1)} কি.মি";
    }
  }
}
