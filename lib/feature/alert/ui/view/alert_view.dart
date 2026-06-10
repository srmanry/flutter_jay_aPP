import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/widgets/list/paginated_list.dart';
import '../../../profile/presentation/controller/theme_controller.dart';
import '../../controller/alert_controller.dart';
import '../../model/alert_model.dart';

class AlertScreen extends StatelessWidget {
  final AlertController controller = Get.put(AlertController());
  final ThemeController themeController = Get.put(ThemeController());
  AlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios_rounded),
        ),
        elevation: 0,
        centerTitle: true,
        title: Text("Notifications"),
        /*  actions: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(controller.alerts.value.data.length.toString(),style: TextStyle(color: Colors.red),),
        )],*/
      ),
      body: PaginatedListWidget(
        pagination: controller.alerts,
        emptyMessage: "No alerts!!",
        onRefresh: () {
          controller.fetchAlerts(forceFetch: true);
        },
        skeleton: Center(
          child: SizedBox(height: 30, width: 30, child: Center(child: CircularProgressIndicator())),
        ),
        skeletonCount: 1,
        builder: (index, data) {
          return notificationCard(data);
        },
      ),
    );
  }

  Widget notificationCard(AlertModel alert) {
    final ThemeController themeController = Get.put(ThemeController());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(color: themeController.isDarkMode.value ? Colors.white : Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                alert.report?.title ?? "..",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                textAlign: TextAlign.start,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(alert.report?.description ?? "..", textAlign: TextAlign.start),
              ),
              Text(DateFormat('yyyy-MM-dd – hh:mm a').format(alert.createdAt.toLocal()), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              //Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
