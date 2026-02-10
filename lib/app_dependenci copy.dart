import 'package:get/get.dart';
import 'package:spotem/core/network/api_service/api_endpoints.dart';
import 'package:spotem/feature/home/controller/new_home_controller.dart';
import 'package:spotem/feature/home/domain/repo/home_repo.dart';
import 'package:spotem/feature/home/data/home_repo_imp.dart';
import 'package:spotem/feature/profile/repo/profile_repo.dart';

import 'core/network/api_service/api_client.dart';
import 'feature/auth/controller/auth_controller.dart';
import 'feature/auth/repo/auth_repo.dart';

import 'feature/profile/controller/profile_controller.dart';

class AppDependencies {
  static void init() {
    final apiClient = ApiClient(baseUrl);

    // Repositories
    Get.put(AuthRepository(apiClient));
    Get.put(ProfileRepository(apiClient));
    /* Get.put<HomeRepo>(
  HomeRepositoryImpl(Get.find()),
);
 */
    Get.put<HomeRepo>(HomeRepositoryImpl(apiClient));

    // Get.put(UserRepository(apiClient));

    // Controllers
    Get.put(AuthController(Get.find<AuthRepository>()));
    Get.put(ProfileController(Get.find<ProfileRepository>()));
    Get.put(NewHomeController(Get.find<HomeRepo>()));

    // Get.put(SleepGoalControllerX(Get.find<S>()));

    //Get.put(UserController(Get.find<UserRepository>()));
  }
}
