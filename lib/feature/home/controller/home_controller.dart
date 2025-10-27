
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

import '../../../core/service/local/token_manager.dart';
import '../model/reports_model.dart';

class HomeController extends GetxController {
  final RxInt currentIndex = 0.obs;
  var isLoading = false.obs;
  var reports = <ReportModel>[].obs;
  var filteredReports = <ReportModel>[].obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    fetchReports();
    ever(reports, (_) {
      filteredReports.assignAll(reports);
    });
  }

  final dio.Dio dioClient = dio.Dio(
    dio.BaseOptions(

      //baseUrl: "https://api.spotem365.com/api/v1",
      baseUrl: "https://backend-jay.onrender.com/api/v1",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  Future<void> fetchReports() async {
    try {
      isLoading.value = true;
      final token = await TokenManager.getAccessToken();
      final response = await dioClient.get(
        '/report',
        options: dio.Options(
          headers: {"Authorization": "Bearer $token"},
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      if (response.statusCode == 200 && response.data["success"] == true) {
        final List<dynamic> reportList = response.data["data"];
        reports.value = reportList
            .map((x) => ReportModel.fromJson(x as Map<String, dynamic>))
            .toList();
        filteredReports.assignAll(reports);
      } else {
        print("Reports API Error: ${response.data}");
      }
    } catch (e) {
      print('Reports Error: $e');
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
      print("Reverse geocoding error: $e");
      return "Unknown location";
    }
  }


  void searchByType(String query) {
    if (query.isEmpty) {
      filteredReports.assignAll(reports);
    } else {
      final dateFormat = DateFormat('yyyy-MM-dd');
      filteredReports.assignAll(
        reports.where((r) {

          final localDate = r.createdAt.toLocal();
          final formattedDate = dateFormat.format(localDate);
          return formattedDate.contains(query);
        }).toList(),
      );
    }



    /* void searchByType(String query) {
    if (query.isEmpty) {
      filteredReports.assignAll(reports);
    } else {
      filteredReports.assignAll(
        reports.where((r) => r.type.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }*/
  }

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fetchReports();
  }
}