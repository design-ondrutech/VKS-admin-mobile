import 'dart:convert';
import 'package:admin/screens/dashboard/scheme/add_scheme/model/create_scheme.dart';


class Scheme {
  final String schemeId;
  final String schemeName;
  final String schemeType;
  final String durationType;
  final int duration;
  final double minAmount;
  final double? maxAmount;
  final double? incrementAmount;
  final bool isActive;
  final double? threshold;
  final double? bonus;

  Scheme({
    required this.schemeId,
    required this.schemeName,
    required this.schemeType,
    required this.durationType,
    required this.duration,
    required this.minAmount,
    this.maxAmount,
    this.incrementAmount,
    required this.isActive,
    this.threshold,
    this.bonus,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) {
    final benefits = json['amount_benefits'];
    double? threshold;
    double? bonus;

    if (benefits != null) {
      Map<String, dynamic> data = {};
      if (benefits is String) {
        try {
          data = Map<String, dynamic>.from(jsonDecode(benefits));
        } catch (_) {}
      } else if (benefits is Map) {
        data = Map<String, dynamic>.from(benefits);
      }

      threshold = (data['threshold'] ?? 0).toDouble();
      bonus = (data['bonus'] ?? 0).toDouble();
    }

    return Scheme(
      schemeId: json['scheme_id'] ?? "",
      schemeName: json['scheme_name'] ?? "",
      schemeType: json['scheme_type'] ?? "",
      durationType: json['duration_type'] ?? "",
      duration: json['duration'] ?? 0,
      minAmount: (json['min_amount'] ?? 0).toDouble(),
      maxAmount: json['max_amount']?.toDouble(),
      incrementAmount: json['increment_amount']?.toDouble(),
      isActive: json['is_active'] ?? true,
      threshold: threshold,
      bonus: bonus,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      "scheme_name": schemeName,
      "scheme_type": schemeType,
      "duration_type": durationType,
      "duration": duration,
      "min_amount": minAmount,
      "max_amount": maxAmount,
      "increment_amount": incrementAmount,
      "is_active": isActive,
      "threshold": threshold ?? 0,
      "bonus": bonus ?? 0,
    };
  }

  Map<String, dynamic> toUpdateJson() {
  return {
    "scheme_name": schemeName,
    "scheme_type": schemeType,
       "duration_type": durationType.toUpperCase(), //  make sure matches DB
    "duration": duration,
    "min_amount": minAmount,
    "max_amount": maxAmount,
    "increment_amount": incrementAmount,
    "is_active": isActive,
    "amount_benefits": {
      "threshold": threshold ?? 0,
      "bonus": bonus ?? 0,
    },
  };
}


  CreateSchemeResponse toCreateSchemeResponse() {
    return CreateSchemeResponse(
      schemeId: schemeId,
      schemeName: schemeName,
      schemeType: schemeType,
      durationType: durationType,
      duration: duration,
      minAmount: minAmount,
      maxAmount: maxAmount ?? 0,
      incrementAmount: incrementAmount ?? 0,
      isActive: isActive,
      isDeleted: false,
      threshold: threshold,
      bonus: bonus,
    );
  }
}
