
import 'package:get/get.dart';
import 'package:spotem/core/common/custom_massage.dart';
import 'package:spotem/core/network/api_service/api_client.dart';
import 'package:spotem/core/network/api_service/api_endpoints.dart';
import '../model/subsicription_model.dart';

class SubscriptionController extends GetxController {
  var selectedPlan = 'Monthly'.obs;
  var isLoading = false.obs;
  var isPaying = false.obs;

  //  Correctly typed RxList
  var subscriptionPlans = <SubscriptionPlan>[].obs;

  //  PageView এর index track করতে
  var selectedIndex = 0.obs;

  Future<void> fetchPlans({required bool activeOnly}) async {
    final apiClient = Get.find<ApiClient>();
    try {
      isLoading.value = true;
      final response = await apiClient.get(SubscriptionEndpoints.getAll, query: {"activeOnly": activeOnly});

      if (response.statusCode == 200 && response.data is Map && response.data["success"] == true) {
        final raw = response.data["data"];
        if (raw is List) {
          subscriptionPlans.assignAll(
            raw
                .whereType<Map>()
                .map((e) => SubscriptionPlan.fromJson(Map<String, dynamic>.from(e))),
          );
        } else {
          subscriptionPlans.clear();
        }
        return;
      }

      final message = (response.data is Map ? response.data["message"] : null)?.toString() ?? "Failed to load subscriptions";
      CustomShowMessage.error(message: message);
      subscriptionPlans.clear();
    } catch (e) {
      CustomShowMessage.error(message: e.toString());
      subscriptionPlans.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<({String clientSecret, String paymentIntentId})?> createPayment({
    required String userId,
    required String subscriptionId,
    required double price,
    required String billingPeriod, // monthly/yearly
  }) async {
    final apiClient = Get.find<ApiClient>();
    try {
      isPaying.value = true;
      final response = await apiClient.post(
        PaymentEndpoints.createPayment,
        data: {
          "userId": userId,
          "price": price,
          "subscriptionId": subscriptionId,
          "billingPeriod": billingPeriod,
        },
      );

      if (response.statusCode == 200 && response.data is Map && response.data["success"] == true) {
        final clientSecret = response.data["clientSecret"]?.toString() ?? "";
        final paymentIntentId = response.data["paymentIntentId"]?.toString() ?? "";
        if (clientSecret.isEmpty || paymentIntentId.isEmpty) {
          CustomShowMessage.error(message: "Invalid payment response");
          return null;
        }
        return (clientSecret: clientSecret, paymentIntentId: paymentIntentId);
      }

      final message = (response.data is Map ? response.data["error"] ?? response.data["message"] : null)?.toString() ?? "Failed to create payment";
      CustomShowMessage.error(message: message);
      return null;
    } catch (e) {
      CustomShowMessage.error(message: e.toString());
      return null;
    } finally {
      isPaying.value = false;
    }
  }

  Future<bool> confirmPayment({required String paymentIntentId}) async {
    final apiClient = Get.find<ApiClient>();
    try {
      isPaying.value = true;
      final response = await apiClient.post(
        PaymentEndpoints.confirmPayment,
        data: {"paymentIntentId": paymentIntentId},
      );

      if (response.statusCode == 200 && response.data is Map && response.data["success"] == true) {
        return true;
      }

      final status = (response.data is Map ? response.data["status"] : null)?.toString();
      final error = (response.data is Map ? response.data["error"] ?? response.data["message"] : null)?.toString() ?? "Payment did not succeed";
      CustomShowMessage.error(message: status == null ? error : "$error ($status)");
      return false;
    } catch (e) {
      CustomShowMessage.error(message: e.toString());
      return false;
    } finally {
      isPaying.value = false;
    }
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
