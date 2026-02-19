/* 


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/repo/report_repo.dart';


class NewFeatureController extends GetxController {
  final ReportRepo reportRepo;

  NewFeatureController(this.reportRepo);

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  var selectedType = "Fire".obs;
  var isLoading = false.obs;
  var report = <ReportModel>[].obs,

  Future<ReportModel?> createReport(double latitude, double longitude) async {
    try {
      isLoading.value = true;

      final report = await reportRepo.createReport(
        title: titleController.text.trim(),
        type: selectedType.value,
        description: descriptionController.text.trim(),
        latitude: latitude,
        longitude: longitude,
      );

      titleController.clear();
      descriptionController.clear();

      return report;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/feature/home/data/model/reports_model.dart';

import '../../domain/repo/report_repo.dart';


class NewFeatureController extends GetxController {
  final ReportRepo reportRepo;

  NewFeatureController(this.reportRepo);

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  var selectedType = "Fire".obs;
  var isLoading = false.obs;

  // ✅ List of fetched reports
  var reports = <ReportModel>[].obs;

  // Create report (POST)
  Future<ReportModel?> createReport(double latitude, double longitude) async {
    try {
      isLoading.value = true;

      final report = await reportRepo.createReport(
        title: titleController.text.trim(),
        type: selectedType.value,
        description: descriptionController.text.trim(),
        latitude: latitude,
        longitude: longitude,
      );

      titleController.clear();
      descriptionController.clear();

      return report;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch all reports (GET)
  Future<void> fetchReports() async {
    try {
      isLoading.value = true;
      final result = await reportRepo.getReports();
      reports.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
