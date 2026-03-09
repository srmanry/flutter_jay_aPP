import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotem/core/utils/app_colors.dart';
import 'package:spotem/feature/new_featuer/presentation/view/cleancode_new_feature_screen_view.dart';

import '../controller/subscription_controller.dart';

class SubscriptionPurchaseView extends StatefulWidget {
  const SubscriptionPurchaseView({super.key});

  @override
  State<SubscriptionPurchaseView> createState() => _SubscriptionPurchaseViewState();
}

class _SubscriptionPurchaseViewState extends State<SubscriptionPurchaseView> {
  bool isExpanded = false;
  bool isPaymentSelected = false;
  String selectedPayment = '';
  final arg = Get.arguments;

  late final SubscriptionController subscriptionController;
  late final Map<dynamic, dynamic> argsMap;
  late final double monthlyPrice;
  late final double yearlyPrice;

  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController countryController;
  late TextEditingController couponController;

  double _parsePrice(dynamic value, {required double fallback}) {
    if (value == null) return fallback;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? fallback;
  }

  double _selectedTotal() {
    return subscriptionController.selectedPlan.value == 'Monthly' ? monthlyPrice : yearlyPrice;
  }

  String _selectedTotalLabel() {
    if (subscriptionController.selectedPlan.value == 'Monthly') {
      return '\$${monthlyPrice.toStringAsFixed(2)}/month';
    }
    return '\$${yearlyPrice.toStringAsFixed(2)}/year';
  }

  @override
  void initState() {
    super.initState();
    subscriptionController = Get.isRegistered<SubscriptionController>()
        ? Get.find<SubscriptionController>()
        : Get.put(SubscriptionController());

    argsMap = arg is Map ? (arg as Map) : <dynamic, dynamic>{};
    double fallbackMonthly = 0.0;
    double fallbackYearly = 0.0;
    if (subscriptionController.subscriptionPlans.isNotEmpty) {
      final plan = subscriptionController.subscriptionPlans[subscriptionController.selectedIndex.value];
      fallbackMonthly = plan.priceMonthly;
      fallbackYearly = plan.priceYearly;
    }
    monthlyPrice = _parsePrice(argsMap['monthly'], fallback: fallbackMonthly);
    yearlyPrice = _parsePrice(argsMap['yearly'], fallback: fallbackYearly);

    emailController = TextEditingController();
    phoneController = TextEditingController();
    countryController = TextEditingController();
    couponController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    countryController.dispose();
    couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fieldColor,
      appBar: AppBar(
        backgroundColor: AppColors.appColor,
        elevation: 0,
        title: const Text(
          'Subscription Purchase',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan Info Card
            _buildPlanInfoCard(),
            const SizedBox(height: 20),

            // Plan Selection
            _buildSectionTitle("Choose Your Subscription Plan"),
            const SizedBox(height: 12),
            _buildPlanSelector(),
            const SizedBox(height: 24),

      /*       // Billing Information
            _buildSectionTitle("Billing Information"),
            const SizedBox(height: 12),
            _buildBillingSection(),
            const SizedBox(height: 24),

            // Coupon Code
            _buildSectionTitle("Coupon Code (Optional)"),
            const SizedBox(height: 12),
            _buildCouponSection(),
            const SizedBox(height: 24),
 */
            // Payment Method
            _buildSectionTitle("Payment Method"),
            const SizedBox(height: 12),
            _buildPaymentMethod(),
            const SizedBox(height: 32),

            // Submit Button
            _buildSubmitButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.appColor, AppColors.appColor.withValues(alpha: 0.7)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.appColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.workspace_premium, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Premium Plan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  argsMap['planName']?.toString() ?? "Premium Subscription",
                  style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.9)),
                ),
              ],
            ),
          ),
          Obx(() {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Text(
                '\$${_selectedTotal().toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.appColor),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3D3E40)),
    );
  }

  Widget _buildPlanSelector() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildPlanOption(
                    title: 'Monthly',
                    price: '\$${monthlyPrice.toStringAsFixed(2)}/month',
                    isSelected: subscriptionController.selectedPlan.value == 'Monthly',
                    onTap: () => subscriptionController.changePlan('Monthly'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPlanOption(
                    title: 'Yearly',
                    price: '\$${yearlyPrice.toStringAsFixed(2)}/year',
                    isSelected: subscriptionController.selectedPlan.value == 'Yearly',
                    onTap: () => subscriptionController.changePlan('Yearly'),
                    isPopular: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.appColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF3D3E40)),
                  ),
                  Text(
                    '\$${_selectedTotal().toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.appColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPlanOption({
    required String title,
    required String price,
    required bool isSelected,
    required VoidCallback onTap,
    bool isPopular = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.appColor.withValues(alpha: 0.1) : AppColors.fieldColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.appColor : Colors.transparent, width: 2),
        ),
        child: Column(
          children: [
            if (isPopular)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(10)),
                child: const Text(
                  'POPULAR',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSelected ? AppColors.appColor : const Color(0xFF3D3E40)),
            ),
            const SizedBox(height: 4),
            Text(price, style: TextStyle(fontSize: 12, color: isSelected ? AppColors.appColor : Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          _buildTextField(
            label: "Email Address",
            hint: "Enter your email",
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: "Phone Number",
            hint: "Enter your number",
            controller: phoneController,
            keyboardType: TextInputType.phone,
            icon: Icons.phone_outlined,
          ),
          const SizedBox(height: 16),
          _buildTextField(label: "Country", hint: "Enter your country", controller: countryController, icon: Icons.public),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) Icon(icon, size: 18, color: AppColors.appColor),
            if (icon != null) const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF3D3E40)),
            ),
            const Text(
              ' *',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.red),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.fieldColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.appColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildCouponSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: couponController,
              decoration: InputDecoration(
                hintText: "Enter coupon code",
                filled: true,
                fillColor: AppColors.fieldColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(color: AppColors.appColor, borderRadius: BorderRadius.circular(12)),
            child: TextButton(
              onPressed: () {
                Get.snackbar(
                  'Coupon',
                  'Coupon applied successfully!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
              child: const Text(
                'Apply',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          _buildPaymentOption(
            title: 'Stripe',
            icon: Icons.credit_card,
            isSelected: selectedPayment == 'stripe',
            onTap: () {
              setState(() {
                selectedPayment = 'stripe';
                isPaymentSelected = true;
              });
            },
          ),
          const Divider(height: 1),
         /*  _buildPaymentOption(
            title: 'PayPal',
            icon: Icons.account_balance_wallet,
            isSelected: selectedPayment == 'paypal',
            onTap: () {
              setState(() {
                selectedPayment = 'paypal';
                isPaymentSelected = true;
              });
            },
          ), */
        ],
      ),
    );
  }

  Widget _buildPaymentOption({required String title, required IconData icon, required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.appColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: AppColors.appColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF3D3E40)),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? AppColors.appColor : Colors.grey, width: 2),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.appColor),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Obx(() {
        return ElevatedButton(
          onPressed: () {
            if (!isPaymentSelected) {
              Get.snackbar(
                'Error',
                'Please select a payment method',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }
            Get.to(() => CleancodeNewFeatureScreenView());
            Get.snackbar(
              'Success',
              'Subscription submitted successfully!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.appColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
          ),
          child: Text(
            'Subscribe Now (${_selectedTotalLabel()})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }),
    );
  }
}
