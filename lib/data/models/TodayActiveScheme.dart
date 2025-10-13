import 'package:admin/data/models/customer.dart';

/// Safely converts any value to a double
double parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is bool) return value ? 1.0 : 0.0;
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

/// =======================================
///   TODAY ACTIVE SCHEME RESPONSE MODEL
/// =======================================
class TodayActiveSchemeResponse {
  final List<TodayActiveScheme> data;
  final int limit;
  final int page;
  final int totalCount;
  final double? totalSchemeAmount;
  final double? totalSchemeGoldWeight;

  TodayActiveSchemeResponse({
    required this.data,
    required this.limit,
    required this.page,
    required this.totalCount,
    this.totalSchemeAmount,
    this.totalSchemeGoldWeight,
  });

  factory TodayActiveSchemeResponse.fromJson(Map<String, dynamic> json) {
    return TodayActiveSchemeResponse(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => TodayActiveScheme.fromJson(e))
              .toList() ??
          [],
      limit: json['limit'] ?? 0,
      page: json['page'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      totalSchemeAmount: (json['total_scheme_amount'] as num?)?.toDouble(),
      totalSchemeGoldWeight:
          (json['total_scheme_gold_weight'] as num?)?.toDouble(),
    );
  }

  TodayActiveSchemeResponse copyWith({
    List<TodayActiveScheme>? data,
    int? limit,
    int? page,
    int? totalCount,
    double? totalSchemeAmount,
    double? totalSchemeGoldWeight,
  }) {
    return TodayActiveSchemeResponse(
      data: data ?? this.data,
      limit: limit ?? this.limit,
      page: page ?? this.page,
      totalCount: totalCount ?? this.totalCount,
      totalSchemeAmount: totalSchemeAmount ?? this.totalSchemeAmount,
      totalSchemeGoldWeight:
          totalSchemeGoldWeight ?? this.totalSchemeGoldWeight,
    );
  }
}

/// =======================================
///   TODAY ACTIVE SCHEME MODEL
/// =======================================
class TodayActiveScheme {
  final String savingId;
  final double? paidAmount;
  final Customer customer;
  final String schemeType;
  final String schemeId;
  final String startDate;
  final String endDate;
  final String status;
  final double? totalGoldWeight;
  final String lastUpdated;
  final String schemePurpose;
  final String schemeName;
  final bool isKyc;
  final bool isCompleted;
  final double? percentage;
  final double? totalAmount;
  final bool goldDelivered;
  final double? deliveredGoldWeight;
  final double? pendingGoldWeight;
  final double? pendingAmount;
  final double? totalBenefitGram;
  final double? tottalbonusgoldweight;
  final List<PaymentHistory> history;

  TodayActiveScheme({
    required this.savingId,
    this.paidAmount,
    required this.customer,
    required this.schemeType,
    required this.schemeId,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.totalGoldWeight,
    required this.lastUpdated,
    required this.schemePurpose,
    required this.schemeName,
    required this.isKyc,
    required this.isCompleted,
    this.percentage,
    this.totalAmount,
    required this.goldDelivered,
    this.deliveredGoldWeight,
    this.pendingGoldWeight,
    this.pendingAmount,
    this.totalBenefitGram,
    this.tottalbonusgoldweight,
    required this.history,
  });

  factory TodayActiveScheme.fromJson(Map<String, dynamic> json) {
    return TodayActiveScheme(
      savingId: json['saving_id']?.toString() ?? '',
      paidAmount: (json['paidAmount'] as num?)?.toDouble(),
      customer: Customer.fromJson(json['customer'] ?? {}),
      schemeType: json['scheme_type']?.toString() ?? '',
      schemeId: json['scheme_id']?.toString() ?? '',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      totalGoldWeight: (json['total_gold_weight'] as num?)?.toDouble(),
      lastUpdated: json['last_updated']?.toString() ?? '',
      schemePurpose: json['scheme_purpose']?.toString() ?? '',
      schemeName: json['scheme_name']?.toString() ?? '',
      isKyc: json['is_kyc'] ?? false,
      isCompleted: json['is_completed'] ?? false,
      percentage: (json['percentage'] as num?)?.toDouble(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      goldDelivered: json['gold_delivered'] ?? false,
      deliveredGoldWeight:
          (json['delivered_gold_weight'] as num?)?.toDouble(),
      pendingGoldWeight: (json['pending_gold_weight'] as num?)?.toDouble(),
      pendingAmount: (json['pending_amount'] as num?)?.toDouble(),
      totalBenefitGram: (json['total_benefit_gram'] as num?)?.toDouble(),
      tottalbonusgoldweight:
          (json['tottalbonusgoldweight'] as num?)?.toDouble(),
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => PaymentHistory.fromJson(e))
              .toList() ??
          [],
    );
  }
}

/// =======================================
///   PAYMENT HISTORY MODEL
/// =======================================
class PaymentHistory {
  final String dueDate;
  final String status;
  final String paidDate;
  final String paymentMode;
  final double monthlyAmount;
  final double goldWeight;
  final double amount;

  PaymentHistory({
    required this.dueDate,
    required this.status,
    required this.paidDate,
    required this.paymentMode,
    required this.monthlyAmount,
    required this.goldWeight,
    required this.amount,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      dueDate: json['dueDate']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      paidDate: json['paidDate']?.toString() ?? '',
      paymentMode: json['paymentMode']?.toString() ?? '',
      monthlyAmount: parseDouble(json['monthly_amount']),
      goldWeight: parseDouble(json['goldWeight']),
      amount: parseDouble(json['amount']),
    );
  }
}
