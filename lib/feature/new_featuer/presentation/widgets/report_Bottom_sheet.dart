import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotem/app_ground.dart';

import '../controller/new_feature_controller.dart';

class ReportBottomSheet extends StatelessWidget {
  final LatLng position;

  ReportBottomSheet({super.key, required this.position});

  final controller = Get.find<NewFeatureController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      // This will move the bottom sheet above the keyboard
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(00),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          // borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Important: wrap content, not full screen
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Center Text
                    Center(
                      child: Obx(
                        () => Text(
                          "Create ${controller.selectedType.value} Report",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    // Top-right Cancel Icon
                    Positioned(
                      bottom: 15,
                      //left: 20,
                      right: 0,
                      //right: 8,
                      child: InkWell(
                        onTap: () {
                          Get.to(() => AppGroundView(currentIndex: 2));
                        },
                        child: Container(
                          padding: EdgeInsets.all(0),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
                          child: Center(child: const Icon(Icons.cancel_outlined, color: Colors.red, size: 35)),
                        ),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 20),
                /*  Row(
                  children: [
                    
                  ],
                ), */
                const SizedBox(height: 20),
                TextField(
                  controller: controller.titleController,
                  decoration: InputDecoration(
                    labelText: "Report Title",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: controller.descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Description",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 25),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: controller.isCreating.value
                          ? null
                          : () async {
                              final report = await controller.createReport(position.latitude, position.longitude);
                              if (report != null && context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                      child: controller.isCreating.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Submit Report"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
