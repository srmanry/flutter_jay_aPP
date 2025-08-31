/* import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:test_project/api_handle/api_client.dart';
import 'package:test_project/common/controller/splash_controller.dart';
import 'package:test_project/common/controller/theme_controller.dart';
import 'package:test_project/feature/auth/controller/auth_controller.dart';
import 'package:test_project/feature/banner/domain/repository/banner_repository.dart';
import 'package:test_project/feature/cart/controller/cart_controller.dart';
import 'package:test_project/feature/cart/domain/repository/cart_repository.dart';
import 'package:test_project/feature/dashboard/controller/dashboard_controller.dart';
import 'package:test_project/feature/banner/controller/banner_controller.dart';
import 'package:test_project/feature/onboarding/controller/onboarding_controller.dart';
import 'package:test_project/feature/product/controller/product_controller.dart';
import 'package:test_project/feature/product/domain/repository/product_repository.dart';
import 'package:test_project/localization/language_model.dart';
import 'package:test_project/localization/localization_controller.dart';
import 'package:test_project/util/app_constants.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));
  // Get.lazyPut(() => HomeRepo(Get.find()));

  // Repository
  Get.lazyPut(() => CartRepository(apiClient : Get.find()));
  Get.lazyPut(() => ProductRepository(apiClient : Get.find()));
  Get.lazyPut(() => BannerRepository(apiClient : Get.find()));



  // Controller
  Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
  Get.lazyPut(() => OnboardingController(sharedPreferences: Get.find()));
  Get.lazyPut(() => AuthController());
  Get.lazyPut(() => DashboardController());
  Get.lazyPut(() => BannerController(bannerRepository: Get.find()));
  Get.lazyPut(() => CartController(cartRepository: Get.find()));
  Get.lazyPut(() => ProductController(productRepository: Get.find()));



  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    Map<String, String> languageJson = {};
    mappedJson.forEach((key, value) {
      languageJson[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = languageJson;
  }
  return languages;
}
 */