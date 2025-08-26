class GoldDashboardModel {
  final double latestGoldWeight;      // numeric
  final String latestBuyDate;         // date as string
  final List<SchemeMonthlySummary> schemeMonthlySummary;
  final List<MonthlySummary> monthlySummary;

  GoldDashboardModel({
    required this.latestGoldWeight,
    required this.latestBuyDate,
    required this.schemeMonthlySummary,
    required this.monthlySummary,
  });

  factory GoldDashboardModel.fromJson(Map<String, dynamic> json) {
    return GoldDashboardModel(
      latestGoldWeight: (json['latest_gold_weight'] as num?)?.toDouble() ?? 0.0,
      latestBuyDate: json['latest_buy_date'] ?? '',
      schemeMonthlySummary: (json['scheme_monthly_summary'] as List? ?? [])
          .map((e) => SchemeMonthlySummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      monthlySummary: (json['monthly_summary'] as List? ?? [])
          .map((e) => MonthlySummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SchemeMonthlySummary {
  final int customerCount;
  final String month;
  final String schemeName;
  final double totalGoldBought; // numeric

  SchemeMonthlySummary({
    required this.customerCount,
    required this.month,
    required this.schemeName,
    required this.totalGoldBought,
  });

  factory SchemeMonthlySummary.fromJson(Map<String, dynamic> json) {
    return SchemeMonthlySummary(
      customerCount: (json['customer_count'] as num?)?.toInt() ?? 0,
      month: json['month'] ?? '',
      schemeName: json['scheme_name'] ?? '',
      totalGoldBought: (json['total_gold_bought'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class MonthlySummary {
  final double goldBought; // numeric
  final String month;

  MonthlySummary({
    required this.goldBought,
    required this.month,
  });

  factory MonthlySummary.fromJson(Map<String, dynamic> json) {
    return MonthlySummary(
      goldBought: (json['gold_bought'] as num?)?.toDouble() ?? 0.0,
      month: json['month'] ?? '',
    );
  }
}
