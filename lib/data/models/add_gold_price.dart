class GoldPriceInput {
  final String? id; 
  final String date;
  final String metal;
  final String value;
  final String unit;
  final double price;

  GoldPriceInput({
    this.id, 
    required this.date,
    required this.metal,
    required this.value,
    required this.unit,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "id": id, 
      "date": date,
      "metal": metal,
      "value": value,
      "unit": unit,
      "price": price,
    };
  }
}
