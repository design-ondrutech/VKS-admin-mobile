import 'package:admin/data/models/customer.dart';

///  Safely converts any type to double (int, String, etc.)
double parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is bool) return value ? 1.0 : 0.0;
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

/// =======================================
///  TODAY ACTIVE SCHEME RESPONSE MODEL
/// =======================================
class TodayActiveSchemeResponse {
  final List<TodayActiveScheme> data;
  final int limit;
  final int page;
  final int totalCount;
  final int totalPages;
  final int currentPage;
  final double? totalSchemeAmount;
  final double? totalSchemeGoldWeight;

  TodayActiveSchemeResponse({
    required this.data,
    required this.limit,
    required this.page,
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    this.totalSchemeAmount,
    this.totalSchemeGoldWeight,
  });

  factory TodayActiveSchemeResponse.fromJson(Map<String, dynamic> json) {
    final int limit = json['limit'] ?? 0;
    final int totalCount = json['totalCount'] ?? 0;
    final int page = json['page'] ?? 1;
    final int totalPages = (limit > 0) ? (totalCount / limit).ceil() : 1;

    return TodayActiveSchemeResponse(
      data:
          (json['data'] as List<dynamic>? ?? [])
              .map((e) => TodayActiveScheme.fromJson(e))
              .toList(),
      limit: limit,
      page: page,
      totalCount: totalCount,
      totalPages: totalPages,
      currentPage: page,
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
    int? totalPages,
    int? currentPage,
    double? totalSchemeAmount,
    double? totalSchemeGoldWeight,
  }) {
    return TodayActiveSchemeResponse(
      data: data ?? this.data,
      limit: limit ?? this.limit,
      page: page ?? this.page,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      totalSchemeAmount: totalSchemeAmount ?? this.totalSchemeAmount,
      totalSchemeGoldWeight:
          totalSchemeGoldWeight ?? this.totalSchemeGoldWeight,
    );
  }

  TodayActiveSchemeResponse mergeWith(TodayActiveSchemeResponse newPage) {
    return TodayActiveSchemeResponse(
      data: [...data, ...newPage.data],
      limit: newPage.limit,
      page: newPage.page,
      totalCount: newPage.totalCount,
      totalPages: newPage.totalPages,
      currentPage: newPage.currentPage,
      totalSchemeAmount: newPage.totalSchemeAmount,
      totalSchemeGoldWeight: newPage.totalSchemeGoldWeight,
    );
  }
}

/// =======================================
///  TODAY ACTIVE SCHEME MODEL
/// =======================================
class TodayActiveScheme {
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
  final bool goldDelivered;
  final double deliveredGoldWeight;
  final double pendingGoldWeight;
  final double pendingAmount;
  final double? totalBenefitGram;
  final double? tottalbonusgoldweight;
  final List<PaymentHistory> history;

  TodayActiveScheme({
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
    this.totalBenefitGram,
    this.tottalbonusgoldweight,
    required this.history,
  });

  factory TodayActiveScheme.fromJson(Map<String, dynamic> json) {
    return TodayActiveScheme(
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
      goldDelivered: json['gold_delivered'] ?? false,
      deliveredGoldWeight: parseDouble(json['delivered_gold_weight']),
      pendingGoldWeight: parseDouble(json['pending_gold_weight']),
      pendingAmount: parseDouble(json['pending_amount']),
      totalBenefitGram: (json['total_benefit_gram'] as num?)?.toDouble(),
      tottalbonusgoldweight:
          (json['tottalbonusgoldweight'] as num?)?.toDouble(),
      history:
          (json['history'] as List<dynamic>? ?? [])
              .map((e) => PaymentHistory.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'saving_id': savingId,
      'paidAmount': paidAmount,
      'customer': customer,
      'scheme_type': schemeType,
      'scheme_id': schemeId,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'total_gold_weight': totalGoldWeight,
      'last_updated': lastUpdated,
      'scheme_purpose': schemePurpose,
      'scheme_name': schemeName,
      'is_kyc': isKyc,
      'is_completed': isCompleted,
      'percentage': percentage,
      'totalAmount': totalAmount,
      'gold_delivered': goldDelivered,
      'delivered_gold_weight': deliveredGoldWeight,
      'pending_gold_weight': pendingGoldWeight,
      'pending_amount': pendingAmount,
      'total_benefit_gram': totalBenefitGram,
      'tottalbonusgoldweight': tottalbonusgoldweight,
      'history': history.map((e) => e.toJson()).toList(),
    };
  }

  /// ✅ copyWith method
  TodayActiveScheme copyWith({
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
    bool? goldDelivered,
    double? deliveredGoldWeight,
    double? pendingGoldWeight,
    double? pendingAmount,
    double? totalBenefitGram,
    double? tottalbonusgoldweight,
    List<PaymentHistory>? history,
  }) {
    return TodayActiveScheme(
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
      totalBenefitGram: totalBenefitGram ?? this.totalBenefitGram,
      tottalbonusgoldweight:
          tottalbonusgoldweight ?? this.tottalbonusgoldweight,
      history: history ?? this.history,
    );
  }
}

/// =======================================
///  PAYMENT HISTORY MODEL
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

  Map<String, dynamic> toJson() {
    return {
      'dueDate': dueDate,
      'status': status,
      'paidDate': paidDate,
      'paymentMode': paymentMode,
      'monthly_amount': monthlyAmount,
      'goldWeight': goldWeight,
      'amount': amount,
    };
  }
}
