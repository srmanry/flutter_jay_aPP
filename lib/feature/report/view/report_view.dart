import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:spotem/core/common/widgets/save_botton.dart';
import 'package:spotem/core/util/app_colors.dart';
import 'package:spotem/feature/profile/controller/theme_controller.dart';
import 'package:spotem/feature/report/controller/report_controller.dart';

class ReportScreenView extends StatelessWidget {
  ReportScreenView({super.key});

  final ReportController controller = Get.put(ReportController());
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Report",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.appColor,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.report_outlined, size: 30, color: AppColors.appColor),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Event",
                style: TextStyle(
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller.titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Title',
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              Text(
                "Description",
                style: TextStyle(
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller.descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Description Write here',
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: controller.options.length,
                itemBuilder: (context, index) {
                  final item = controller.options[index];
                  final label = item["label"] as String;
                  final color = item["color"] as Color;

                  return Obx(
                    () => RadioListTile<String>(
                      value: label,
                      groupValue: controller.selectedOption.value,
                      contentPadding: EdgeInsets.zero,
                      dense: false,
                      visualDensity: VisualDensity.standard,
                      onChanged: (String? value) {
                        if (value != null) {
                          controller.selectedOption.value = value;
                        }
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(label),
                          const SizedBox(width: 8),
                          Icon(Icons.location_on, color: color),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: buttonWidget(
          text: "Report",
          onTap: () async {
            print(
              "Selected Option:================ ${controller.selectedOption.value}",
            );
            print("Report Button Clicked");
            // await controller.reportEvent();
          },
        ),
      ),
    );
  }
}
