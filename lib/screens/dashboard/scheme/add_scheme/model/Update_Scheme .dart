// class UpdateSchemeModel {
//   final String schemeId;
//   final String schemeName;
//   final String schemeType;
//   final String durationType;
//   final int duration;
//   final double minAmount;
//   final double? maxAmount;
//   final double? incrementAmount;
//   final bool isActive;
//   final String? schemeIcon;
//   final String? schemeImage;
//   final String? schemeNotes;
//   final String? redemptionTerms;
//   final double? interestRate;
//   final bool? isDeleted;

//   UpdateSchemeModel({
//     required this.schemeId,
//     required this.schemeName,
//     required this.schemeType,
//     required this.durationType,
//     required this.duration,
//     required this.minAmount,
//     this.maxAmount,
//     this.incrementAmount,
//     required this.isActive,
//     this.schemeIcon,
//     this.schemeImage,
//     this.schemeNotes,
//     this.redemptionTerms,
//     this.interestRate,
//     this.isDeleted,
//   });
//   ///  For sending data to API
//   Map<String, dynamic> toJson() {
//     return {
//       "scheme_name": schemeName,
//       "scheme_type": schemeType,
//       "duration_type": durationType,
//       "duration": duration,
//       "min_amount": minAmount,
//       "max_amount": maxAmount,
//       "increment_amount": incrementAmount,
//       "is_active": isActive,
//       "scheme_icon": schemeIcon,
//       "scheme_image": schemeImage,
//       "scheme_notes": schemeNotes,
//       "redemption_terms": redemptionTerms,
//       "interest_rate": interestRate,
//       "isDeleted": isDeleted,
//     }..removeWhere((key, value) => value == null);
//   }

//   ///  From API response
//   factory UpdateSchemeModel.fromJson(Map<String, dynamic> json) {
//     return UpdateSchemeModel(
//       schemeId: json['scheme_id'] ?? '',
//       schemeName: json['scheme_name'] ?? '',
//       schemeType: json['scheme_type'] ?? '',
//       durationType: json['duration_type'] ?? '',
//       duration: json['duration'] ?? 0,
//       minAmount: (json['min_amount'] ?? 0).toDouble(),
//       maxAmount: json['max_amount'] != null ? (json['max_amount']).toDouble() : null,
//       incrementAmount:
//           json['increment_amount'] != null ? (json['increment_amount']).toDouble() : null,
//       isActive: json['is_active'] ?? false,
//       schemeIcon: json['scheme_icon'],
//       schemeImage: json['scheme_image'],
//       schemeNotes: json['scheme_notes'],
//       redemptionTerms: json['redemption_terms'],
//       interestRate: json['interest_rate'] != null ? (json['interest_rate']).toDouble() : null,
//       isDeleted: json['isDeleted'],
//     );
//   }
// }
