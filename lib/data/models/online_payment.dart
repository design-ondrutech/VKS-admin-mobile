class OnlinePaymentResponse {
  final List<OnlinePayment> data;
  final int limit;
  final int totalCount;
  final int totalPages;
  final int currentPage;

  OnlinePaymentResponse({
    required this.data,
    required this.limit,
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
  });

  factory OnlinePaymentResponse.fromJson(Map<String, dynamic> json) {
    return OnlinePaymentResponse(
      data: (json['data'] as List)
          .map((item) => OnlinePayment.fromJson(item))
          .toList(),
      limit: json['limit'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
    );
  }
}

class OnlinePayment {
  final String transactionId;
  final double transactionAmount;
  final double transactionGoldGram;
  final String transactionDate;
  final String customerName;
  final String transactionStatus;

  OnlinePayment({
    required this.transactionId,
    required this.transactionAmount,
    required this.transactionGoldGram,
    required this.transactionDate,
    required this.customerName,
    required this.transactionStatus,
  });

factory OnlinePayment.fromJson(Map<String, dynamic> json) {
  return OnlinePayment(
    transactionId: json['transactionId']?.toString() ?? '',
    transactionAmount: (json['transactionAmount'] ?? 0).toDouble(),
    transactionGoldGram: (json['transactionGoldGram'] ?? 0).toDouble(),
    transactionDate: json['transactionDate'] ?? '',
    customerName: json['customer']?['cName'] ?? '',
    transactionStatus: json['transactionStatus'] ?? '',
  );
}
}
