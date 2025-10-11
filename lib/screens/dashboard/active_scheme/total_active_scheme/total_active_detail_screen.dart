import 'package:admin/data/models/TotalActiveScheme.dart';
import 'package:admin/screens/dashboard/active_scheme/total_active_scheme/widgets/payment_history/payment_history_section.dart';
import 'package:admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/blocs/total_active_scheme/total_active_bloc.dart';
import 'package:admin/blocs/total_active_scheme/total_active_state.dart';

// --- Imported new widgets ---
import 'widgets/scheme_details_section.dart';
import 'widgets/customer_info_section.dart';

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
              Row(
                children: [
                  Expanded(
                    child: _summaryCard(
                      title: "Total Amount",
                      value:
                          "₹${currentScheme.totalAmount.toStringAsFixed(2)}",
                      color: Colors.green[400]!,
                      icon: Icons.account_balance_wallet,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _summaryCard(
                      title: "Total Gold Weight",
                      value:
                          "${_formatGram(currentScheme.totalGoldWeight)} g",
                      color: Colors.amber[700]!,
                      icon: Icons.scale,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Scheme Details
              SchemeDetailsSection(scheme: currentScheme),

              // Customer Info
              CustomerInfoSection(customer: currentScheme.customer),

              // Payment History
              PaymentHistorySection(scheme: currentScheme),
            ],
          );
        },
      ),
    );
  }

  String _formatGram(double? value, {int digits = 4}) {
    if (value == null) return "0.0000";
    return value.toStringAsFixed(digits);
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
            Text(title,
                style: const TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.w600)),
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
