import 'package:uuid/uuid.dart';

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
  double? threshold;
  double? bonus;

  final benefits = json['amount_benefits'];
  if (benefits is Map) {
    threshold = double.tryParse(benefits['threshold']?.toString() ?? "0");
    bonus = double.tryParse(benefits['bonus']?.toString() ?? "0");
  }

  return Scheme(
    schemeId: json['scheme_id']?.toString() ?? "",
    schemeName: json['scheme_name']?.toString() ?? "",
    schemeType: json['scheme_type']?.toString() ?? "fixed",
    durationType: json['duration_type']?.toString() ?? "Monthly",
    duration: int.tryParse(json['duration']?.toString() ?? "0") ?? 0,
    minAmount: double.tryParse(json['min_amount']?.toString() ?? "0") ?? 0,
    maxAmount: (json['max_amount'] != null) ? double.tryParse(json['max_amount'].toString()) : null,
    incrementAmount: (json['increment_amount'] != null) ? double.tryParse(json['increment_amount'].toString()) : null,
    isActive: json['is_active'] == true,
    threshold: threshold,
    bonus: bonus,

  );
}
  ///  Create Input → generate UUID automatically
  Map<String, dynamic> toCreateInput() {
    return {
      "scheme_id": schemeId.isNotEmpty ? schemeId : const Uuid().v4(), //  generate if empty
      "scheme_name": schemeName,
      "scheme_type": schemeType,
      "duration_type": durationType,
      "duration": duration,
      "min_amount": minAmount,
      "max_amount": maxAmount ?? 0.0,
      "increment_amount": incrementAmount ?? 0.0,
       "amount_benefits": {
      "threshold": threshold ?? 0.0,
      "bonus": bonus ?? 0.0,
    }, 
    };
  }

  ///  Update Input → no need to send scheme_id inside data (it’s passed separately)
  Map<String, dynamic> toUpdateInput() {
    return {
      "scheme_name": schemeName,
      "scheme_type": schemeType,
      "duration_type": durationType,
      "duration": duration,
      "min_amount": minAmount,
      "max_amount": maxAmount ?? 0.0,
      "increment_amount": incrementAmount ?? 0.0,
      "amount_benefits": {
        "threshold": threshold ?? 0.0,
        "bonus": bonus ?? 0.0,
      },
    };
  }
}
