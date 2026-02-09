import 'package:get/get.dart';
import 'package:spotem/core/network/api_service/api_endpoints.dart';
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

    // Get.put(UserRepository(apiClient));

    // Controllers
    Get.put(AuthController(Get.find<AuthRepository>()));
    Get.put(ProfileController(Get.find<ProfileRepository>()));


   // Get.put(SleepGoalControllerX(Get.find<S>()));

    //Get.put(UserController(Get.find<UserRepository>()));
  }
}
