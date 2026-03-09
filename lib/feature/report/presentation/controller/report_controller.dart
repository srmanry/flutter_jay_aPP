import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/utils/app_colors.dart';
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

  Future<bool> createReport(double lat, double lng) async {
    try {
      isCreateingReport.value = true;
      await repository.createReport(
        title: titleController.text.trim(),
        type: selectedOption.value,
        description: descriptionController.text.trim(),
        latitude: lat,
        longitude: lng,
      );

      Get.snackbar(
        "Success",
        "Report created successfully",
        colorText: AppColors.appColor,
        backgroundColor: Colors.black12,
        snackPosition: SnackPosition.TOP,
      );

      titleController.clear();
      descriptionController.clear();
      return true;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong",
        backgroundColor: Colors.black12,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      isCreateingReport.value = false;
    }
  }
}
