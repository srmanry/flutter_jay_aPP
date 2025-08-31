import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportController extends GetxController {
  // Form fields
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // Selected emergency option
  var selectedOption = "ICE".obs;

  // Emergency options
  final List<Map<String, dynamic>> options = [
    {"label": "ICE", "color": Colors.green},
    {"label": "Fire", "color": Colors.red},
    {"label": "Police", "color": Colors.blue},
    {"label": "Ambulance", "color": Colors.amber},
  ];

  // Submit data
  /* Future<void> submitData() async {
    if (selectedOption.value.isEmpty) return;

    final url = Uri.parse(
      "https://example.com/api/emergency",
    ); // Replace with your API
    final body = {
      "title": titleController.text,
      "description": descriptionController.text,
      "emergency_type": selectedOption.value,
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Data sent successfully!",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          "Error: ${response.body}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar("Failed", "$e", snackPosition: SnackPosition.BOTTOM);
    }
  }
}
 */
}
