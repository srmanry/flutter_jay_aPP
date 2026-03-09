import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotem/feature/subscription/controller/subscription_controller.dart';

import '../model/subsicription_model.dart';
import 'subscriptio_purchase_view.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  late final SubscriptionController subscriptionController;

  // incoming data আলাদা list এ রাখলাম
  final List<SubscriptionPlan> _planList = [];

  @override
  void initState() {
    super.initState();
    subscriptionController = Get.isRegistered<SubscriptionController>() ? Get.find<SubscriptionController>() : Get.put(SubscriptionController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8E6F0),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                if (subscriptionController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF476BD3)));
                }

                // controller থেকে আসা data আলাদা list এ রাখলাম
                _planList
                  ..clear()
                  ..addAll(subscriptionController.subscriptionPlans);

                if (_planList.isEmpty) {
                  return Center(
                    child: Text(
                      "No subscription plans found",
                      style: GoogleFonts.manrope(color: const Color(0xFF1F2937), fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  );
                }

                // শুধু একটা item/card দেখাবে
                final SubscriptionPlan plan = _planList.first;

                return Padding(padding: const EdgeInsets.only(bottom: 10), child: _buildSubscriptionCard(context, plan));
              }),
            ),
            _buildBottomSubscribeBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1F2937)),
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Text(
              "Subscription Plans",
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(color: const Color(0xFF111827), fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildBottomSubscribeBar() {
    return Obx(() {
      if (subscriptionController.isLoading.value) {
        return const SizedBox(height: 20);
      }

      _planList
        ..clear()
        ..addAll(subscriptionController.subscriptionPlans);

      if (_planList.isEmpty) return const SizedBox.shrink();

      final SubscriptionPlan plan = _planList.first;

      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SizedBox(
            width: double.infinity,
            height: 62,
            child: ElevatedButton(
              onPressed: () {
                Get.to(
                  () => const SubscriptionPurchaseView(),
                  arguments: {
                    "planName": plan.name,
                    "planData": "\$${plan.priceMonthly.toStringAsFixed(2)} /Month or \$${plan.priceYearly.toStringAsFixed(2)} /Year",
                    "monthly": plan.priceMonthly.toStringAsFixed(2),
                    "yearly": plan.priceYearly.toStringAsFixed(2),
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF476BD3),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Subscribe Now", style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(
                    "\$${plan.priceMonthly.toStringAsFixed(2)}/mo • \$${plan.priceYearly.toStringAsFixed(2)}/yr",
                    style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.92)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSubscriptionCard(BuildContext context, SubscriptionPlan plan) {
    final cardTitle = plan.name.replaceAll("Plan", "Tracker").trim();

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 8, 6, 4),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF6F7F9),
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [BoxShadow(color: Color(0x26000000), blurRadius: 22, offset: Offset(0, 10))],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(22), bottom: Radius.circular(12)),
                    child: Image.asset("assets/icons/mapt1.png", height: 280, fit: BoxFit.cover),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            cardTitle.isEmpty ? plan.name : cardTitle,
                            style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: -0.6, color: const Color(0xFF111827)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _descriptionFromBenefits(plan),
                          style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w500, height: 1.45, color: const Color(0xFF4B5563)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            "\$${plan.priceMonthly.toStringAsFixed(2)}/month  •  \$${plan.priceYearly.toStringAsFixed(2)}/year",
                            style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.6, color: const Color(0xFF111827)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          "What you get",
                          style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF111827)),
                        ),
                        const SizedBox(height: 10),
                        ...plan.benefits.map(
                          (b) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 3),
                                  child: Icon(Icons.check_circle, size: 18, color: Color(0xFF476BD3)),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    b,
                                    style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF374151)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _descriptionFromBenefits(SubscriptionPlan plan) {
    if (plan.benefits.isEmpty) {
      return "Enhanced alerts and detailed tracking for law enforcement vehicles.";
    }

    final feature1 = plan.benefits.first.toLowerCase();
    final feature2 = plan.benefits.length > 1 ? plan.benefits[1].toLowerCase() : "priority tracking";

    return "Enhanced $feature1 and $feature2 for law enforcement vehicles.";
  }
}
