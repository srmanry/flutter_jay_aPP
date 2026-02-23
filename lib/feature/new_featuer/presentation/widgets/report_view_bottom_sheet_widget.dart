import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spotem/core/utils/app_colors.dart';

import '../../../home/data/model/reports_model.dart';

Widget reportViewCustomBottomSheet(ReportModel report) {
  final formattedTime = DateFormat('dd MMM yyyy, hh:mm a').format(report.createdAt);

  // display
  Text("Post: $formattedTime");
  return DraggableScrollableSheet(
    initialChildSize: 0.3,
    minChildSize: 0.2,
    maxChildSize: 0.7,
    builder: (context, scrollController) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -5))],
        ),
        child: ListView(
          controller: scrollController,
          children: [
            Text(report.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(report.description),
            const SizedBox(height: 16),
            //Text("Post : ${report.createdAt}"),
            Text(DateFormat('yyyy-MM-dd – hh:mm a').format(report.createdAt), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
            Text("${report.placeName}"),
            SizedBox(height: 20),
            Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppColors.appColor,
                        borderRadius: BorderRadius.circular(50),
                        // border: Border.all(width: 1.5, color: Colors.white),
                      ),
                      child: Center(
                        child: Text(
                          "Go",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Image.asset("assets/icons/run.png", height: 30, color: Colors.red),
                  ],
                ),

                // AnimatedGoButton(onTap: () {}),
                ElevatedButton(
                  onPressed: () {
                    // কোনো action
                    Get.back(); // bottom sheet close
                  },
                  child: const Text("Close"),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
