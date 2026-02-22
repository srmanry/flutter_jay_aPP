import 'package:flutter/material.dart';
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

  /*   Set<Marker> generateMarkers(LatLng userLocation) {
  final filteredReports =
      filterReports(reports, userLocation, 20500);

  final Set<Marker> markers = {};

  for (var report in filteredReports.take(50)) {
    markers.add(
      Marker(
        markerId: MarkerId("${report.id}-${report.title}"),
        position: LatLng(
            report.location.lat,
            report.location.lng),
        icon: _getMarkerIcon(report.type),
        infoWindow: InfoWindow(
          title: report.title,
          snippet: report.description,
        ),
      ),
    );
  }

  return markers;
} */

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
