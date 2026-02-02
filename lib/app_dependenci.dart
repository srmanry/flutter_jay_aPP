/* import 'package:get/get.dart';

import 'core/network/api_service/api_client.dart';
import 'core/network/api_service/api_endpoints.dart';

class AppDependencies {
  static void init() {
    final apiClient = ApiClient(baseUrl);

    Get.put(AuthRepository(apiClient));
    Get.put(HomeRepo(apiClient));
    Get.put(ProfileRepository(apiClient));
    Get.put(PremiumRepo(apiClient));

    Get.put(AuthController(Get.find<AuthRepository>()));
    Get.put((HomeController(Get.find<HomeRepo>())));
    Get.put(ProfileController(Get.find<ProfileRepository>()));
    Get.put(PremiumController(Get.find<PremiumRepo>()));

    // Register FilterController with its dependency
    //  Get.put(FilterController(apiClient: apiClient));

    // Get.put(FilterController(Get.find<ApiClient>()));ProductRepo>()));
    // Get.put(FilterController(Get.find<ApiClient>()),);
  }
}
 */