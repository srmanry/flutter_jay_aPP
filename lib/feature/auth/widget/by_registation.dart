import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:spotem/core/utils/app_colors.dart';
import '../controller/auth_controller.dart';

class ByRegistation extends StatelessWidget {
  const ByRegistation({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AuthController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(
          () => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Checkbox(
              //checkColor: Color(0xFF868686),
              value: c.rememberMe.value,
              onChanged: (v) => c.toggleRegister(v ?? false),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "I agree to the ",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: c.termOfService,
                  child: Text(
                    "terms & service ",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.appColor,
                    ),
                  ),
                ),
              ],
            ),
            /*  GestureDetector(
              onTap: c.privacyPolicy,
              child: const Text(
                "privacy policy",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF00C49A),
                ),
              ),
            ), */
          ],
        ),
      ],
    );
  }
}
