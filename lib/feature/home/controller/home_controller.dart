import 'dart:ffi';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:spotem/core/network/local/token_manager.dart';
import 'package:spotem/feature/home/model/reports_model.dart';

class HomeController extends GetxController {
  final RxInt currentIndex = 0.obs;
  var isLoading = false.obs;
  // final RxList<ReportModel> reports =  [].obs;
 // var reports = Rxn<ReportModel>();
 var reports = <ReportModel>[].obs;  // RxList<ReportModel>

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
  void searchByType(String query){
    if(query.isEmpty){
      filteredReports.assignAll(reports);

    }else{
      filteredReports.assignAll(reports.where((r)=>r.type.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  final dio.Dio dioClient = dio.Dio(
    dio.BaseOptions(
      baseUrl: "https://backend-jay.onrender.com/api/v1",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
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
}

       else {
        print("Reports API Error: ${response.data}");
      }
      print(" Final URL: ${dioClient.options.baseUrl}/reports");
      print("=========== Token : $token");
      print("Final URL: ${dioClient.options.baseUrl}/reports");
      print('Reports: ${response.data}');
    } catch (e) {
      print("🔗 Final URL: ${dioClient.options.baseUrl}/reports");

      //debugPrintStack()
      // Print the error to the console
      print('+++++++++++++++++reports Error: $e');
    }
    finally {
      isLoading.value = false;
    }
  }



  Future<String> getPlaceName(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return "${place.locality}, ${place.country}";
      } else {
        return "Unknown location";
      }
    } catch (e) {
      print("Reverse geocoding error: $e");
      return "Unknown location";
    }
  }


}
