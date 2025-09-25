class CreateSchemeResponse {
  final String schemeId;
  final String schemeName;
  final String schemeType;
  final String durationType;
  final int duration;
  final double minAmount;
  final double maxAmount;
  final double incrementAmount;
  final bool isActive;
  final bool isDeleted;
  final double? threshold;
  final double? bonus;

  CreateSchemeResponse({
    required this.schemeId,
    required this.schemeName,
    required this.schemeType,
    required this.durationType,
    required this.duration,
    required this.minAmount,
    required this.maxAmount,
    required this.incrementAmount,
    required this.isActive,
    required this.isDeleted,
    this.threshold,
    this.bonus,
  });

  factory CreateSchemeResponse.fromJson(Map<String, dynamic> json) {
    final benefits = json['amount_benefits'];
    double? threshold;
    double? bonus;

    if (benefits != null && benefits is Map) {
      threshold = (benefits['threshold'] ?? 0).toDouble();
      bonus = (benefits['bonus'] ?? 0).toDouble();
    }

    return CreateSchemeResponse(
      schemeId: json['scheme_id'] ?? "",
      schemeName: json['scheme_name'] ?? "",
      schemeType: json['scheme_type'] ?? "",
      durationType: json['duration_type'] ?? "",
      duration: json['duration'] ?? 0,
      minAmount: (json['min_amount'] ?? 0).toDouble(),
      maxAmount: (json['max_amount'] ?? 0).toDouble(),
      incrementAmount: (json['increment_amount'] ?? 0).toDouble(),
      isActive: json['is_active'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
      threshold: threshold,
      bonus: bonus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "scheme_id": schemeId,
      "scheme_name": schemeName,
      "scheme_type": schemeType,
      "duration_type": durationType,
      "duration": duration,
      "min_amount": minAmount,
      "max_amount": maxAmount,
      "increment_amount": incrementAmount,
      "is_active": isActive,
      "isDeleted": isDeleted,
      "amount_benefits": {
        "threshold": threshold ?? 0,
        "bonus": bonus ?? 0,
      },
    };
  }
}
