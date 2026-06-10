import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';

import 'package:spotem/feature/home/data/model/reports_model.dart';
import 'package:spotem/feature/home/domain/repo/home_repo.dart';

class HomeController extends GetxController {
  HomeController(this.repository);

  final HomeRepo repository;

  var isLoading = false.obs;
  var reports = <ReportModel>[].obs;
  var filteredReports = <ReportModel>[].obs;

 /*  @override
  void onInit() {
    super.onInit();
    fetchReports();
    ever(reports, (_) {
      filteredReports.assignAll(reports);
    });
  } */

 @override
void onInit() {
  super.onInit();
  ever(reports, (_) {
    filteredReports.assignAll(reports);
  });
}

@override
void onReady() {
  super.onReady();
  fetchReports();
}

  Future<void> fetchReports() async {
    try {
      isLoading.value = true;
      final result = await repository.getReports();
      final sorted = [...result]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      reports.assignAll(sorted);
    } catch (e) {
     // Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Reverse Geocoding function
  Future<String> getPlaceName(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return "${place.locality ?? place.subAdministrativeArea ?? ''}, ${place.country ?? ''}";
      } else {
        return "Unknown location";
      }
    } catch (e) {
      return "Unknown location";
    }
  }

  void searchByType(String query) {
    if (query.isEmpty) {
      filteredReports.assignAll(reports);
    } else {
      filteredReports.assignAll(
        reports.where((r) {
          return r.type.toLowerCase().contains(query.toLowerCase());
        }).toList(),
      );
    }
  }

  void searchByCategory(String query) {
    if (query.isEmpty) {
      filteredReports.assignAll(reports);
    } else {
      filteredReports.assignAll(
        reports.where((r) {
          return r.type.toLowerCase().contains(query.toLowerCase());
        }).toList(),
      );
    }
  }
}
 
