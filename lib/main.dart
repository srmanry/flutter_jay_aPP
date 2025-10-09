import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/util/app_colors.dart';
import 'package:spotem/feature/profile/controller/theme_controller.dart';

import 'feature/splash/view/splash_screen_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    final themeController = Get.put(ThemeController());
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',

        theme: ThemeData(
          scaffoldBackgroundColor: themeController.isDarkMode.value ? Colors.black : Colors.white,
          useMaterial3: false,
          appBarTheme: AppBarTheme(
            backgroundColor: themeController.isDarkMode.value ? Colors.black : Colors.white,
            iconTheme: IconThemeData(color: themeController.isDarkMode.value ? Colors.white : Colors.black,),
            titleTextStyle: TextStyle(
              color: themeController.isDarkMode.value ? AppColors.appColor : AppColors.appColor,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
        ),

        darkTheme: ThemeData.dark(),
        themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        home: SplashScreen(),
      ),
    );
  }
}
