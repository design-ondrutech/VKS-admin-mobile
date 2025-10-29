import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ThemeText {
  static const TextStyle titleLarge = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
}

// Helper function to format date strings
String formatDate(String dateStr) {
  try {
    if (dateStr.isEmpty) return "-";
    DateTime parsedDate = DateTime.parse(dateStr);
    return DateFormat("dd-MM-yyyy").format(parsedDate); 
  } catch (e) {
    return dateStr; 
  }
}

String formatAmount(dynamic amount) {
  if (amount == null) return "0";

  final formatter = NumberFormat('#,##,##0.##', 'en_IN'); 

  if (amount is num) {
    return formatter.format(amount);
  }

  final parsed = double.tryParse(amount.toString());
  if (parsed == null) return amount.toString();

  return formatter.format(parsed);
}


  String formatGram(double? value, {int digits = 4}) {
    if (value == null) return "0.0000";
    return value.toStringAsFixed(digits);
  }

  
  String getJoinedDate() {
    final now = DateTime.now();
    return "${now.day}-${now.month}-${now.year}";
  }
