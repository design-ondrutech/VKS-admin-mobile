import 'package:admin/data/models/TotalActiveScheme.dart';
import 'package:admin/screens/dashboard/active_scheme/total_active_scheme/total_fixed_payment.dart';
import 'package:admin/screens/dashboard/active_scheme/total_active_scheme/total_flexible_payment.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/blocs/total_active_scheme/total_active_bloc.dart';
import 'package:admin/blocs/total_active_scheme/total_active_state.dart';

class TotalActiveSchemeDetailScreen extends StatelessWidget {
  final TotalActiveScheme scheme;

  const TotalActiveSchemeDetailScreen({super.key, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          scheme.schemeName,
          style: const TextStyle(color: Appcolors.white),
        ),
        centerTitle: true,
        backgroundColor: Appcolors.headerbackground,
      ),
      body: BlocBuilder<TotalActiveBloc, TotalActiveState>(
        builder: (context, state) {
          TotalActiveScheme currentScheme = scheme;

          //  When data refreshed after payment success
          if (state is TotalActiveLoaded) {
            try {
              currentScheme = state.response.data.firstWhere(
                (s) => s.savingId == scheme.savingId,
                orElse: () => scheme,
              );
            } catch (_) {}
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ---------------- SUMMARY CARDS ----------------
              Row(
                children: [
                  Expanded(
                    child: _summaryCard(
                      title: "Total Amount",
                      value: "₹${currentScheme.totalAmount.toStringAsFixed(2)}",
                      color: Colors.green[400]!,
                      icon: Icons.account_balance_wallet,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _summaryCard(
                      title: "Total Gold Weight",
                      value: "${currentScheme.totalGoldWeight} g",
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
                _infoRow("Scheme Name", currentScheme.schemeName),
                _infoRow("Scheme Type", currentScheme.schemeType),
                _infoRow("Status", currentScheme.status),
                _infoRow(
                    "Gold Delivered", currentScheme.goldDelivered > 0 ? "Yes" : "No"),
                _infoRow(
                  "Delivered Gold Weight",
                  "${currentScheme.deliveredGoldWeight.toStringAsFixed(2)} gm",
                ),
                _infoRow(
                  "Balance Gold Weight",
                  "${currentScheme.pendingGoldWeight.toStringAsFixed(2)} gm",
                ),
                _infoRow("Purpose", currentScheme.schemePurpose),
                _infoRow("KYC Completed", currentScheme.isKyc ? "Yes" : "No"),
                _infoRow("Start Date", formatDate(currentScheme.startDate)),
                _infoRow("End Date", formatDate(currentScheme.endDate)),
                _infoRow("Last Updated", formatDate(currentScheme.lastUpdated)),
              ]),
              const SizedBox(height: 16),

              // ---------------- CUSTOMER INFO ----------------
              _sectionTitle("Customer Info"),
              _infoCard([
                _infoRow("Name", currentScheme.customer.name),
                _infoRow("Email", currentScheme.customer.email),
                _infoRow("Phone", currentScheme.customer.phoneNumber),
              ]),
              const SizedBox(height: 16),

              // ---------------- PAYMENT DETAILS ----------------
              _sectionTitle("Payment Details"),
              _infoCard([
                _infoRow("Total Amount",
                    "₹${currentScheme.totalAmount.toStringAsFixed(2)}"),
                _infoRow("Paid Amount",
                    "₹${currentScheme.paidAmount.toStringAsFixed(2)}"),
                if (currentScheme.history.isNotEmpty)
                  _infoRow("Next Due On", formatDate(currentScheme.history.first.dueDate)),
                if (currentScheme.history.isNotEmpty)
                  _infoRow("Gold Gram",
                      "${currentScheme.history.first.goldWeight.toStringAsFixed(2)} g"),
              ]),
              const SizedBox(height: 16),

              // ---------------- PAYMENT HISTORY ----------------
              _sectionTitle("Payment History"),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: (currentScheme.schemeType.toLowerCase()) == "flexible"
                    ? FlexiblePaymentHistoryWidget(
                        key: ValueKey("${currentScheme.savingId}_flexible"),
                        history: currentScheme.history,
                        savingId: currentScheme.savingId,
                      )
                    : FixedPaymentHistoryWidget(
                        key: ValueKey("${currentScheme.savingId}_fixed"),
                        history: currentScheme.history,
                        savingId: currentScheme.savingId,
                      ),
              ),
            ],
          );
        },
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
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
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

  Widget _infoRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key, style: const TextStyle(fontWeight: FontWeight.w600)),
          Flexible(child: Text(value, textAlign: TextAlign.right)),
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
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
