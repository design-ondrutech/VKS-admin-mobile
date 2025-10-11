import 'package:admin/screens/dashboard/active_scheme/today_active_scheme/widgets/today_payment_history/today_payment_history_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/blocs/today_active_scheme/today_active_bloc.dart';
import 'package:admin/blocs/today_active_scheme/today_active_state.dart';
import 'package:admin/data/models/TodayActiveScheme.dart';
import 'package:admin/utils/colors.dart';


// import section widgets
import 'widgets/today_scheme_details_section.dart';
import 'widgets/today_customer_info_section.dart';

class TodayActiveSchemeDetailScreen extends StatelessWidget {
  final TodayActiveScheme scheme;

  const TodayActiveSchemeDetailScreen({super.key, required this.scheme});

  String formatGram(double? value, {int digits = 4}) {
    if (value == null) return "0.0000";
    return value.toStringAsFixed(digits);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          scheme.schemeName.isNotEmpty ? scheme.schemeName : "-",
          style: const TextStyle(color: Appcolors.white),
        ),
        centerTitle: true,
        backgroundColor: Appcolors.headerbackground,
      ),
      body: BlocBuilder<TodayActiveSchemeBloc, TodayActiveSchemeState>(
        builder: (context, state) {
          TodayActiveScheme currentScheme = scheme;
        
          // Refresh after payment
          if (state is TodayActiveSchemeLoaded) {
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
              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _summaryCard(
                      title: "Total Amount",
                      value:
                          "₹${currentScheme.totalAmount?.toStringAsFixed(2)}",
                      color: Colors.green[400]!,
                      icon: Icons.account_balance_wallet,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _summaryCard(
                      title: "Total Gold Weight",
                      value:
                          "${formatGram(currentScheme.totalGoldWeight)} g",
                      color: Colors.amber[700]!,
                      icon: Icons.scale,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Scheme Details
              TodaySchemeDetailsSection(scheme: currentScheme),

              // Customer Info
              TodayCustomerInfoSection(customer: currentScheme.customer),

              // Payment History
              TodayPaymentHistorySection(scheme: currentScheme),
            ],
          );
        },
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
