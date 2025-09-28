class CashPaymentResponse {
  final List<CashPayment> data;
  final int limit;
  final int totalCount;
  final int totalPages;
  final int currentPage;

  CashPaymentResponse({
    required this.data,
    required this.limit,
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
  });

  factory CashPaymentResponse.fromJson(Map<String, dynamic> json) {
    return CashPaymentResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => CashPayment.fromJson(item))
          .toList(),
      limit: (json['limit'] ?? 0) is String
          ? int.tryParse(json['limit']) ?? 0
          : json['limit'] ?? 0,
      totalCount: (json['totalCount'] ?? 0) is String
          ? int.tryParse(json['totalCount']) ?? 0
          : json['totalCount'] ?? 0,
      totalPages: (json['totalPages'] ?? 0) is String
          ? int.tryParse(json['totalPages']) ?? 0
          : json['totalPages'] ?? 0,
      currentPage: (json['currentPage'] ?? 1) is String
          ? int.tryParse(json['currentPage']) ?? 1
          : json['currentPage'] ?? 1,
    );
  }
}

class CashPayment {
  final String transactionId;
  final double transactionAmount;
  final double transactionGoldGram;
  final String transactionDate;
  final String customerName;
  final String transactionStatus;

  CashPayment({
    required this.transactionId,
    required this.transactionAmount,
    required this.transactionGoldGram,
    required this.transactionDate,
    required this.customerName,
    required this.transactionStatus,
  });

  factory CashPayment.fromJson(Map<String, dynamic> json) {
    double gold = (json['transactionGoldGram'] ?? 0).toDouble();
    if (gold.isNaN) gold = 0.0; // NaN-safe

    return CashPayment(
      transactionId: json['transactionId']?.toString() ?? '',
      transactionAmount: (json['transactionAmount'] ?? 0).toDouble(),
      transactionGoldGram: gold,
      transactionDate: json['transactionDate']?.toString() ?? '',
      customerName: json['customer']?['cName']?.toString() ?? '',
      transactionStatus: json['transactionStatus']?.toString() ?? '',
    );
  }

  CashPayment copyWith({
    String? transactionId,
    double? transactionAmount,
    double? transactionGoldGram,
    String? transactionDate,
    String? customerName,
    String? transactionStatus,
  }) {
    return CashPayment(
      transactionId: transactionId ?? this.transactionId,
      transactionAmount: transactionAmount ?? this.transactionAmount,
      transactionGoldGram: transactionGoldGram ?? this.transactionGoldGram,
      transactionDate: transactionDate ?? this.transactionDate,
      customerName: customerName ?? this.customerName,
      transactionStatus: transactionStatus ?? this.transactionStatus,
    );
  }
}
