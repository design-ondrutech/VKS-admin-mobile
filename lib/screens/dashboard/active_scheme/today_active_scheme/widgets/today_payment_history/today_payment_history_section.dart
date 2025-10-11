import 'package:flutter/material.dart';
import 'package:admin/data/models/TodayActiveScheme.dart';
import 'package:admin/screens/dashboard/active_scheme/today_active_scheme/widgets/today_payment_history/today_fixed_payment.dart';
import 'package:admin/screens/dashboard/active_scheme/today_active_scheme/widgets/today_payment_history/today_flexible_payment.dart';

class TodayPaymentHistorySection extends StatelessWidget {
  final TodayActiveScheme scheme;
  const TodayPaymentHistorySection({super.key, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Payment History",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: scheme.schemeType.toLowerCase() == "flexible"
              ? TodayFlexiblePaymentWidget(
                  key: ValueKey("${scheme.savingId}_flexible"),
                  history: scheme.history,
                  savingId: scheme.savingId,
                )
              : TodayFixedPaymentWidget(
                  key: ValueKey("${scheme.savingId}_fixed"),
                  history: scheme.history,
                  savingId: scheme.savingId,
                ),
        ),
      ],
    );
  }
}
