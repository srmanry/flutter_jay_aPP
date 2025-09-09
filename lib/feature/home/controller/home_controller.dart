import 'dart:ffi';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
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

  /// Fetches the reports from the server
  ///
  /// This function will make a GET request to the server to fetch the reports.
  /// The response data will be printed to the console.
  ///
  /// If the request fails, an error message will be printed to the console.
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
      print("🔗 Final URL: ${dioClient.options.baseUrl}/reports");
      print("=========== Token : $token");
      print("🔗 Final URL: ${dioClient.options.baseUrl}/reports");
      print('Reports: ${response.data}');
    } catch (e) {
      print("🔗 Final URL: ${dioClient.options.baseUrl}/reports");

      //debugPrintStack()
      // Print the error to the console
      print('+++++++++++++++++reports Error: $e');
    }
  }
}
