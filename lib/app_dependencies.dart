import 'package:get/get.dart';
import 'package:spotem/core/network/api_service/api_client.dart';
import 'package:spotem/core/network/api_service/api_endpoints.dart';

import 'package:spotem/feature/auth/data/auth_repo_impl.dart';
import 'package:spotem/feature/auth/domain/auth_repo.dart';
import 'package:spotem/feature/auth/presentation/contro/contro.dart';

import 'package:spotem/feature/home/controller/home_controller.dart';
import 'package:spotem/feature/home/domain/repo/home_repo.dart';
import 'package:spotem/feature/home/data/home_repo_imp.dart';
import 'package:spotem/feature/new_featuer/data/repo_impl/report_impl_repo.dart';
import 'package:spotem/feature/new_featuer/domain/repo/report_repo.dart';
import 'package:spotem/feature/new_featuer/presentation/controller/new_feature_controller.dart';
import 'package:spotem/feature/map/controller/map_controller.dart';
import 'package:spotem/feature/report/data/repo/report_repo_impl.dart';
import 'package:spotem/feature/report/domain/repo/repo.dart';
import 'package:spotem/feature/report/presentation/controller/create_report_map_controller.dart';
import 'package:spotem/feature/report/presentation/controller/report_controller.dart';

import 'package:spotem/feature/profile/domain/repo/profile_repo.dart';
import 'package:spotem/feature/profile/data/repo/profile_repo_impl.dart';
import 'package:spotem/feature/profile/presentation/controller/profile_controller.dart';

//
class AppDependencies {
  static void init() {
    final apiClient = ApiClient(baseUrl);

    // ───── Register ApiClient ─────
    Get.put<ApiClient>(apiClient, permanent: true);

    // ───── Repositories ─────
    Get.put<AuthRepository>(AuthRepositoryImpl(Get.find<ApiClient>()));

    Get.put<ProfileRepo>(ProfileRepoImpl(Get.find<ApiClient>()));

    Get.put<HomeRepo>(HomeRepositoryImpl(Get.find<ApiClient>()));
    Get.put<ReportRepo>(ReportRepoImpl(Get.find<ApiClient>()));
    Get.put<ReportRepository>(ReportRepositoryImpl(Get.find<ApiClient>()));

    // ───── Controllers ─────
    Get.put<AuthController>(AuthController(Get.find<AuthRepository>()));

    Get.put<ProfileController>(ProfileController(Get.find<ProfileRepo>()));

    Get.put<HomeController>(HomeController(Get.find<HomeRepo>()));
    Get.put<NewFeatureController>(NewFeatureController(Get.find<ReportRepo>()));
    Get.put<ReportController>(ReportController(Get.find<ReportRepository>()));
    Get.put<ReportControllerByMap>(ReportControllerByMap(Get.find<ReportRepository>()));
    // Get.put<ViewReportByMapController>(ViewReportByMapController(Get.find<ReportRepository>()));
    Get.put<LocationController>(LocationController(Get.find<ReportRepository>()), permanent: true);
  }
}
