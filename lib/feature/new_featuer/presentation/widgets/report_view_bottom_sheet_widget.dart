/* import 'package:flutter/material.dart';
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
            Text(report.type, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(DateFormat('yyyy-MM-dd – hh:mm a').format(report.createdAt), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),

            SizedBox(height: 20),
            Text(report.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(report.description),
            const SizedBox(height: 16),
            //Text("Post : ${report.createdAt}"),
            Text(DateFormat('yyyy-MM-dd – hh:mm a').format(report.createdAt), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
            //Text("${report.placeName}"),
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
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../home/data/model/reports_model.dart';
import '../../../subscription/view/subscription_view.dart';
import 'subscrib_card.dart';

Widget reportViewCustomBottomSheet(ReportModel report, {String? distance}) {
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

              CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQH27gW63-UiRIoWc47Syd9CleQ5dNtO1kLLA&s",
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(report.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(report.description),
          const SizedBox(height: 16),

          /*      SizedBox(
            height: 135,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  height: 100,
                  width: 110,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.blue[200]),
                  child: Icon(Icons.photo),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    height: 100,
                    width: 110,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.blue[200]),
                    child: Icon(Icons.photo),
                  ),
                ),
                Container(
                  height: 100,
                  width: 110,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.blue[200]),
                  child: Icon(Icons.photo),
                ),
              ],
            ),
          ), */
          // Text(formattedTime, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  /*   GestureDetector(
                    onTap: () {
                      // Go button tap logic (map open etc)
                      Get.dialog()
                    },
                    child: Container(
                      height: 40,
                      //width: 0,
                      decoration: BoxDecoration(color: AppColors.appColor, borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Center(
                          child: Text(
                            "Go",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ), */
                  InkWell(
                    onTap: () {
                      // Get.to(() => SubscriptionScreen());
                      Get.to(() => SubscriptionView());
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(color: AppColors.appColor, borderRadius: BorderRadius.circular(50)),
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
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [Icon(Icons.directions_walk), SizedBox(width: 8), Icon(Icons.moving)]),

                  SizedBox(width: 20),
                  Text(distance ?? "0 কি.মি", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),

          SizedBox(height: 20),
          SizedBox(
            height: 48,
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () {
                Get.back(); // Close bottom sheet
              },
              child: const Text("Close"),
            ),
          ),
        ],
      ),
    ),
  );
}
