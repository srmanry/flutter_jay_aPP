import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/utils/app_colors.dart';

import '../../../core/service/local/token_manager.dart';

class ReportController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  var selectedOption = "ICE".obs;
  var isLoading = false.obs;
  var isCreateingReport = false.obs;

  final List<Map<String, dynamic>> options = [
    {"label": "ICE", "color": Colors.green},
    {"label": "Fire", "color": Colors.red},
    {"label": "Police", "color": Colors.blue},
    {"label": "Ambulance", "color": Colors.amber},
  ];

  final Dio dioClient = Dio(
    BaseOptions(
      baseUrl: "https://api.spotem365.com/api/v1",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  Future<void> createReport(double lat, double lng) async {
    try {
      isCreateingReport.value = true;
      final token = await TokenManager.getAccessToken();

      final body = {
        "type": selectedOption.value,
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "location": {
          "type": "Point",
          "coordinates": [lng, lat],
        },
      };
      await Future.delayed(const Duration(seconds: 3));

      final response = await dioClient.post(
        "/report/",
        data: body,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      isCreateingReport.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          " Success",
          "Report created successfully",
          colorText: AppColors.appColor,
          backgroundColor: Colors.black12,
        );
        titleController.clear();
        descriptionController.clear();
      } else {
        Get.snackbar(
          backgroundColor: Colors.black12,
          "Failed to create report",
          "Try again",
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isCreateingReport.value = false;
      Get.snackbar(
        "",
        "Something went wrong",
        backgroundColor: Colors.black12,
        colorText: Colors.white,
      );
    }
  }
}
