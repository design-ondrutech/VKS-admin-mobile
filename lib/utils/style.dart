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