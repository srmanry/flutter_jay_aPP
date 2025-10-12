import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/common/widgets/save_botton.dart';
import 'package:spotem/core/util/app_colors.dart';
import 'package:spotem/feature/profile/controller/theme_controller.dart';
import '../../map/controller/map_controller.dart';
import '../controller/report_controller.dart';

class ReportScreenView extends StatelessWidget {
  ReportScreenView({super.key});

  final ReportController reportController = Get.put(ReportController());
  final LocationController locationController = Get.put(LocationController());
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
              _buildTextField("Description", "Write description here",
                  reportController.descriptionController, maxLines: 5),
              const SizedBox(height: 20),


              ListView.builder(
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
                            groupValue: reportController.selectedOption.value,
                            onChanged: (value) {
                              if (value != null) {
                                reportController.selectedOption.value = value;
                              }
                            },
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          const SizedBox(width: 10),
                          Text(label),
                          const SizedBox(width: 10),
                          Icon(Icons.location_on, color: color),
                        ],
                      ),
                    );
                  });


                  /*      return Obx(() => RadioListTile<String>(

                    value: label,
                    groupValue: reportController.selectedOption.value,
                    onChanged: (String? value) {
                      if (value != null) {
                        reportController.selectedOption.value = value;
                      }
                    },

                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Row(
                      children: [
                        Text(label),
                        const SizedBox(width: 8),
                        Icon(Icons.location_on, color: color),
                      ],
                    ),
                  ));*/
                },
              ),
            ],
          ),
        ),
      ),


      bottomNavigationBar: Obx(() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: reportController.isLoading.value ? SizedBox(
          height: 50,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.appColor,
            ),
          ),
        ) : buttonWidget(
          text: "Report",
          onTap: () async {
            await locationController.loadLocation();
            final lat = locationController.lat.value;
            final lng = locationController.lng.value;
            await reportController.createReport(lat, lng);
          },
        ),
      )),


/*      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: buttonWidget(
          text: "Report",
          onTap: () async {
            await locationController.loadLocation();
            final lat = locationController.lat.value;
            final lng = locationController.lng.value;
            await reportController.createReport(lat, lng);
          },
        ),
      ),*/


    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400,)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: hint,
          ),
        ),
      ],
    );
  }
}
