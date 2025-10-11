import 'package:admin/screens/dashboard/active_scheme/total_active_scheme/widgets/payment_history/total_fixed_payment.dart';
import 'package:admin/screens/dashboard/active_scheme/total_active_scheme/widgets/payment_history/total_flexible_payment.dart';
import 'package:flutter/material.dart';
import 'package:admin/data/models/TotalActiveScheme.dart';

class PaymentHistorySection extends StatelessWidget {
  final TotalActiveScheme scheme;
  const PaymentHistorySection({super.key, required this.scheme});

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
              ? FlexiblePaymentHistoryWidget(
                  key: ValueKey("${scheme.savingId}_flexible"),
                  history: scheme.history,
                  savingId: scheme.savingId,
                )
              : FixedPaymentHistoryWidget(
                  key: ValueKey("${scheme.savingId}_fixed"),
                  history: scheme.history,
                  savingId: scheme.savingId,
                ),
        ),
      ],
    );
  }
}
