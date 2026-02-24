class SubscriptionPlan {
  final String name;
  final double priceMonthly;
  final double priceYearly;
  final List<String> benefits;

  SubscriptionPlan({
    required this.name,
    required this.priceMonthly,
    required this.priceYearly,
    required this.benefits,
  });
}