import 'package:flutter/material.dart';
import 'package:admin/data/models/today_active_scheme.dart';

class TodayActiveSchemeDetailScreen extends StatelessWidget {
  final TodayActiveScheme scheme;

  const TodayActiveSchemeDetailScreen({super.key, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(scheme.schemeName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Text("Scheme Name: ${scheme.schemeName}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text("Status: ${scheme.status}"),
            Text("Customer Name: ${scheme.customer.cName}"),
            Text("Phone: ${scheme.customer.cPhoneNumber}"),
            Text("Email: ${scheme.customer.cEmail}"),
            Text("Type: ${scheme.schemeType}"),
            Text("Purpose: ${scheme.schemePurpose}"),
            Text("Gold: ${scheme.totalGoldWeight} gm"),
            Text("Amount: ₹${scheme.totalAmount}"),
            Text("Start Date: ${scheme.startDate}"),
            
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
