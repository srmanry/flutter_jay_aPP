/* import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotem/feature/home/data/model/reports_model.dart';
import 'package:spotem/feature/new_featuer/domain/usecase/report_usecase.dart';

import '../../domain/repo/report_repo.dart';

class NewFeatureController extends GetxController {
  final ReportRepo reportRepo;

  NewFeatureController(this.reportRepo);

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  var selectedType = "Fire".obs;
  var isLoading = false.obs;

  var reports = <ReportModel>[].obs;
  final filterReports = FilterReportsByDistance();

  Future<ReportModel?> createReport(double latitude, double longitude) async {
    try {
      isLoading.value = true;

      final report = await reportRepo.createReport(
        title: titleController.text.trim(),
        type: selectedType.value,
        description: descriptionController.text.trim(),
        latitude: latitude,
        longitude: longitude,
      );

      if (report != null) {
        reports.insert(0, report);
        reports.refresh();
      }

      titleController.clear();
      descriptionController.clear();

      return report;
    } catch (e) {
      // Get.snackbar(backgroundColor: Colors.green, "Error", e.toString());
      print("report create error ======================$e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchReports() async {
    try {
      isLoading.value = true;
      final result = await reportRepo.getReports();
      reports.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print(" ===================.report get error ================== $e");
    } finally {
      isLoading.value = false;
    }
  }

  Set<Marker> generateMarkers(LatLng userLocation) {
    // Distance filter
    final filteredReports = filterReports(reports, userLocation, 20500);

    // Type filter
    final typeFilteredReports = filteredReports.where((r) => r.type == selectedType.value).toList();

    final Set<Marker> markers = {};

    for (var report in typeFilteredReports.take(50)) {
      markers.add(
        Marker(
          markerId: MarkerId("${report.id}-${report.title}"),
          position: LatLng(report.location.lat, report.location.lng),
          icon: _getMarkerIcon(report.type),
          infoWindow: InfoWindow(title: report.title, snippet: report.description),
        ),
      );
    }

    return markers;
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
}
 */ /* 

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  var reports = <ReportModel>[].obs;
  final filterReports = FilterReportsByDistance();

  // Custom Marker Icons
  BitmapDescriptor? fireIcon;
  BitmapDescriptor? policeIcon;
  BitmapDescriptor? ambulanceIcon;
  BitmapDescriptor? iceIcon;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  Future<void> _initData() async {
    await loadMarkerIcons();
    await fetchReports();
  }

  // =========================
  // Load Custom Marker Icons
  // =========================
  Future<void> loadMarkerIcons() async {
    try {
      fireIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 1.0), 'assets/icons/fire.png');

      policeIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 1.0), 'assets/icons/police.png');

      ambulanceIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 1.0), 'assets/icons/ambulance.png');

      iceIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 1.0), 'assets/icons/mapIcon.png');
    } catch (e) {
      print("Marker load error ===== $e");
    }
  }

  // =========================
  // Create Report
  // =========================
  Future<ReportModel?> createReport(double latitude, double longitude) async {
    try {
      isLoading.value = true;

      final report = await reportRepo.createReport(
        title: titleController.text.trim(),
        type: selectedType.value,
        description: descriptionController.text.trim(),
        latitude: latitude,
        longitude: longitude,
      );

      if (report != null) {
        reports.insert(0, report);
      }

      titleController.clear();
      descriptionController.clear();

      return report;
    } catch (e) {
      print("Report create error ===== $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // Fetch Reports
  // =========================
  Future<void> fetchReports() async {
    try {
      isLoading.value = true;
      final result = await reportRepo.getReports();
      reports.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // Generate Markers
  // =========================
  Set<Marker> generateMarkers(LatLng userLocation) {
    final filteredReports = filterReports(reports, userLocation, 20500);

    final typeFilteredReports = filteredReports.where((r) => r.type == selectedType.value).toList();

    final Set<Marker> markers = {};

    for (var report in typeFilteredReports.take(50)) {
      markers.add(
        Marker(
          markerId: MarkerId("${report.id}-${report.title}"),
          position: LatLng(report.location.lat, report.location.lng),
          icon: _getMarkerIcon(report.type),
          infoWindow: InfoWindow(title: report.title, snippet: report.description),
        ),
      );
    }

    return markers;
  }

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
}
 */

import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  // Custom Marker Icons
  BitmapDescriptor? fireIcon;
  BitmapDescriptor? policeIcon;
  BitmapDescriptor? ambulanceIcon;
  BitmapDescriptor? iceIcon;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  Future<void> _initData() async {
    await loadMarkerIcons();
    await fetchReports();
  }

  // ===============================
  // Resize Marker Icon (IMPORTANT)
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
      fireIcon = await _resizeMarker('assets/icons/fire.png', 95);
      policeIcon = await _resizeMarker('assets/icons/polic.png', 95);
      ambulanceIcon = await _resizeMarker('assets/icons/ambulence.png', 110);
      iceIcon = await _resizeMarker('assets/icons/siren.png', 90);
    } catch (e) {
      print("Marker load error ===== $e");
    }
  }

  // ===============================
  // Create Report
  // ===============================
  Future<ReportModel?> createReport(double latitude, double longitude) async {
    try {
      isLoading.value = true;

      final report = await reportRepo.createReport(
        title: titleController.text.trim(),
        type: selectedType.value,
        description: descriptionController.text.trim(),
        latitude: latitude,
        longitude: longitude,
      );

      if (report != null) {
        reports.insert(0, report);
      }

      titleController.clear();
      descriptionController.clear();

      return report;
    } catch (e) {
      print("Report create error ===== $e");
      return null;
    } finally {
      isLoading.value = false;
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
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ==============================
  // Calculate distance between two points (in meters)
  // ==============================
  double calculateDistance(double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  // ==============================
  // Format distance for display
  // ==============================
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return "${distanceInMeters.toStringAsFixed(0)} মি";
    } else {
      return "${(distanceInMeters / 1000).toStringAsFixed(1)} কি.মি";
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
      // Calculate distance from user location to this report
      final distance = calculateDistance(userLocation.latitude, userLocation.longitude, report.location.lat, report.location.lng);
      final formattedDistance = formatDistance(distance);

      markers.add(
        Marker(
          markerId: MarkerId("${report.id}-${report.title}"),
          position: LatLng(report.location.lat, report.location.lng),
          icon: _getMarkerIcon(report.type),
          //infoWindow: InfoWindow(title: report.title, snippet: report.description),
          onTap: () {
            selectedReport.value = report;
            Get.bottomSheet(
              reportViewCustomBottomSheet(report, distance: formattedDistance),
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
}
