
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotem/feature/map/controller/map_controller.dart'; // ধরে নিচ্ছি এটা LocationController
import 'package:spotem/feature/new_featuer/presentation/widgets/report_view_bottom_sheet_widget.dart';

import '../../../home/data/model/reports_model.dart';
import '../../domain/repo/report_repo.dart';
import '../../domain/usecase/report_usecase.dart';

class NewFeatureController extends GetxController {
  final ReportRepo reportRepo;

  NewFeatureController(this.reportRepo);

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  var selectedType = "Fire".obs;
  var isLoading = false.obs;
  var isSubscrib = false.obs;
  var isCreating = false.obs;

  var reports = <ReportModel>[].obs;
  final filterReports = FilterReportsByDistance();
  var selectedReport = Rxn<ReportModel>();

  GoogleMapController? mapController;

  // Custom Marker Icons
  BitmapDescriptor? fireIcon;
  BitmapDescriptor? policeIcon;
  BitmapDescriptor? ambulanceIcon;
  BitmapDescriptor? iceIcon;

  int _markerWidthForPlatform(int baseWidth) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return (baseWidth * 0.6).round();
    }
    return baseWidth;
  }

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  Future<void> _initData() async {
    await loadMarkerIcons();
    await fetchReports();
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  // ===============================
  // Resize Marker Icon
  // ===============================
  Future<BitmapDescriptor> _resizeMarker(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final Uint8List resizedData = (await frameInfo.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedData);
  }

  // ===============================
  // Load Marker Icons
  // ===============================
  Future<void> loadMarkerIcons() async {
    try {
      fireIcon = await _resizeMarker('assets/icons/fire.png', _markerWidthForPlatform(95));
      policeIcon = await _resizeMarker('assets/icons/polic.png', _markerWidthForPlatform(95));
      ambulanceIcon = await _resizeMarker('assets/icons/ambulence.png', _markerWidthForPlatform(110));
      iceIcon = await _resizeMarker('assets/icons/siren.png', _markerWidthForPlatform(90));
    } catch (e) {
      print("Marker load error ===== $e");
    }
  }

  // ===============================
  // Create Report
  // ===============================
  Future<ReportModel?> createReport(double latitude, double longitude) async {
    try {
      isCreating.value = true;

      final report = await reportRepo.createReport(
        title: titleController.text.trim(),
        type: selectedType.value,
        description: descriptionController.text.trim(),
        latitude: latitude,
        longitude: longitude,
      );

     

      titleController.clear();
      descriptionController.clear();

      return report;
    } catch (e) {
      print("Report create error ===== $e");
      return null;
    } finally {
      isCreating.value = false;
    }
  }

  // ===============================
  // Fetch Reports
  // ===============================
  Future<void> fetchReports() async {
    try {
      isLoading.value = true;
      final result = await reportRepo.getReports();
      reports.assignAll(result);
    } catch (e) {
     // Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ==============================
  double calculateDistance(double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  // ==============================
  // Format distance
  // ==============================
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return "${distanceInMeters.toStringAsFixed(0)} M";
    } else {
      return "${(distanceInMeters / 1000).toStringAsFixed(1)} K.M";
    }
  }

  // ===============================
  // Generate Markers
  // ===============================
  Set<Marker> generateMarkers(LatLng userLocation) {
    final filteredReports = filterReports(reports, userLocation, 20500);
    final typeFilteredReports = filteredReports.where((r) => r.type == selectedType.value).toList();

    final Set<Marker> markers = {};

    for (var report in typeFilteredReports.take(50)) {
      final distance = calculateDistance(userLocation.latitude, userLocation.longitude, report.location.lat, report.location.lng);
      final formattedDistance = formatDistance(distance);

      markers.add(
        Marker(
          markerId: MarkerId("${report.id}-${report.title}"),
          position: LatLng(report.location.lat, report.location.lng),
          icon: _getMarkerIcon(report.type),
          onTap: () async {
            final locationController = Get.find<LocationController>();

           
            if (locationController.lat.value == 0.0 && locationController.lng.value == 0.0) {
              await locationController.checkPermissionAndLoadLocation();
            }

            final distance = locationController.calculateDistance(locationController.lat.value, locationController.lng.value, report.location.lat, report.location.lng);
            final formattedDistance = locationController.formatDistance(distance);

            selectedReport.value = report;

            Get.bottomSheet(
              reportViewCustomBottomSheet(
                report,
                distance: formattedDistance,
                onGoPressed: () {
              
                  if (mapController != null) {
                    mapController!.animateCamera(
                      CameraUpdate.newLatLngZoom(
                        LatLng(report.location.lat, report.location.lng),
                        16.0, 
                      ),
                    );
                  } else {
                    print("MapController is null!");
                  }

               
                  try {
                    locationController.drawRoute(report.location.lat, report.location.lng);
                  } catch (e) {
                    print("Error drawing route: $e");
                  }
                },
              ),
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
            );
          },
        ),
      );
    }

    return markers;
  }

  // ===============================
  // Get Marker Icon
  // ===============================
  BitmapDescriptor _getMarkerIcon(String type) {
    switch (type) {
      case "Fire":
        return fireIcon ?? BitmapDescriptor.defaultMarker;
      case "Police":
        return policeIcon ?? BitmapDescriptor.defaultMarker;
      case "Ambulance":
        return ambulanceIcon ?? BitmapDescriptor.defaultMarker;
      case "ICE":
        return iceIcon ?? BitmapDescriptor.defaultMarker;
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }
}
