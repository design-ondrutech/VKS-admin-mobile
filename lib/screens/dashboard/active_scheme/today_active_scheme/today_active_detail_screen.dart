import 'package:admin/data/models/today_active_scheme.dart';
import 'package:flutter/material.dart';
import 'package:admin/utils/colors.dart';

class TodayActiveSchemeDetailScreen extends StatelessWidget {
  final TodayActiveScheme scheme;

  const TodayActiveSchemeDetailScreen({super.key, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          scheme.schemeName.isNotEmpty ? scheme.schemeName : '-', // safe
          style: const TextStyle(color: Appcolors.white),
        ),
        centerTitle: true,
        backgroundColor: Appcolors.headerbackground,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---------------- SUMMARY CARDS ----------------
          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  title: "Total Amount",
                  value: "₹${scheme.totalAmount?.toStringAsFixed(2) ?? '0.00'}",
                  color: Colors.green[400]!,
                  icon: Icons.account_balance_wallet,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryCard(
                  title: "Total Gold Weight",
                  value: "${scheme.totalGoldWeight?.toStringAsFixed(2) ?? '0.0'} g",
                  color: Colors.amber[700]!,
                  icon: Icons.scale,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ---------------- SCHEME DETAILS ----------------
          _sectionTitle("Scheme Details"),
          _infoCard([
            _infoRow("Saving ID", scheme.savingId),
            _infoRow("Scheme Name", scheme.schemeName),
            _infoRow("Scheme Type", scheme.schemeType),
            _infoRow("Status", scheme.status),
            _infoRow("Gold Delivered", scheme.goldDelivered ? "Yes" : "No"),
            _infoRow("Purpose", scheme.schemePurpose),
            _infoRow("KYC Completed", scheme.isKyc ? "Yes" : "No"),
            _infoRow("Completed", scheme.isCompleted ? "Yes" : "No"),
            _infoRow("Start Date", scheme.startDate),
            _infoRow("End Date", scheme.endDate),
            _infoRow("Last Updated", scheme.lastUpdated),
          ]),
          const SizedBox(height: 16),

          // ---------------- CUSTOMER INFO ----------------
          _sectionTitle("Customer Info"),
          _infoCard([
            _infoRow("Name", scheme.customer.cName),
            _infoRow("Email", scheme.customer.cEmail),
            _infoRow("Phone", scheme.customer.cPhoneNumber),
          ]),
          const SizedBox(height: 16),

          // ---------------- PAYMENT DETAILS ----------------
          _sectionTitle("Payment Details"),
          _infoCard([
            _infoRow("Total Amount", "₹${scheme.totalAmount?.toStringAsFixed(2) ?? '0.00'}"),
            _infoRow("Paid Amount", "₹${scheme.paidAmount?.toStringAsFixed(2) ?? '0.00'}"),
            _infoRow(
              "Next Due On",
              (scheme.history.isNotEmpty ? scheme.history.first.dueDate : '-') ?? '-',
            ),
            _infoRow(
              "Gold Gram",
              (scheme.history.isNotEmpty
                      ? "${scheme.history.first.amount?.toStringAsFixed(2) ?? '0.0'} g"
                      : '0.0 g'),
            ),
          ]),
          const SizedBox(height: 16),

          // ---------------- PAYMENT HISTORY ----------------
          _sectionTitle("Payment History"),
          if (scheme.history.isNotEmpty)
            Column(
              children: scheme.history.map<Widget>((tx) {
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "₹${tx.amount?.toStringAsFixed(2) ?? '0.00'}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Due: ${tx.dueDate ?? '-'}"),
                            Text("Paid: ${tx.isPaid == true ? 'Yes' : 'No'}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            )
          else
            const Center(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("No Payment History Found"),
            )),
        ],
      ),
    );
  }

  // ---------------- HELPERS ----------------
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
      ),
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }

  Widget _infoRow(String key, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key, style: const TextStyle(fontWeight: FontWeight.w600)),
          Flexible(
            child: Text(
              value ?? '-', // safe null handling
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
