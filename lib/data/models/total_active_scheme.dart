import 'package:admin/data/models/total_active_scheme';

class TotalActiveSchemesResponse {
  final List<TotalActiveScheme> data;
  final int limit;
  final int page;
  final int totalCount;
  final double totalSchemeAmount;
  final double totalSchemeGoldWeight;

  TotalActiveSchemesResponse({
    required this.data,
    required this.limit,
    required this.page,
    required this.totalCount,
    required this.totalSchemeAmount,
    required this.totalSchemeGoldWeight,
  });

  factory TotalActiveSchemesResponse.fromJson(Map<String, dynamic> json) {
    return TotalActiveSchemesResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => TotalActiveScheme.fromJson(e))
          .toList(),
      limit: json['limit'] ?? 0,
      page: json['page'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      totalSchemeAmount: (json['total_scheme_amount'] ?? 0).toDouble(),
      totalSchemeGoldWeight: (json['total_scheme_gold_weight'] ?? 0).toDouble(),
    );
  }

  ///  copyWith method for immutability support
  TotalActiveSchemesResponse copyWith({
    List<TotalActiveScheme>? data,
    int? limit,
    int? page,
    int? totalCount,
    double? totalSchemeAmount,
    double? totalSchemeGoldWeight,
  }) {
    return TotalActiveSchemesResponse(
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
