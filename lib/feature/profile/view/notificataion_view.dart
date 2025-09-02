import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/util/app_colors.dart';
import 'package:spotem/feature/profile/controller/theme_controller.dart';

class NotificataionScreenView extends StatelessWidget {
  NotificataionScreenView({super.key});
  final ThemeController themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notificataion",
          style: TextStyle(
            color: AppColors.appColor,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.appColor, size: 30),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Notificataion/Disable All Notificataion",
                  style: TextStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.toggle_off_outlined),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Do Not Disturb (DND)",
                  style: TextStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.toggle_on_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
