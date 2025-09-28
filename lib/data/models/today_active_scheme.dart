import 'package:admin/data/models/customer.dart';

double parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is bool) return value ? 1.0 : 0.0;
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

class TotalActiveSchemeResponse {
  final List<TotalActiveScheme> data;
  final int limit;
  final int page;
  final int totalCount;

  TotalActiveSchemeResponse({
    required this.data,
    required this.limit,
    required this.page,
    required this.totalCount,
  });

  factory TotalActiveSchemeResponse.fromJson(Map<String, dynamic> json) {
    return TotalActiveSchemeResponse(
      data: (json['data'] as List? ?? [])
          .map((e) => TotalActiveScheme.fromJson(e))
          .toList(),
      limit: json['limit'] ?? 0,
      page: json['page'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
    );
  }

  ///  copyWith added
  TotalActiveSchemeResponse copyWith({
    List<TotalActiveScheme>? data,
    int? limit,
    int? page,
    int? totalCount,
  }) {
    return TotalActiveSchemeResponse(
      data: data ?? this.data,
      limit: limit ?? this.limit,
      page: page ?? this.page,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

class TotalActiveScheme {
  final String savingId;
  final double paidAmount;
  final Customer customer;
  final String schemeType;
  final String schemeId;
  final String startDate;
  final String endDate;
  final String status;
  final double totalGoldWeight;
  final String lastUpdated;
  final String schemePurpose;
  final String schemeName;
  final bool isKyc;
  final bool isCompleted;
  final double percentage;
  final double totalAmount;
  final double goldDelivered;
  final double deliveredGoldWeight;
  final double pendingGoldWeight;
  final double pendingAmount;
  final List<History> history;

  TotalActiveScheme({
    required this.savingId,
    required this.paidAmount,
    required this.customer,
    required this.schemeType,
    required this.schemeId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.totalGoldWeight,
    required this.lastUpdated,
    required this.schemePurpose,
    required this.schemeName,
    required this.isKyc,
    required this.isCompleted,
    required this.percentage,
    required this.totalAmount,
    required this.goldDelivered,
    required this.deliveredGoldWeight,
    required this.pendingGoldWeight,
    required this.pendingAmount,
    required this.history,
  });

  factory TotalActiveScheme.fromJson(Map<String, dynamic> json) {
    return TotalActiveScheme(
      savingId: json['saving_id']?.toString() ?? '',
      paidAmount: parseDouble(json['paidAmount']),
      customer: Customer.fromJson(json['customer'] ?? {}),
      schemeType: json['scheme_type']?.toString() ?? '',
      schemeId: json['scheme_id']?.toString() ?? '',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      totalGoldWeight: parseDouble(json['total_gold_weight']),
      lastUpdated: json['last_updated']?.toString() ?? '',
      schemePurpose: json['scheme_purpose']?.toString() ?? '',
      schemeName: json['scheme_name']?.toString() ?? '',
      isKyc: json['is_kyc'] ?? false,
      isCompleted: json['is_completed'] ?? false,
      percentage: parseDouble(json['percentage']),
      totalAmount: parseDouble(json['totalAmount']),
      goldDelivered: parseDouble(json['gold_delivered']),
      deliveredGoldWeight: parseDouble(json['delivered_gold_weight']),
      pendingGoldWeight: parseDouble(json['pending_gold_weight']),
      pendingAmount: parseDouble(json['pending_amount']),
      history: (json['history'] as List? ?? [])
          .map((e) => History.fromJson(e))
          .toList(),
    );
  }

  ///  copyWith added (optional but useful)
  TotalActiveScheme copyWith({
    String? savingId,
    double? paidAmount,
    Customer? customer,
    String? schemeType,
    String? schemeId,
    String? startDate,
    String? endDate,
    String? status,
    double? totalGoldWeight,
    String? lastUpdated,
    String? schemePurpose,
    String? schemeName,
    bool? isKyc,
    bool? isCompleted,
    double? percentage,
    double? totalAmount,
    double? goldDelivered,
    double? deliveredGoldWeight,
    double? pendingGoldWeight,
    double? pendingAmount,
    List<History>? history,
  }) {
    return TotalActiveScheme(
      savingId: savingId ?? this.savingId,
      paidAmount: paidAmount ?? this.paidAmount,
      customer: customer ?? this.customer,
      schemeType: schemeType ?? this.schemeType,
      schemeId: schemeId ?? this.schemeId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      totalGoldWeight: totalGoldWeight ?? this.totalGoldWeight,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      schemePurpose: schemePurpose ?? this.schemePurpose,
      schemeName: schemeName ?? this.schemeName,
      isKyc: isKyc ?? this.isKyc,
      isCompleted: isCompleted ?? this.isCompleted,
      percentage: percentage ?? this.percentage,
      totalAmount: totalAmount ?? this.totalAmount,
      goldDelivered: goldDelivered ?? this.goldDelivered,
      deliveredGoldWeight: deliveredGoldWeight ?? this.deliveredGoldWeight,
      pendingGoldWeight: pendingGoldWeight ?? this.pendingGoldWeight,
      pendingAmount: pendingAmount ?? this.pendingAmount,
      history: history ?? this.history,
    );
  }
}
class History {
  final String dueDate;
  final String status;
  final String paidDate;
  final String paymentMode;
  final double monthlyAmount;
  final double goldWeight;
  final double amount;

  History({
    required this.dueDate,
    required this.status,
    required this.paidDate,
    required this.paymentMode,
    required this.monthlyAmount,
    required this.goldWeight,
    required this.amount,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      dueDate: json['dueDate']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      paidDate: json['paidDate']?.toString() ?? '',
      paymentMode: json['paymentMode']?.toString() ?? '',
      monthlyAmount: parseDouble(json['monthly_amount']),
      goldWeight: parseDouble(json['goldWeight']),
      amount: parseDouble(json['amount']),
    );
  }

  Map<String, dynamic> toJson() => {
        'dueDate': dueDate,
        'status': status,
        'paidDate': paidDate,
        'paymentMode': paymentMode,
        'monthly_amount': monthlyAmount,
        'goldWeight': goldWeight,
        'amount': amount,
      };

  ///  copyWith added
  History copyWith({
    String? dueDate,
    String? status,
    String? paidDate,
    String? paymentMode,
    double? monthlyAmount,
    double? goldWeight,
    double? amount,
  }) {
    return History(
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      paidDate: paidDate ?? this.paidDate,
      paymentMode: paymentMode ?? this.paymentMode,
      monthlyAmount: monthlyAmount ?? this.monthlyAmount,
      goldWeight: goldWeight ?? this.goldWeight,
      amount: amount ?? this.amount,
    );
  }
}

// --- Rest of your History, Customer, Nominee, Address, Document models remain same ---
