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
      data: (json['data'] as List?)
              ?.map((item) => OnlinePayment.fromJson(item))
              .toList() ??
          [],
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
    double parseDoubleSafe(dynamic value) {
      final parsed = double.tryParse(value?.toString() ?? '0') ?? 0;
      return parsed.isNaN ? 0 : parsed;
    }

    return OnlinePayment(
      transactionId: json['transactionId']?.toString() ?? '',
      transactionAmount: parseDoubleSafe(json['transactionAmount']),
      transactionGoldGram: parseDoubleSafe(json['transactionGoldGram']),
      transactionDate: json['transactionDate']?.toString() ?? '',
      customerName: json['customer']?['cName']?.toString() ?? '',
      transactionStatus: json['transactionStatus']?.toString() ?? '',
    );
  }
}
