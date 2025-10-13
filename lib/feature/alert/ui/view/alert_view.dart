import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spotem/core/common/widgets/list/paginated_list.dart';
import 'package:spotem/feature/alert/model/alert_model.dart';
import '../../../../core/utils/app_colors.dart';
import '../../controller/alert_controller.dart';
import 'alart_map.dart';

class AlertScreen extends StatelessWidget {
  final AlertController controller = Get.put(AlertController());

  AlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(onTap: () {Get.back();}, child: Icon(Icons.arrow_back_ios_rounded)),
        elevation: 0,
        centerTitle: true,
        title: Text("Notifications"),
       /* actions: [Padding(
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),

        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //spacing: 8,
          children: [
            Text(alert.report?.title ?? "..",style: TextStyle(fontWeight: FontWeight.bold),),  SizedBox(height: 8,),

            Text(alert.report?.description ?? ".."),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text( DateFormat('dd MMM yyyy, hh:mm a') .format(alert.createdAt) ),
                InkWell(
                    onTap: () {
                      Get.to(() => AlertMapScreen());
                    },
                    child: Icon(Icons.location_on_outlined,color: AppColors.appColor,)),

              ],
            ),
           Divider(),
          ],
        ),
      ),
    );
  }
}


