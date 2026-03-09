import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../home/data/model/reports_model.dart';
import '../../../subscription/view/subscription_view.dart';

Widget reportViewCustomBottomSheet(ReportModel report, {String? distance, VoidCallback? onGoPressed}) {
  final formattedTime = DateFormat('dd MMM yyyy, hh:mm a').format(report.createdAt);

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -5))],
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(report.type, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(formattedTime, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                ],
              ),

              CircleAvatar(backgroundImage: NetworkImage(report.user.avatar.url), radius: 20),
            ],
          ),
          const SizedBox(height: 20),
          Text(report.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(report.description),
          const SizedBox(height: 16),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /*    Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back(); // Close bottom sheet
                      onGoPressed?.call();
                    },
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(color: AppColors.appColor, borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Text(
                          "Go",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Image.asset("assets/icons/run.png", height: 30, color: Colors.red),
                ],
              ), */
              /*   Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [Icon(Icons.directions_walk), SizedBox(width: 8), Icon(Icons.moving)]),

                  SizedBox(width: 20),
                  // Text(distance ?? "Calculating...", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(distance ?? "0.00 KM / 0 m", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ), */
            ],
          ),

          SizedBox(height: 20),
          SizedBox(
            height: 48,
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () {
                // Get.back(); // Close bottom sheet
                onGoPressed?.call();
                //Get.to(() => SubscriptionView());
              },
              child: const Text("Start Tracking", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    ),
  );
}
