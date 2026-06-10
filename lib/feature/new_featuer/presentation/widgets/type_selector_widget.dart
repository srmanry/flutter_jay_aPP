import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/utils/app_colors.dart';
import 'package:spotem/feature/map/controller/map_controller.dart';

import '../controller/new_feature_controller.dart';

class TypeSelector extends StatelessWidget {
  final NewFeatureController controller;

  const TypeSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /*  _buildTypeButton("Fire", Colors.red),
        _buildTypeButton("Police", Colors.blue),
        _buildTypeButton("Ambulance", Colors.orange),
        _buildTypeButton("ICE", Colors.green), */
        _buildTypeButton("Fire", "assets/icons/fire.png"),
        _buildTypeButton("Police", "assets/icons/polic.png"),
        _buildTypeButton("Ambulance", "assets/icons/ambulence.png"),
        _buildTypeButton("ICE", "assets/icons/siren.png"),
      ],
    );
  }

  Widget _buildTypeButton(String type, String imagePath) {
    return Obx(() {
      final isSelected = controller.selectedType.value == type;

      return InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          final locationController = Get.find<LocationController>();
          locationController.clearRoute();
          controller.selectedReport.value = null;
          controller.selectedType.value = type;
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.appColor.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 2, color: isSelected ? AppColors.appColor : Colors.grey),
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(imagePath, width: 25, height: 25, fit: BoxFit.contain),
          ),
        ),
      );
    });
  }
}
