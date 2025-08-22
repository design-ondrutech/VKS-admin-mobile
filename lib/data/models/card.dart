class DashboardSummary {
  final int totalCustomers;
  final double totalOnlinePayment;
  final double totalCashPayment;
  final int totalActiveSchemes;

  DashboardSummary({
    required this.totalCustomers,
    required this.totalOnlinePayment,
    required this.totalCashPayment,
    required this.totalActiveSchemes,
  });

  // From JSON (GraphQL response)
  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      totalCustomers: json['totalCustomers'] ?? 0,
      totalOnlinePayment: (json['totalOnlinePayment'] ?? 0).toDouble(),
      totalCashPayment: (json['totalCashPayment'] ?? 0).toDouble(),
      totalActiveSchemes: json['totalActiveSchemes'] ?? 0,
    );
  }
}
