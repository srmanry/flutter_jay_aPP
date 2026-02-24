import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/utils/app_colors.dart';

import '../view/subscriptio_purchase_view.dart';

class SubscritptionCard extends StatelessWidget {
  final String? title;
  final String? data;
  final String? monthly;
  final String? yearly;
  final Widget? widget;

  final Widget? rowTextWidget;
  const SubscritptionCard({super.key, this.title, this.widget, this.rowTextWidget, this.data, this.monthly, this.yearly});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(color: AppColors.appColor, borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Plan Name
              Text(
                title ?? "",
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),

              // Price
              Text(
                data ?? "",
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),

              const Divider(color: Colors.white),

              // What You Get Title
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "What You Get",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),

              // Benefits List with overflow handling
              SizedBox(height: 150, child: SingleChildScrollView(child: widget ?? const SizedBox())),

              const SizedBox(height: 20),

              // Subscribe Button
              SizedBox(
                width: double.infinity,
                height: 51,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(
                      () => SubscriptionPurchaseView(),
                      arguments: {"planName": title, "planData": data, "monthly": monthly, "yearly": yearly},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFCFDFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    "Subscribe",
                    style: TextStyle(color: AppColors.appColor, fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
