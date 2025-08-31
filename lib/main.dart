import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/util/app_colors.dart';
import 'package:spotem/feature/profile/controller/theme_controller.dart';

import 'feature/splash/view/splash_screen_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    //  final themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: AppColors.appColor),
            titleTextStyle: TextStyle(
              color: themeController.isDarkMode.value
                  ? AppColors.appColor
                  : AppColors.appColor,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),

        darkTheme: ThemeData.dark(),

        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,

        home: SplashScreen(),
      ),
    );
  }
}
