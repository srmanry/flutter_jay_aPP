import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:spotem/feature/report/domain/repo/repo.dart';

class LocationController extends GetxController {
  LocationController(this.reportRepository);

  final ReportRepository reportRepository;

  var lat = 0.0.obs;
  var lng = 0.0.obs;
  var markers = <Marker>{}.obs;
  var polylines = <Polyline>{}.obs; // RxSet<Polyline>

  static const String googleApiKey = "AIzaSyALWWWVRTpQHw1A8okK1Mxx6lCgFRyGRPI";

  final PolylinePoints polylinePoints = PolylinePoints(apiKey: googleApiKey);

  var isLoading = false.obs;
  var hasPermission = false.obs;

  var selectedMarkerData = Rx<Map<String, dynamic>?>(null);
  GoogleMapController? mapController;

  BitmapDescriptor? fireIcon;
  BitmapDescriptor? policeIcon;
  BitmapDescriptor? ambulanceIcon;
  BitmapDescriptor? iceIcon;

  @override
  void onInit() {
    super.onInit();
    loadMarkerIcons();
  }

  Future<void> drawRoute(double destLat, double destLng) async {
    if (lat.value == 0.0 || lng.value == 0.0) {
      await loadLocation();
      if (lat.value == 0.0) {
        return;
      }
    }

    polylines.clear();

    try {
      // ignore: deprecated_member_use
      final request = PolylineRequest(
        origin: PointLatLng(lat.value, lng.value),
        destination: PointLatLng(destLat, destLng),
        mode: TravelMode.driving, // driving / walking / bicycling
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

        if (mapController != null) {
          final bounds = _getBounds(polylineCoordinates);
          mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
        }
      } else {
        debugPrint("================  map  No route found: ${result.errorMessage}");

        _drawStraightLine(destLat, destLng);
      }
    } catch (e) {
      debugPrint("===================== map       Route draw error: $e");

      _drawStraightLine(destLat, destLng);
    }
  }

  void clearRoute() {
    polylines.clear();
    polylines.refresh();
    selectedMarkerData.value = null;
  }

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

      final position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
      lat.value = position.latitude;
      lng.value = position.longitude;

      if (mapController != null) {
        mapController!.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat.value, lng.value), 16));
      }
    } catch (e) {
      debugPrint("Error fetching current location: $e");
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

  Future<void> loadMarkerIcons() async {
    try {
      // Marker icon sizes (px). Kept small to avoid oversized markers on map.
      fireIcon = await _resizeMarker('assets/icons/fire.png', 44);
      policeIcon = await _resizeMarker('assets/icons/polic.png', 44);
      ambulanceIcon = await _resizeMarker('assets/icons/ambulence.png', 50);
      iceIcon = await _resizeMarker('assets/icons/siren.png', 40);
    } catch (_) {
      // Fallback to default markers if assets fail to load.
    }
  }

  Future<BitmapDescriptor> _resizeMarker(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final Uint8List resizedData = (await frameInfo.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    return BitmapDescriptor.bytes(resizedData);
  }

  BitmapDescriptor _getMarkerIcon(String type) {
    switch (type) {
      case "Fire":
        return fireIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case "Police":
        return policeIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case "Ambulance":
        return ambulanceIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case "ICE":
        return iceIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  Future<BitmapDescriptor> getMarkerFromIcon(IconData iconData, Color color) async {
    const size = 20.0;
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

    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }

  Future<void> fetchReportMarker() async {
    isLoading.value = true;

    try {
      // Ensure marker icons are ready.
      if (fireIcon == null && policeIcon == null && ambulanceIcon == null && iceIcon == null) {
        await loadMarkerIcons();
      }

      final data = await reportRepository.getReportCoordinates();

      markers.clear();
      for (final report in data) {
        final type = report.type.isEmpty ? "Report" : report.type;
        final title = report.title.isEmpty ? "Report" : report.title;
        final description = report.description.isEmpty ? "Report" : report.description;
        final time = report.createdAt?.toIso8601String() ?? "";

        final latValue = report.latitude;
        final lngValue = report.longitude;

        markers.add(
          Marker(
            markerId: MarkerId('${type}_${latValue}_$lngValue'),
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
      markers.refresh();

      if (markers.isNotEmpty && mapController != null) {
        mapController!.animateCamera(CameraUpdate.newLatLngZoom(markers.first.position, 14));
      }
    } catch (e) {
      debugPrint("Error fetching report markers: $e");
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
    final meters = distanceInMeters.round();
    final km = distanceInMeters / 1000.0;
    return "${km.toStringAsFixed(2)} KM / $meters m";
  }
}
