
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
  
  }

  Future<void> fetchReports() async {
    try {
      isLoading.value = true;
      print("🚀 fetchReports START");

      final result = await repository.getReports();

      print("API থেকে ডাটা এসেছে → ${result.length} টি রিপোর্ট");

      reports.assignAll(result);

      print("reports list এখন: ${reports.length} টি আইটেম");
      if (reports.isNotEmpty) {
        print("প্রথম রিপোর্টের টাইটল: ${reports.first.title}");
        print("প্রথম রিপোর্টের টাইপ: ${reports.first.type}");
      }
    } catch (e, stack) {
      print(" fetchReports এরর: $e");
      print(stack);
    } finally {
      isLoading.value = false;
    }
  }
}
