import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/utils/app_colors.dart';
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

  @override
  void initState() {
    super.initState();
    subscriptionController = Get.isRegistered<SubscriptionController>() ? Get.find<SubscriptionController>() : Get.put(SubscriptionController());
    if (subscriptionController.subscriptionPlans.isEmpty) {
      subscriptionController.fetchPlans(activeOnly: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.appColor.withValues(alpha: 0.12), const Color(0xFFF5F8FC), const Color(0xFFF5F8FC)],
              stops: const [0.0, 0.22, 1.0],
            ),
          ),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Obx(() {
                  if (subscriptionController.isLoading.value) {
                    return Center(child: CircularProgressIndicator(color: AppColors.appColor));
                  }

                  final plans = subscriptionController.subscriptionPlans;

                  if (plans.isEmpty) {
                    return Center(
                      child: Text(
                        "No subscription plans found",
                        style: const TextStyle(color: Color(0xFF1F2937), fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    );
                  }

                  final SubscriptionPlan plan = plans.first;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildSubscriptionCard(context, plan),
                  );
                }),
              ),
              _buildBottomSubscribeBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          IconButton(
            style: IconButton.styleFrom(backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1F2937), size: 18),
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Text(
              "Subscription Plans",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF111827), fontSize: 21, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildBottomSubscribeBar() {
    return Obx(() {
      if (subscriptionController.isLoading.value) {
        return const SizedBox(height: 20);
      }

      final plans = subscriptionController.subscriptionPlans;

      if (plans.isEmpty) return const SizedBox.shrink();

      final SubscriptionPlan plan = plans.first;

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
                    "subscriptionId": plan.id,
                    "planData": "\$${plan.priceMonthly.toStringAsFixed(2)} /Month or \$${plan.priceYearly.toStringAsFixed(2)} /Year",
                    "monthly": plan.priceMonthly.toStringAsFixed(2),
                    "yearly": plan.priceYearly.toStringAsFixed(2),
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: AppColors.appColor.withValues(alpha: 0.35),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Subscribe Now", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                    "\$${plan.priceMonthly.toStringAsFixed(2)}/mo • \$${plan.priceYearly.toStringAsFixed(2)}/yr",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.92)),
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
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.appColor.withValues(alpha: 0.14)),
              boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 16, offset: Offset(0, 8))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(12)),
                    child: Image.asset("assets/icons/mapt1.png", height: 280, fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          cardTitle.isEmpty ? plan.name : cardTitle,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.3, color: Color(0xFF111827)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _descriptionFromBenefits(plan),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, height: 1.45, color: Color(0xFF4B5563)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          "\$${plan.priceMonthly.toStringAsFixed(2)}/month  •  \$${plan.priceYearly.toStringAsFixed(2)}/year",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.2, color: AppColors.appColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        "What you get",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
                      ),
                      const SizedBox(height: 10),
                      ...plan.benefits.map(
                        (b) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Icon(Icons.check_circle, size: 18, color: AppColors.appColor),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  b,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF374151)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
