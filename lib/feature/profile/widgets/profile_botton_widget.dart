import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/util/app_colors.dart';
import 'package:spotem/feature/profile/controller/theme_controller.dart';

Widget profileButtonWidget({
  required Widget bottomIcon,
  required String name,
  final VoidCallback? onTap,
  Color textColor = Colors.black87,
}) {
  ThemeController themeController = Get.put(ThemeController());
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    child: InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          //  color: isDark ? Colors.white : AppColors.appColor,
          color: const Color(0xFFE8ECF1),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            bottomIcon,
            const SizedBox(width: 10),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black87,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
