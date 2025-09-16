class GoldDashboard {
  final String? latestBuyDate;
  final double? latestGoldWeight;
  final List<MonthlySummary> monthlySummary;
  final List<SchemeMonthlySummary> schemeMonthlySummary;

  GoldDashboard({
    this.latestBuyDate,
    this.latestGoldWeight,
    required this.monthlySummary,
    required this.schemeMonthlySummary,
  });

  factory GoldDashboard.fromJson(Map<String, dynamic> json) {
    return GoldDashboard(
      latestBuyDate: json['latest_buy_date'],
      latestGoldWeight: (json['latest_gold_weight'] ?? 0).toDouble(),
      monthlySummary: (json['monthly_summary'] as List<dynamic>? ?? [])
          .map((e) => MonthlySummary.fromJson(e))
          .toList(),
      schemeMonthlySummary:
          (json['scheme_monthly_summary'] as List<dynamic>? ?? [])
              .map((e) => SchemeMonthlySummary.fromJson(e))
              .toList(),
    );
  }
}

class MonthlySummary {
  final String month;
  final double goldBought;

  MonthlySummary({required this.month, required this.goldBought});

  factory MonthlySummary.fromJson(Map<String, dynamic> json) {
    return MonthlySummary(
      month: json['month'] ?? '',
      goldBought: (json['gold_bought'] ?? 0).toDouble(),
    );
  }
}

class SchemeMonthlySummary {
  final String schemeName;
  final String month;
  final double totalGoldBought;
  final int customerCount;

  SchemeMonthlySummary({
    required this.schemeName,
    required this.month,
    required this.totalGoldBought,
    required this.customerCount,
  });

  factory SchemeMonthlySummary.fromJson(Map<String, dynamic> json) {
    return SchemeMonthlySummary(
      schemeName: json['scheme_name'] ?? '',
      month: json['month'] ?? '',
      totalGoldBought: (json['total_gold_bought'] ?? 0).toDouble(),
      customerCount: json['customer_count'] ?? 0,
    );
  }
}
