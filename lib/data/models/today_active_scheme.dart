class TodayActiveSchemeResponse {
  final List<TodayActiveScheme> data;
  final int limit;
  final int page;
  final int totalCount;

  TodayActiveSchemeResponse({
    required this.data,
    required this.limit,
    required this.page,
    required this.totalCount,
  });

  factory TodayActiveSchemeResponse.fromJson(Map<String, dynamic> json) {
    return TodayActiveSchemeResponse(
      data: (json['data'] as List)
          .map((e) => TodayActiveScheme.fromJson(e))
          .toList(),
      limit: json['limit'] ?? 0,
      page: json['page'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
    );
  }
}

class TodayActiveScheme {
  final Customer customer;
  final double totalAmount;
  final String status;
  final String schemeType;
  final String schemeName;
  final String schemePurpose;
  final double totalGoldWeight;
  final String startDate;

  TodayActiveScheme({
    required this.customer,
    required this.totalAmount,
    required this.status,
    required this.schemeType,
    required this.schemeName,
    required this.schemePurpose,
    required this.totalGoldWeight,
    required this.startDate,
  });

  factory TodayActiveScheme.fromJson(Map<String, dynamic> json) {
    return TodayActiveScheme(
      customer: Customer.fromJson(json['customer']),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      schemeType: json['scheme_type'] ?? '',
      schemeName: json['scheme_name'] ?? '',
      schemePurpose: json['scheme_purpose'] ?? '',
      totalGoldWeight: (json['total_gold_weight'] ?? 0).toDouble(),
      startDate: json['start_date'] ?? '',
    );
  }
}

class Customer {
  final String cName;
  final String cEmail;
  final String cPhoneNumber;

  Customer({
    required this.cName,
    required this.cEmail,
    required this.cPhoneNumber,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      cName: json['cName'] ?? '',
      cEmail: json['cEmail'] ?? '',
      cPhoneNumber: json['cPhoneNumber'] ?? '',
    );
  }
}
