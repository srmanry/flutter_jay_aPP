import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Notifications"),
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return Center(child: Text("No notifications"));
        }
        return ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (_, index) {
            return ListTile(
              title: Text(controller.notifications[index]),
            );
          },
        );
      }),
    );
  }
}
