import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:spotem/app_ground.dart';
import 'package:spotem/core/util/app_colors.dart';
import 'package:spotem/feature/splash/view/splash_screen_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: AppColors.appColor),

          titleTextStyle: TextStyle(
            color: AppColors.appColor,
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(),

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: AppGroundView(),
      home: SplashScreen(),
    );
  }
}
