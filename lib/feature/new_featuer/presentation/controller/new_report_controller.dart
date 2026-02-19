/* import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/utils/app_colors.dart';

import '../../domain/repo/report_repo.dart';


class NewFeatureController extends GetxController {
  final ReportRepo reportRepository;

  NewFeatureController({required this.reportRepository});

  final descriptionController = TextEditingController();
  var selectedOption = "ICE".obs;
  var isCreatingReport = false.obs;

  Future<bool> createReport(double lat, double lng) async {
    try {
      isCreatingReport.value = true;

      final success = await reportRepository.createReport(
        type: selectedOption.value,
        description: descriptionController.text.trim(),
        latitude: lat,
        longitude: lng,
      );

      isCreatingReport.value = false;

      if (success) {
        Get.snackbar(
          "Success",
          "Report created successfully",
          colorText: AppColors.appColor,
          backgroundColor: Colors.black12,
        );
        descriptionController.clear();
        return true;
      } else {
        Get.snackbar(
          "Failed",
          "Try again",
          colorText: Colors.white,
          backgroundColor: Colors.black12,
        );
        return false;
      }
    } catch (e) {
      isCreatingReport.value = false;
      Get.snackbar(
        "Error",
        "Something went wrong",
        colorText: Colors.white,
        backgroundColor: Colors.black12,
      );
      return false;
    }
  }
}
 */
