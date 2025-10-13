import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/common/widgets/list/paginated_list.dart';
import 'package:spotem/feature/alert/model/alert_model.dart';
import '../../controller/alert_controller.dart';

class AlertScreen extends StatelessWidget {
  final AlertController controller = Get.put(AlertController());

  AlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Notifications"),
      ),
      body: PaginatedListWidget(
        pagination: controller.alerts,
        emptyMessage: "No alerts!!",
        onRefresh: () {
          controller.fetchAlerts(forceFetch: true);
        },
        skeleton: Center(
          child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()),
        ), skeletonCount: 1,
        builder: (index, data) {
          return notificationCard(data);
        },
      )
    );
  }

  Widget notificationCard(AlertModel alert) {
    // TODO:: replace [Container] with notification card;
    return Container();
  }
}


