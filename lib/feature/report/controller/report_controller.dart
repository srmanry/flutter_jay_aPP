import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/network/local/token_manager.dart';
import '../../map/controller/map_controller.dart'; // location controller import

class ReportController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  var selectedOption = "ICE".obs;
  var isLoading = false.obs;

  final List<Map<String, dynamic>> options = [
    {"label": "ICE", "color": Colors.green},
    {"label": "Fire", "color": Colors.red},
    {"label": "Police", "color": Colors.blue},
    {"label": "Ambulance", "color": Colors.amber},
  ];

  final Dio dioClient = Dio(
    BaseOptions(
      baseUrl: "https://backend-jay.onrender.com/api/v1",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );


  Future<void> createReport(double lat, double lng) async {
    try {
      isLoading.value = true;
      final token = await TokenManager.getAccessToken();

      final body = {
        "type": selectedOption.value,
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "location": {
          "type": "Point",
          "coordinates": [lng, lat],
        }
      };
await Future.delayed(const Duration(seconds: 3),);
      print(" Sending Body: $body");

      final response = await dioClient.post(
        "/report/",
        data: body,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(" Success", "Report created successfully");
        titleController.clear();
        descriptionController.clear();
      } else {
        Get.snackbar("Failed to create report", "Try again");
        print("Response: ${response.data}");
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("", "Something went wrong");
      print(" Error: $e");
    }
  }



  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
