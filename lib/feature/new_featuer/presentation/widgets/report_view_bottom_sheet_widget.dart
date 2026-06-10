import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spotem/feature/profile/presentation/controller/profile_controller.dart';
import 'package:spotem/feature/subscription/view/subscription_view.dart';

import '../../../home/data/model/reports_model.dart';

Widget reportViewCustomBottomSheet(ReportModel report, {String? distance, VoidCallback? onGoPressed}) {
  final formattedTime = DateFormat('dd MMM yyyy, hh:mm a').format(report.createdAt);
  final profileController = Get.isRegistered<ProfileController>() ? Get.find<ProfileController>() : null;
  final avatarUrl = report.user.avatar.url;

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(report.type, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      formattedTime,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  Get.bottomSheet(_reporterDetailsSheet(report), backgroundColor: Colors.transparent, isScrollControlled: true);
                },
                child: ClipOval(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: avatarUrl.isNotEmpty
                        ? Image.network(
                            avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.person, color: Colors.grey),
                            ),
                          )
                        : Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.person, color: Colors.grey),
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(report.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(report.description, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const Icon(Icons.my_location_rounded, size: 18, color: Colors.black54),
                const SizedBox(width: 8),
                const Text(
                  "Distance:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    distance ?? "Calculating...",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          /* SizedBox(
            height: 48,
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () {
       
                if (isSubscribed) {
                  onGoPressed?.call();
                  return;
                }
             
              },
              child: const Text("Start Tracking", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ), */
          SizedBox(
            height: 48,
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () async {
                if (profileController != null) {
                  await profileController.fetchProfile();
                }
                final isSubscribed = profileController?.userData.value?.isSubsribed?.isTrueOrFalse == true;

                Get.back();
                if (isSubscribed) {
                  onGoPressed?.call();
                } else {
                  Get.to(() => const SubscriptionView());
                }
              },
              child: const Text("Start Tracking", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _reporterDetailsSheet(ReportModel report) {
  final avatarUrl = report.user.avatar.url;
  final reportTime = DateFormat('dd MMM yyyy, hh:mm a').format(report.createdAt);

  return Container(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Text("Reporter Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const Spacer(),
            IconButton(onPressed: Get.back, icon: const Icon(Icons.close_rounded)),
          ],
        ),
        const SizedBox(height: 8),
        CircleAvatar(
          radius: 34,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
          child: avatarUrl.isEmpty ? const Icon(Icons.person, size: 34, color: Colors.grey) : null,
        ),
        const SizedBox(height: 14),
        _reporterInfoRow("Name", report.user.name.isEmpty ? "N/A" : report.user.name),
        _reporterInfoRow("User ID", report.user.id.isEmpty ? "N/A" : report.user.id),
        _reporterInfoRow("Report Type", report.type.isEmpty ? "N/A" : report.type),
        _reporterInfoRow("Reported At", reportTime),
      ],
    ),
  );
}

Widget _reporterInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 92,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54),
          ),
        ),
        const Text(
          " : ",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
        ),
      ],
    ),
  );
}
