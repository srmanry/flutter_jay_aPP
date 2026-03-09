/* import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotem/feature/report/domain/entities/report_coordinate.dart';
import 'package:spotem/feature/report/domain/repo/repo.dart';

class ViewReportByMapController extends GetxController {
  ViewReportByMapController(this.repository);

  final ReportRepository repository;

  final isLoading = false.obs;
  final reports = <ReportCoordinate>[].obs;
  final markers = <Marker>{}.obs;
  final selectedReport = Rxn<ReportCoordinate>();

  @override
  void onInit() {
    super.onInit();
    fetchMarkers();
  }

  Future<void> fetchMarkers() async {
    try {
      isLoading.value = true;
      final result = await repository.getReportCoordinates();
      reports.assignAll(result);

      markers.assignAll(
        result
            .map(
              (report) => Marker(
                markerId: MarkerId("${report.type}_${report.latitude}_${report.longitude}"),
                position: LatLng(report.latitude, report.longitude),
                icon: _getMarkerIcon(report.type),
                infoWindow: InfoWindow(title: report.title, snippet: report.description),
                onTap: () => selectedReport.value = report,
              ),
            )
            .toSet(),
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to load reports");
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
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case "ICE":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }
}

 */