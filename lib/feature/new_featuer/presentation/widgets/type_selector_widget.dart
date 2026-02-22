import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/new_feature_controller.dart';

class TypeSelector extends StatelessWidget {
  final NewFeatureController controller;

  const TypeSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTypeButton("Fire", Colors.red),
        _buildTypeButton("Police", Colors.blue),
        _buildTypeButton("Ambulance", Colors.orange),
        _buildTypeButton("ICE", Colors.green),
      ],
    );
  }

  Widget _buildTypeButton(String type, Color color) {
    return Obx(() {
      final isSelected =
          controller.selectedType.value == type;

      return GestureDetector(
        onTap: () =>
            controller.selectedType.value = type,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Icon(Icons.location_on,
              color: color),
        ),
      );
    });
  }
}