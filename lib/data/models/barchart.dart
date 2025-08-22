class GoldDashboard {
  final String latestBuyDate;
  final double latestGoldWeight;
  final List<MonthlySummary> monthlySummary;
  final List<SchemeMonthlySummary> schemeMonthlySummary;

  GoldDashboard({
    required this.latestBuyDate,
    required this.latestGoldWeight,
    required this.monthlySummary,
    required this.schemeMonthlySummary,
  });

  factory GoldDashboard.fromJson(Map<String, dynamic> json) {
    return GoldDashboard(
      latestBuyDate: json["latest_buy_date"] ?? "",
      latestGoldWeight: (json["latest_gold_weight"] ?? 0).toDouble(),
      monthlySummary: (json["monthly_summary"] as List)
          .map((e) => MonthlySummary.fromJson(e))
          .toList(),
      schemeMonthlySummary: (json["scheme_monthly_summary"] as List)
          .map((e) => SchemeMonthlySummary.fromJson(e))
          .toList(),
    );
  }
}

class MonthlySummary {
  final double goldBought;
  final String month;

  MonthlySummary({
    required this.goldBought,
    required this.month,
  });

  factory MonthlySummary.fromJson(Map<String, dynamic> json) {
    return MonthlySummary(
      goldBought: (json["gold_bought"] ?? 0).toDouble(),
      month: json["month"] ?? "",
    );
  }
}

class SchemeMonthlySummary {
  final int customerCount;
  final String month;
  final String schemeName;
  final double totalGoldBought;

  SchemeMonthlySummary({
    required this.customerCount,
    required this.month,
    required this.schemeName,
    required this.totalGoldBought,
  });

  factory SchemeMonthlySummary.fromJson(Map<String, dynamic> json) {
    return SchemeMonthlySummary(
      customerCount: json["customer_count"] ?? 0,
      month: json["month"] ?? "",
      schemeName: json["scheme_name"] ?? "",
      totalGoldBought: (json["total_gold_bought"] ?? 0).toDouble(),
    );
  }
}
