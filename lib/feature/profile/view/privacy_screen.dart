import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spotem/core/utils/app_colors.dart';

import '../controller/theme_controller.dart';

class AboutAppScreen extends StatelessWidget {
  AboutAppScreen({super.key});

  ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(onTap: () {Get.back();}, child: Icon(Icons.arrow_back_ios_rounded)),
        centerTitle: true,

        title: Text(
          "About App",
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
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: themeController.isDarkMode.value
                    ? Colors.white
                    : Colors.black,
                height: 1.5,
              ),
              children: const [
                TextSpan(
                  text:
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
                      "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
                      "when an unknown printer took a galley of type and scrambled it to make a type specimen book.\n\n",
                ),
                TextSpan(
                  text:
                      "It has survived not only five centuries, but also the leap into electronic typesetting, "
                      "remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets "
                      "containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\n\n",
                ),

                TextSpan(
                  text:
                      "It has survived not only five centuries, but also the leap into electronic typesetting, "
                      "remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets "
                      "containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\n\n",
                ),
                TextSpan(
                  text:
                      "It has survived not only five centuries, but also the leap into electronic typesetting, "
                      "remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets "
                      "containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\n\n",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
