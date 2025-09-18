class Scheme {
  final String schemeName;
  final String schemeType;
  final String durationType;
  final int duration;
  final double minAmount;

  Scheme({
    required this.schemeName,
    required this.schemeType,
    required this.durationType,
    required this.duration,
    required this.minAmount,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      schemeName: json['scheme_name'] ?? '',
      schemeType: json['scheme_type'] ?? '',
      durationType: json['duration_type'] ?? '',
      duration: (json['duration'] ?? 0).toInt(),
      minAmount: (json['min_amount'] ?? 0).toDouble(),
    );
  }
}

class SchemesResponse {
  final List<Scheme> data;
  final int limit;
  final int totalCount;
  final int totalPages;
  final int currentPage;

  SchemesResponse({
    required this.data,
    required this.limit,
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
  });

  factory SchemesResponse.fromJson(Map<String, dynamic> json) {
    return SchemesResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => Scheme.fromJson(e))
          .toList(),
      limit: json['limit'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
    );
  }
}
