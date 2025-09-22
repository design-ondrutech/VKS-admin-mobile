class Scheme {

  final String schemeId;
  final String schemeName;
  final String schemeType;
  final String durationType;
  final int duration;
  final double minAmount;
  final double? maxAmount;
  final double? incrementAmount;
  final AmountBenefits? amountBenefits;

  Scheme({
    required this.schemeId,
    required this.schemeName,
    required this.schemeType,
    required this.durationType,
    required this.duration,
    required this.minAmount,
    this.maxAmount,
    this.incrementAmount,
    this.amountBenefits,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      schemeId: json['scheme_id'] ?? '',
      schemeName: json['scheme_name'] ?? '',
      schemeType: json['scheme_type'] ?? '',
      durationType: json['duration_type'] ?? '',
      duration: (json['duration'] ?? 0).toInt(),
      minAmount: (json['min_amount'] ?? 0).toDouble(),

      //  New fields
      maxAmount: json['max_amount'] != null ? (json['max_amount']).toDouble() : null,
      incrementAmount: json['increment_amount'] != null ? (json['increment_amount']).toDouble() : null,
      amountBenefits: json['amount_benefits'] != null
          ? AmountBenefits.fromJson(json['amount_benefits'])
          : null,
    );
  }
}

///  New Model for amount_benefits
class AmountBenefits {
  final double? threshold;
  final double? bonus;

  AmountBenefits({
    this.threshold,
    this.bonus,
  });

  factory AmountBenefits.fromJson(Map<String, dynamic> json) {
    return AmountBenefits(
      threshold: json['threshold'] != null ? (json['threshold']).toDouble() : null,
      bonus: json['bonus'] != null ? (json['bonus']).toDouble() : null,
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
