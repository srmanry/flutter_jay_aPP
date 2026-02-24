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
    

      final result = await repository.getReports();


      reports.assignAll(result);

   
      if (reports.isNotEmpty) {
        ///return Get.to(" ");
      }
    } catch (e, stack) {
      print(" fetchReports  Error: $e");
      print(stack);
    } finally {
      isLoading.value = false;
    }
  }
}
