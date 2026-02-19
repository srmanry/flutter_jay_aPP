import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/save_botton.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../map/controller/map_controller.dart';
import '../../../profile/presentation/controller/theme_controller.dart';
import '../controller/report_controller.dart';
import 'create_report_by_map_view.dart';

class ReportScreenView extends StatelessWidget {
  ReportScreenView({super.key});

  final ReportController reportController = Get.put(ReportController());
  final LocationController locationController = Get.put(LocationController());
  final ThemeController themeController = Get.put(ThemeController());
  bool isSnackBarVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: GestureDetector(onTap: () {Get.to(AppGroundView());}, child: Icon(Icons.arrow_back_ios_rounded)),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Report",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.appColor),
            ),
            const SizedBox(width: 10),
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
              _buildTextField("Event", "Title", reportController.titleController),
              const SizedBox(height: 15),
              _buildTextField("Description", "Write description here", reportController.descriptionController, maxLines: 5),
              const SizedBox(height: 20),

              Text(
                'Report Type',
                style: TextStyle(
                  color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 8),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: reportController.options.length,
                itemBuilder: (context, index) {
                  final item = reportController.options[index];
                  final label = item["label"] as String;
                  final color = item["color"] as Color;

                  return Obx(() {
                    return InkWell(
                      onTap: () {
                        reportController.selectedOption.value = label;
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio<String>(
                            value: label,
                            //activeColor: themeController.isDarkMode.value ? Colors.white : AppColors.appColor,
                            fillColor: WidgetStateProperty.all(themeController.isDarkMode.value ? Colors.white : Colors.black),
                            groupValue: reportController.selectedOption.value,
                            onChanged: (value) {
                              if (value != null) {
                                reportController.selectedOption.value = value;
                              }
                            },
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            label,
                            style: TextStyle(
                              color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(Icons.location_on, color: color),
                        ],
                      ),
                    );
                  });
                },
              ),

              /*     Align(
                alignment: AlignmentGeometry.bottomRight,
                child: InkWell(
                  onTap: () {
                    Get.to(() => CreateReportByMapView());
                  },
                  child: Text("Create Report by Map "),
                ),
              ), */
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
        child: Obx(
          () => buttonWidget(
            child: reportController.isCreateingReport.value
                ? const SizedBox(height: 25, width: 25, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text(
                    "Submit Report",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
            text: 'kjkj',
            onTap: reportController.isCreateingReport.value
                ? null
                : () async {
                    if (reportController.titleController.text.isEmpty && reportController.descriptionController.text.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Title is required",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.red,
                        //duration: const Duration(seconds: 2),
                      );
                      return;
                    }

                    if (reportController.descriptionController.text.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Description is required",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.red,
                        duration: const Duration(seconds: 2),
                      );
                      return;
                    }

                    reportController.isCreateingReport.value = true;
                    try {
                      await locationController.loadLocation();
                      final lat = locationController.lat.value;
                      final lng = locationController.lng.value;
                      await reportController.createReport(lat, lng);
                    } finally {
                      reportController.isCreateingReport.value = false;
                    }
                  },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: themeController.isDarkMode.value ? Colors.white : Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          textCapitalization: TextCapitalization.words,
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: themeController.isDarkMode.value ? Colors.white : Colors.black, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: themeController.isDarkMode.value ? Colors.white : Colors.black, width: 1.0),
            ),

            border: OutlineInputBorder(
              //  borderSide: BorderSide(color:themeController.isDarkMode.value ? AppColors.appColor : Colors.black),
            ),
            hintText: hint,
          ),
        ),
      ],
    );
  }
}
