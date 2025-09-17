class DashboardSummary {
  final int totalCustomers;
  final double totalOnlinePayment;
  final double totalCashPayment;
  final int totalActiveSchemes;
  final int todayActiveSchemes;

  DashboardSummary({
    required this.totalCustomers,
    required this.totalOnlinePayment,
    required this.totalCashPayment,
    required this.totalActiveSchemes,
    required this.todayActiveSchemes,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      totalCustomers: (json['totalCustomers'] ?? 0) is int
          ? json['totalCustomers']
          : int.tryParse(json['totalCustomers'].toString()) ?? 0,

      totalOnlinePayment: (json['totalOnlinePayment'] ?? 0) is num
          ? (json['totalOnlinePayment'] as num).toDouble()
          : double.tryParse(json['totalOnlinePayment'].toString()) ?? 0.0,

      totalCashPayment: (json['totalCashPayment'] ?? 0) is num
          ? (json['totalCashPayment'] as num).toDouble()
          : double.tryParse(json['totalCashPayment'].toString()) ?? 0.0,

      totalActiveSchemes: (json['totalActiveSchemes'] ?? 0) is int
          ? json['totalActiveSchemes']
          : int.tryParse(json['totalActiveSchemes'].toString()) ?? 0,

      todayActiveSchemes: (json['todayActiveSchemes'] ?? 0) is int
          ? json['todayActiveSchemes']
          : int.tryParse(json['todayActiveSchemes'].toString()) ?? 0,
    );
  }
}
