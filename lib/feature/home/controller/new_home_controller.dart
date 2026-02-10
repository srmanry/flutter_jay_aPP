import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:spotem/feature/home/data/model/reports_model.dart';
import 'package:spotem/feature/home/domain/repo/home_repo.dart';

class NewHomeController extends GetxController {
  final HomeRepo repository;

  NewHomeController(this.repository);

  var isLoading = false.obs;
  var reports = <ReportModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReports();
    print("=====================🔥 NewHomeController INIT");
  }

  /*   Future<void> fetchReports() async {
    try {
      isLoading.value = true;
      final result = await repository.getReports();
      reports.assignAll(result);
      print("Fetched============================= clean ================= ${result.length} reports");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  } */

  //Future<void> fetchReports() async {
  /*     isLoading.value = true;
    print("🚀 fetchReports START");

    final result = await repository.getReports();

    print("✅ fetchReports AFTER API");
    print("📊 result length = ${result.length}");

    reports.assignAll(result);
    isLoading.value = false;
  } */

  /*  Future<void> fetchReports() async {
  try {
    isLoading.value = true;
    print("🚀 fetchReports() শুরু হলো");

    final result = await repository.getReports();

    print("✅ API থেকে ডাটা এসেছে");
    print("📊 পাওয়া রিপোর্টের সংখ্যা: ${result.length}");

    reports.assignAll(result);
  } catch (e, stackTrace) {
    print("❌ fetchReports() এ এরর হয়েছে:");
    print("Error: $e");
    print("Stack trace: $stackTrace");

    Get.snackbar(
      "লোড করতে সমস্যা হয়েছে",
      e.toString(),
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  } finally {
    isLoading.value = false;
    print("fetchReports() শেষ");
  }
} */

  Future<void> fetchReports() async {
    try {
      isLoading.value = true;
      print("🚀 fetchReports START");

      final result = await repository.getReports();

      print("✅ API থেকে ডাটা এসেছে → ${result.length} টি রিপোর্ট");

      reports.assignAll(result);

      print("reports list এখন: ${reports.length} টি আইটেম");
      if (reports.isNotEmpty) {
        print("প্রথম রিপোর্টের টাইটল: ${reports.first.title}");
        print("প্রথম রিপোর্টের টাইপ: ${reports.first.type}");
      }
    } catch (e, stack) {
      print("❌ fetchReports এরর: $e");
      print(stack);
    } finally {
      isLoading.value = false;
    }
  }
}
