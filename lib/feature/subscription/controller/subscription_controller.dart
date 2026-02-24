/* import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  var selectedPlan = 'Monthly'.obs;
  var isLoading = false.obs;
  var subscriptionPlans = [].obs;
  double get currentPrice {
    final args = Get.arguments ?? {};
    final monthly = double.tryParse(args['monthly']?.toString() ?? '0') ?? 0.0;
    final yearly = double.tryParse(args['yearly']?.toString() ?? '0') ?? 0.0;

    return selectedPlan.value == 'Monthly' ? monthly : yearly;
  }

  void changePlan(String plan) {
    selectedPlan.value = plan;
  }
}
 */
import 'package:get/get.dart';
import '../model/subsicription_model.dart';

class SubscriptionController extends GetxController {
  var selectedPlan = 'Monthly'.obs;
  var isLoading = false.obs;

  // ✅ Correctly typed RxList
  var subscriptionPlans = <SubscriptionPlan>[].obs;

  // ✅ PageView এর index track করতে
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyPlans();
  }

  /// --- Dummy data load
  void loadDummyPlans() {
    isLoading.value = true;

    // Simulate loading delay
    Future.delayed(const Duration(seconds: 1), () {
      subscriptionPlans.value = [
        SubscriptionPlan(
          name: "Pro Plan",
          priceMonthly: 9.99,
          priceYearly: 99.99,
          benefits: ["All Features", "No Ads", "Unlimited Reports", "Priority Support"],
        ),
        SubscriptionPlan(
          name: "Enterprise Plan",
          priceMonthly: 19.99,
          priceYearly: 199.99,
          benefits: ["All Pro Features", "Dedicated Support", "Advanced Analytics", "Custom Branding"],
        ),
      ];

      isLoading.value = false;
    });
  }

  /// --- Current price based on selected plan & selected page
  double get currentPrice {
    if (subscriptionPlans.isEmpty) return 0.0;

    final plan = subscriptionPlans[selectedIndex.value];

    return selectedPlan.value == 'Monthly' ? plan.priceMonthly : plan.priceYearly;
  }

  /// --- Change Monthly/Yearly
  void changePlan(String plan) {
    selectedPlan.value = plan;
  }

  /// --- Change PageView index
  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
