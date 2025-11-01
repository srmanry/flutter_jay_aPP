import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import 'core/utils/app_colors.dart';
import 'feature/alert/controller/alert_controller.dart';
import 'feature/profile/controller/theme_controller.dart';
import 'feature/splash/view/splash_screen_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Get.put(AlertController(), permanent: true);
  Get.put(ThemeController(), permanent: true);

  runApp(const MyApp());

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint("Caught Flutter Error+++++++++++++++++: ${details.exception}");
    debugPrint("Stack: ${details.stack}");
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: '',
        themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: false,
          appBarTheme: AppBarTheme(
            systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark,),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: AppColors.appColor),
            titleTextStyle:  TextStyle(color: AppColors.appColor, fontWeight: FontWeight.w700, fontSize: 24,),
          ),
        ),

        darkTheme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          useMaterial3: false,
          appBarTheme: AppBarTheme(
            systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light,),
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: AppColors.appColor),
            titleTextStyle:  TextStyle(color: AppColors.appColor, fontWeight: FontWeight.w700, fontSize: 24,),
          ),
        ),

        home: const SplashScreen(),
      );
    });
  }
}
