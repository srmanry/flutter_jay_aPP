class SubscriptionPlan {
  final String id;
  final String name;
  final double priceMonthly;
  final double priceYearly;
  final List<String> benefits;
  final bool isActive;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.priceMonthly,
    required this.priceYearly,
    required this.benefits,
    required this.isActive,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    final benefitsRaw = json["benefits"];
    final benefits = benefitsRaw is List ? benefitsRaw.map((e) => e.toString()).toList() : <String>[];

    return SubscriptionPlan(
      id: json["_id"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      benefits: benefits,
      priceMonthly: (json["priceMonthly"] as num?)?.toDouble() ?? 0.0,
      priceYearly: (json["priceYearly"] as num?)?.toDouble() ?? 0.0,
      isActive: json["isActive"] == true,
    );
  }
}
