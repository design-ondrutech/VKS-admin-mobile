// gold_dashboard_model.dart
class GoldDashboardModel {
  final double latestGoldWeight;
  final String latestBuyDate;
  final List<MonthlySummary> monthlySummary;
  final List<SchemeMonthlySummary> schemeMonthlySummary;

  GoldDashboardModel({
    required this.latestGoldWeight,
    required this.latestBuyDate,
    required this.monthlySummary,
    required this.schemeMonthlySummary,
  });

  factory GoldDashboardModel.fromJson(Map<String, dynamic> json) {
    return GoldDashboardModel(
      latestGoldWeight: (json['latest_gold_weight'] as num).toDouble(),
      latestBuyDate: json['latest_buy_date'] as String,
      monthlySummary: (json['monthly_summary'] as List)
          .map((e) => MonthlySummary.fromJson(e))
          .toList(),
      schemeMonthlySummary: (json['scheme_monthly_summary'] as List)
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
      month: json['month'],
      goldBought: (json['gold_bought'] as num).toDouble(),
    );
  }
}

class SchemeMonthlySummary {
  final String schemeName;
  final String month;
  final int customerCount;
  final double totalGoldBought;

  SchemeMonthlySummary({
    required this.schemeName,
    required this.month,
    required this.customerCount,
    required this.totalGoldBought,
  });

  factory SchemeMonthlySummary.fromJson(Map<String, dynamic> json) {
    return SchemeMonthlySummary(
      schemeName: json['scheme_name'],
      month: json['month'],
      customerCount: json['customer_count'] as int,
      totalGoldBought: (json['total_gold_bought'] as num).toDouble(),
    );
  }
}
