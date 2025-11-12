import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_colors.dart';
import '../controller/theme_controller.dart';

class PrivacyPolicyView extends StatelessWidget {
  PrivacyPolicyView({super.key});

  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    final isDark = themeController.isDarkMode.value;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios_rounded),
        ),
        centerTitle: true,
        title: Text(
          "Privacy Policy",
          style: TextStyle(
            color: AppColors.appColor,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.appColor, size: 30),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16,right: 16,bottom: 30),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                  height: 1.6,
                ),
                children: [
                  const TextSpan(
                    text:
                    "This Privacy Policy describes how Spotem365 (“we”, “our”, “us”) collects, uses, and protects your information when you use our application.\n\n",
                  ),
                  TextSpan(
                    text: "1. Information We Collect\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                  ),
                  const TextSpan(
                    text:
                    "We may collect the following information when you use the app:\n\n• Personal details (Name, Email)\n• Device and usage data (IP, browser type, session duration)\n• Location data (with your permission)\n• Photos or media files (only when you grant access)\n\n",
                  ),
                  TextSpan(
                    text: "2. How We Use Your Information\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                  ),
                  const TextSpan(
                    text:
                    "We use your information to:\n\n• Provide and maintain the app\n• Manage your account\n• Contact you with updates or notifications\n• Improve our services\n• Comply with legal obligations\n\n",
                  ),
                  TextSpan(
                    text: "3. Sharing of Information\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                  ),
                  const TextSpan(
                    text:
                    "We may share your data:\n\n• With trusted service providers\n• During business transfers or mergers\n• With affiliates or business partners (with protection agreements)\n• Only with your consent for other purposes\n\n",
                  ),
                  TextSpan(
                    text: "4. Data Retention\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                  ),
                  const TextSpan(
                    text:
                    "We keep your personal data only as long as necessary to provide our services or meet legal obligations.\n\n",
                  ),
                  TextSpan(
                    text: "5. Data Security\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                  ),
                  const TextSpan(
                    text:
                    "We use reasonable safeguards to protect your data. However, no electronic transmission is 100% secure, and we cannot guarantee absolute security.\n\n",
                  ),
                  TextSpan(
                    text: "6. Children’s Privacy\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                  ),
                  const TextSpan(
                    text:
                    "Spotem365 is not intended for children under 13 years old. If we discover data collected from a child without consent, it will be deleted immediately.\n\n",
                  ),
                  TextSpan(
                    text: "7. Your Rights\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                  ),
                  const TextSpan(
                    text:
                    "You can:\n\n• Request access, update, or deletion of your data\n• Manage your privacy settings in the app\n• Contact us for any data-related requests\n\n",
                  ),
                  TextSpan(
                    text: "8. Changes to This Policy\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                  ),
                  const TextSpan(
                    text:
                    "We may update this Privacy Policy from time to time. Any changes will be posted here with a new “Last updated” date.\n\n",
                  ),
                  TextSpan(
                    text: "9. Contact Us\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                  ),
                  const TextSpan(
                    text:
                    "If you have any questions or concerns, contact us at: ",
                  ),

                   TextSpan(
                    text:
                    "finishersrepair@gmail.com",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
