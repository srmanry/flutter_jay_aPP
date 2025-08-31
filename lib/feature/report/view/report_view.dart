import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/feature/report/controller/report_controller.dart';

class ReportScreenView extends StatelessWidget {
  ReportScreenView({super.key});

  final ReportController controller = Get.put(ReportController());

  final TextStyle textStyle = const TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Report"),
            SizedBox(width: 10),
            Icon(Icons.report_outlined, size: 30),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Event", style: textStyle),
              const SizedBox(height: 10),
              TextField(
                controller: controller.titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Title',
                ),
              ),
              const SizedBox(height: 15),
              Text("Description", style: textStyle),
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
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.options.length,
                    itemBuilder: (context, index) {
                      final item = controller.options[index];
                      final label = item["label"] as String;
                      final color = item["color"] as Color;

                      return RadioListTile<String>(
                        value: label,
                        groupValue: controller.selectedOption.value,
                        onChanged: (String? value) {
                          if (value != null) {
                            controller.selectedOption.value = value;
                          }
                        },
                        title: Row(
                          children: [
                            Text(label),
                            const SizedBox(width: 8),
                            Icon(Icons.location_on, color: color),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {},
                  //  onPressed: controller.submitData,
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
