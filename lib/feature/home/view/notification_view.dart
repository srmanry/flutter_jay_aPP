import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/util/app_colors.dart';
import '../controller/notification_controller.dart';

class NotificationPage extends StatelessWidget {
  final controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios_rounded,color: AppColors.appColor,)),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: const Text('Notifications')),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return const Center(child: Text('No notifications yet.'));
        }
        return ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final n = controller.notifications[index];
            return ListTile(
              leading: Icon(
                n.isRead ? Icons.mark_email_read : Icons.mark_email_unread,
                color: n.isRead ? Colors.green : Colors.red,
              ),
              title: Text(n.title),
              subtitle: Text(n.message),
              trailing: !n.isRead
                  ? TextButton(
                onPressed: () => controller.markAsRead(n.id),
                child: const Text('Mark Read'),
              )
                  : null,
            );
          },
        );
      }),
    );
  }
}
