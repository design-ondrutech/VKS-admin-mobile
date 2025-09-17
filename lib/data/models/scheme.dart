class Scheme {
  final String schemeName;
  final int duration;
  final double minAmount;
  final double maxAmount;

  Scheme({
    required this.schemeName,
    required this.duration,
    required this.minAmount,
    required this.maxAmount,
  });

  // Factory constructor to create from GraphQL response map
  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      schemeName: json['scheme_name'] ?? '',
      duration: int.tryParse(json['duration'].toString()) ?? 0,
      minAmount: double.tryParse(json['min_amount'].toString()) ?? 0.0,
      maxAmount: double.tryParse(json['max_amount'].toString()) ?? 0.0,
    );
  }

  // Convert back to Map (for mutation)
  Map<String, dynamic> toJson() {
    return {
      'scheme_name': schemeName,
      'duration': duration,
      'min_amount': minAmount,
      'max_amount': maxAmount,
    };
  }
}
