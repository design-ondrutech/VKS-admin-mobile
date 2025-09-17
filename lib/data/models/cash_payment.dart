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
      data: (json['data'] as List)
          .map((item) => CashPayment.fromJson(item))
          .toList(),
      limit: json['limit'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
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
    return CashPayment(
      transactionId: json['transactionId'] ?? '',
      transactionAmount: (json['transactionAmount'] ?? 0).toDouble(),
      transactionGoldGram: (json['transactionGoldGram'] ?? 0).toDouble(),
      transactionDate: json['transactionDate'] ?? '',
      customerName: json['customer']?['cName'] ?? '',
      transactionStatus: json['transactionStatus'] ?? '',
    );
  }
}
