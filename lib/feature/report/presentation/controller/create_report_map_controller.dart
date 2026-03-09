import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/utils/app_colors.dart';
import 'package:spotem/feature/report/domain/repo/repo.dart';

class ReportControllerByMap extends GetxController {
  ReportControllerByMap(this.repository);

  final ReportRepository repository;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  var selectedOption = "ICE".obs;
  var isCreateingReport = false.obs;

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

      Get.snackbar("Success", "Report created successfully", colorText: AppColors.appColor, backgroundColor: Colors.black12);

      titleController.clear();
      descriptionController.clear();

      return true;
    } catch (e) {
     // Get.snackbar("Error", "Something went wrong", colorText: Colors.white, backgroundColor: Colors.black12);
      return false;
    } finally {
      isCreateingReport.value = false;
    }
  }
}
