import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/common/custom_massage.dart';
import 'package:spotem/feature/report/domain/repo/repo.dart';

class ReportController extends GetxController {
  ReportController(this.repository);

  final ReportRepository repository;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  var selectedOption = "ICE".obs;
  var isCreateingReport = false.obs;

  final List<Map<String, dynamic>> options = [
    {"label": "ICE", "color": Colors.green},
    {"label": "Fire", "color": Colors.red},
    {"label": "Police", "color": Colors.blue},
    {"label": "Ambulance", "color": Colors.amber},
  ];

  String _errorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data["message"] ?? data["error"] ?? data["detail"];
        if (message != null) return message.toString();
      }
      return error.message ?? "Network error";
    }
    return error.toString().replaceFirst("Exception: ", "");
  }

  Future<bool> createReport(double lat, double lng) async {
    try {
      isCreateingReport.value = true;
      await repository.createReport(title: titleController.text.trim(), type: selectedOption.value, description: descriptionController.text.trim(), latitude: lat, longitude: lng);

      CustomShowMessage.success(message: "Report created successfully");

      titleController.clear();
      descriptionController.clear();
      return true;
    } catch (e) {
      CustomShowMessage.error(message: _errorMessage(e));
      return false;
    } finally {
      isCreateingReport.value = false;
    }
  }
}
