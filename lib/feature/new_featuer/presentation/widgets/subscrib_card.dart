import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/common/custom_massage.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text("Subscription", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(borderRadius: BorderRadiusGeometry.circular(10), child: Image.asset("assets/icons/mapt1.png")),

            Text(""),

            /*  /// Top Icon
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(50)),
              child: const Icon(Icons.workspace_premium, size: 50, color: Colors.blue),
            ),

            const SizedBox(height: 20), */
            const Text("Upgrade to Pro Tracker", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            const Text(
              "Enhanced alerts and detailed tracking\nfor law enforcement vehicles.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            /// Price Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
              ),
              child: Column(
                children: const [
                  Text("9.99\$ / Month", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text("Cancel anytime", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            const Spacer(),

            /// Subscribe Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                 // Get.snackbar("Success", "Subscription Activated!", backgroundColor: Colors.green, colorText: Colors.white);
                  CustomShowMessage.success(message: "Subscription Activated!");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A6CF7),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Subscribe Now", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
