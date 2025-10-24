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
  if (amount is num) {
    // remove trailing .0 if it's an integer
    if (amount % 1 == 0) {
      return amount.toInt().toString();
    } else {
      return amount.toStringAsFixed(2); // keep 2 decimals if needed
    }
  }
  // handle string case
  final parsed = double.tryParse(amount.toString());
  if (parsed == null) return amount.toString();
  return parsed % 1 == 0 ? parsed.toInt().toString() : parsed.toStringAsFixed(2);
}
