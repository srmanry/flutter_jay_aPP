import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../feature/profile/controller/theme_controller.dart';

class AppColors {
  ThemeController   themeController = Get.put(ThemeController());
  static Color appColor = const Color(0xFF2B7FD0);
  static Color navBarColor = const Color(0xFF0D1B2A);
  static Color fieldColor = const Color(0xFFe8ecf1);
  static Color navBarSelectedColor = const Color(0xFF2B7FD0);
   late Color isColors = themeController.isDarkMode.value
      ? Colors.black
      : Colors.white;
}
