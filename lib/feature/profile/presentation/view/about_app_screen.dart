import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/app_colors.dart';
import '../controller/theme_controller.dart';

class AboutAppScreen extends StatelessWidget {
  AboutAppScreen({super.key});

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
          "About App",
          style: TextStyle(color: AppColors.appColor, fontSize: 24, fontWeight: FontWeight.w700),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.appColor, size: 30),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 16, color: isDark ? Colors.white : Colors.black, height: 1.6),
                  children: [
                    /*
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final Uri emailUri = Uri(
                            scheme: 'mailto',
                            path: 'finishersrepair@gmail.com',
                            query: Uri.encodeFull('subject=Spotem365 Support'),
                          );
                          if (await canLaunchUrl(emailUri)) {
                            await launchUrl(emailUri);
                          } else {
                            Get.snackbar(
                              'Error',
                              'Could not open email app',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                    ),*/
                    /*const TextSpan(
                      text: "Last Updated: October 28, 2025\n\n",
                    ),*/

                    // --- About Spotem365 ---
                    _buildSectionTitle("About Spotem365"),
                    const TextSpan(
                      text:
                          "Spotem365 is a location-based service application designed to help users find and connect with local services and opportunities around them. The app uses device location, user input, and real-time updates to provide accurate and relevant results.\n\n",
                    ),

                    // --- Our Mission ---
                    _buildSectionTitle("Our Mission"),
                    const TextSpan(
                      text:
                          "To make discovering, connecting, and managing local services faster, simpler, and more personalized — empowering users and service providers alike.\n\n",
                    ),

                    // --- Key Features ---
                    _buildSectionTitle("Key Features"),
                    const TextSpan(
                      text:
                          "• Real-time location tracking for better service recommendations\n"
                          "• Secure account management for users and providers\n"
                          "• Notifications for updates, offers, and messages\n"
                          "• Easy contact between users and service providers\n\n",
                    ),

                    // --- Commitment to Users ---
                    _buildSectionTitle("Commitment to Users"),
                    const TextSpan(
                      text:
                          "We are committed to maintaining transparency, privacy, and data protection. Your trust is our priority, and we continuously work to keep your information secure and your app experience smooth.\n\n",
                    ),

                    const TextSpan(text: "For any inquiries or support, please contact us at "),
                    /*           TextSpan(
                      text: "finishersrepair@gmail.com",
                      style: TextStyle(color: AppColors.appColor, fontWeight: FontWeight.w600),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final Uri emailUri = Uri(scheme: 'mailto', path: 'finishersrepair@gmail.com', query: Uri.encodeFull('subject=Spotem365 Inquiry'));
                          if (await canLaunchUrl(emailUri)) {
                            await launchUrl(emailUri);
                          } else {
                            /* Get.snackbar(
                              'Error',
                              'Could not open email app',
                              snackPosition: SnackPosition.BOTTOM,
                            );*/
                          }
                        },
                    ), */
                  ],
                ),
              ),
              Text(
                "finishersrepair@gmail.com",
                style: TextStyle(color: AppColors.appColor, fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  //  Helper function for section titles
  static TextSpan _buildSectionTitle(String title) {
    return TextSpan(
      text: "$title\n",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.appColor),
    );
  }
}
