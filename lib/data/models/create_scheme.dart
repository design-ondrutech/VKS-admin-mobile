class CreateSchemeModel {
  final String schemeId;
  final String schemeName;
  final String schemeType;
  final String durationType;
  final int duration;
  final double minAmount;
  final double? maxAmount;
  final double? incrementAmount;
  final double? threshold;  //  NEW
  final double? bonus;      //  NEW
  final bool isActive;
  final String? schemeIcon;
  final String? schemeImage;
  final String? schemeNotes;
  final String? redemptionTerms;
  final double? interestRate;
  final bool isDeleted;

  CreateSchemeModel({
    required this.schemeId,
    required this.schemeName,
    required this.schemeType,
    required this.durationType,
    required this.duration,
    required this.minAmount,
    this.maxAmount,
    this.incrementAmount,
    this.threshold,
    this.bonus,
    required this.isActive,
    this.schemeIcon,
    this.schemeImage,
    this.schemeNotes,
    this.redemptionTerms,
    this.interestRate,
    required this.isDeleted,
  });

  factory CreateSchemeModel.fromJson(Map<String, dynamic> json) {
    return CreateSchemeModel(
      schemeId: json['scheme_id'] ?? '',
      schemeName: json['scheme_name'] ?? '',
      schemeType: json['scheme_type'] ?? '',
      durationType: json['duration_type'] ?? '',
      duration: (json['duration'] ?? 0).toInt(),
      minAmount: (json['min_amount'] ?? 0).toDouble(),
      maxAmount: json['max_amount'] != null ? (json['max_amount']).toDouble() : null,
      incrementAmount: json['increment_amount'] != null ? (json['increment_amount']).toDouble() : null,
      threshold: json['threshold'] != null ? (json['threshold']).toDouble() : null, // 
      bonus: json['bonus'] != null ? (json['bonus']).toDouble() : null,           // 
      isActive: json['is_active'] ?? false,
      schemeIcon: json['scheme_icon'],
      schemeImage: json['scheme_image'],
      schemeNotes: json['scheme_notes'],
      redemptionTerms: json['redemption_terms'],
      interestRate: json['interest_rate'] != null ? (json['interest_rate']).toDouble() : null,
      isDeleted: json['isDeleted'] ?? false,
    );
  }
}
