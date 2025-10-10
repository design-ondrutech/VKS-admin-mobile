class GoldPrice {
  final String? id; 
  final String priceId;
  final String date;
  final String value;
  final String metal;
  final String unit;
  final double price;
  final DateTime createdDate;
  final bool isDeleted;
  final double percentageDiff;
  final bool isPriceUp;

  GoldPrice({
    this.id,
    required this.priceId,
    required this.date,
    required this.value,
    required this.metal,
    required this.unit,
    required this.price,
    required this.createdDate,
    required this.isDeleted,
    required this.percentageDiff,
    required this.isPriceUp,
  });

  factory GoldPrice.fromJson(Map<String, dynamic> json) {
    return GoldPrice(
      id: json['_id'],
      priceId: json['price_id'],
      date: json['date'],
      value: json['value'],
      metal: json['metal'],
      unit: json['unit'],
      price: (json['price'] as num).toDouble(),
      createdDate: DateTime.parse(json['created_date']),
      isDeleted: json['isdeleted'],
      percentageDiff: (json['percentage_diff'] as num).toDouble(),
      isPriceUp: json['is_price_up'],
    );
  }

}
