import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/utils/app_colors.dart';

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

  /*   Widget _buildTypeButton(String type, Color color) {
    return Obx(() {
      final isSelected = controller.selectedType.value == type;

      return InkWell(
        borderRadius: BorderRadius.circular(50),
        splashColor: Colors.grey,
        onTap: () => controller.selectedType.value = type,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(border: Border.all(width: 1, color: AppColors.appColor)),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Icon(Icons.location_on, color: color, size: 25),
          ),
        ),
      );
    });
  } */

  /*  Widget _buildTypeButton(String type, Color color) {
    return Obx(() {
      final isSelected = controller.selectedType.value == type;

      return InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () => controller.selectedType.value = type,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 2, color: isSelected ? color : AppColors.appColor),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Icon(Icons.location_on, color: isSelected ? color : color.withOpacity(0.6), size: 25),
          ),
        ),
      );
    });
  } */
  /* Widget _buildTypeButton(String type, String imagePath) {
  return Obx(() {
    final isSelected = controller.selectedType.value == type;

    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () => controller.selectedType.value = type,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              width: 2,
              color: isSelected ? AppColors.appColor : AppColors.appColor,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Image.asset(
            imagePath,
            width: 25,
            height: 25,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  });
} */

  Widget _buildTypeButton(String type, String imagePath) {
    return Obx(() {
      final isSelected = controller.selectedType.value == type;

      return InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () => controller.selectedType.value = type,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.appColor.withOpacity(0.1) : Colors.transparent,
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
