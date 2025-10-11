import 'package:flutter/material.dart';
import 'package:admin/data/models/TodayActiveScheme.dart';
import 'package:admin/utils/style.dart';

class TodaySchemeDetailsSection extends StatelessWidget {
  final TodayActiveScheme scheme;
  const TodaySchemeDetailsSection({super.key, required this.scheme});

  String formatGram(double? value, {int digits = 4}) {
    if (value == null) return "0.0000";
    return value.toStringAsFixed(digits);
  }

  @override
  Widget build(BuildContext context) {
    return _infoCard(
      title: "Scheme Details",
      children: [
        _infoRow("Scheme Name", scheme.schemeName),
        _infoRow("Scheme Type", scheme.schemeType),
        _infoRow("Status", scheme.status),
        _infoRow("Gold Delivered", scheme.goldDelivered ? "Yes" : "No"),
        _infoRow(
            "Delivered Gold Weight", "${formatGram(scheme.deliveredGoldWeight)} g"),
        _infoRow(
            "Balance Gold Weight", "${formatGram(scheme.pendingGoldWeight)} g"),
        _infoRow("Purpose", scheme.schemePurpose),
        _infoRow("KYC Completed", scheme.isKyc ? "Yes" : "No"),
        _infoRow("Start Date", formatDate(scheme.startDate)),
        _infoRow("End Date", formatDate(scheme.endDate)),
        _infoRow("Last Updated", formatDate(scheme.lastUpdated)),
      ],
    );
  }

  Widget _infoCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blueGrey)),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Flexible(child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
