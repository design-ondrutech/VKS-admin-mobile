import 'package:admin/blocs/today_active_scheme/today_active_bloc.dart';
import 'package:admin/blocs/today_active_scheme/today_active_state.dart';
import 'package:admin/data/models/TodayActiveScheme.dart';
import 'package:admin/screens/dashboard/active_scheme/today_active_scheme/today_fixed_payment.dart';
import 'package:admin/screens/dashboard/active_scheme/today_active_scheme/today_flexible_payment.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodayActiveSchemeDetailScreen extends StatelessWidget {
  final TodayActiveScheme scheme; //  unified model

  const TodayActiveSchemeDetailScreen({super.key, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          scheme.schemeName.isNotEmpty ? scheme.schemeName : '-',
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
                  value: "₹${scheme.totalAmount?.toStringAsFixed(2)}",
                  color: Colors.green[400]!,
                  icon: Icons.account_balance_wallet,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryCard(
                  title: "Total Gold Weight",
                  value: "${scheme.totalGoldWeight?.toStringAsFixed(2)} g",
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
            _infoRow("Scheme Name", scheme.schemeName),
            _infoRow("Scheme Type", scheme.schemeType),
            _infoRow("Status", scheme.status),
            _infoRow("Gold Delivered", scheme.goldDelivered ? "Yes" : "No"),
            _infoRow(
              "Delivered Gold Weight",
              "${scheme.deliveredGoldWeight?.toStringAsFixed(2)} gm",
            ),
            _infoRow(
              "Balance Gold Weight",
              "${scheme.pendingGoldWeight?.toStringAsFixed(2)} gm",
            ),
            _infoRow("Purpose", scheme.schemePurpose),
            _infoRow("KYC Completed", scheme.isKyc ? "Yes" : "No"),
            _infoRow("Start Date", formatDate(scheme.startDate)),
            _infoRow("End Date", formatDate(scheme.endDate)),
            _infoRow("Last Updated", formatDate(scheme.lastUpdated)),
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
            _infoRow(
              "Total Amount",
              "₹${scheme.totalAmount?.toStringAsFixed(2)}",
            ),
            _infoRow(
              "Paid Amount",
              "₹${scheme.paidAmount?.toStringAsFixed(2)}",
            ),
            _infoRow(
              "Next Due On",
              scheme.history.isNotEmpty
                  ? formatDate(scheme.history.first.dueDate)
                  : "-",
            ),
            _infoRow(
              "Gold Gram",
              scheme.history.isNotEmpty
                  ? "${scheme.history.first.goldWeight.toStringAsFixed(2)} g"
                  : "0.00 g",
            ),
          ]),
          const SizedBox(height: 16),

          // ---------------- PAYMENT HISTORY ----------------
          // ---------------- PAYMENT HISTORY ----------------
          _sectionTitle("Payment History"),

          BlocBuilder<TodayActiveSchemeBloc, TodayActiveSchemeState>(
            builder: (context, state) {
              TodayActiveScheme currentScheme = scheme;

              //  When new data is fetched after payment success
              if (state is TodayActiveSchemeLoaded) {
                try {
                  currentScheme = state.response.data.firstWhere(
                    (s) => s.savingId == scheme.savingId,
                    orElse: () => scheme,
                  );
                } catch (_) {}
              }

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child:
                    (currentScheme.schemeType.toLowerCase()) == "flexible"
                        ? TodayFlexiblePaymentWidget(
                          key: ValueKey("${currentScheme.savingId}_flexible"),
                          history: currentScheme.history,
                          savingId: currentScheme.savingId,
                        )
                        : TodayFixedPaymentWidget(
                          key: ValueKey("${currentScheme.savingId}_fixed"),
                          history: currentScheme.history,
                          savingId: currentScheme.savingId,
                        ),
              );
            },
          ),
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
