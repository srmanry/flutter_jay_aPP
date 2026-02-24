import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/feature/subscription/controller/subscription_controller.dart';

import '../../../core/utils/app_colors.dart';
import '../widget/subscritption_card.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

final SubscriptionController subscriptionController = Get.put(SubscriptionController());

class _SubscriptionViewState extends State<SubscriptionView> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < subscriptionController.subscriptionPlans.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.appColor, AppColors.appColor.withOpacity(0.8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Content
              Expanded(
                child: Obx(() {
                  if (subscriptionController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  }

                  if (subscriptionController.subscriptionPlans.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.card_membership, size: 80, color: Colors.white54),
                          const SizedBox(height: 20),
                          const Text(
                            "No Subscription Plans Found",
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.appColor),
                            child: const Text("Refresh"),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      // Page View
                      Expanded(
                        child: PageView.builder(
                          controller: _controller,
                          itemCount: subscriptionController.subscriptionPlans.length,
                          onPageChanged: (index) {
                            setState(() => _currentPage = index);
                          },
                          itemBuilder: (context, index) {
                            final plan = subscriptionController.subscriptionPlans[index];
                            return SubscritptionCard(
                              title: plan.name ?? "Unknown Plan",
                              data: plan.priceMonthly == 0
                                  ? "Free (With Ads)"
                                  : "\$${plan.priceMonthly} /Month or\n\$${plan.priceYearly.toInt()}/Year",
                              monthly: plan.priceMonthly.toString(),
                              yearly: plan.priceYearly.toString(),
                              widget: SingleChildScrollView(
                                child: Column(children: plan.benefits.map((benefit) => rowTextWidget(benefit)).toList()),
                              ),
                            );
                          },
                        ),
                      ),

                      // Page Indicator
                      _buildPageIndicator(),

                      const SizedBox(height: 20),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              const Text(
                'Subscription Plans',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 48), // Placeholder for balance
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(30)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                SizedBox(width: 8),
                Text(
                  "Choose a plan to unlock premium features",
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Feature highlights
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFeatureItem(Icons.access_time, "Cancel Anytime"),
              _buildFeatureItem(Icons.verified_user, "Secure Payment"),
              _buildFeatureItem(Icons.support_agent, "24/7 Support"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(subscriptionController.subscriptionPlans.length, (index) {
          final bool isActive = _currentPage == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: isActive ? 24 : 8,
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}

/// --- BENEFIT ROW WIDGET ---
Widget rowTextWidget(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        const Icon(Icons.check_circle_outline, color: Colors.white),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
