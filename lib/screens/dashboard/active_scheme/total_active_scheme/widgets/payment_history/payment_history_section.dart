import 'package:flutter/material.dart';
import 'package:admin/data/models/TotalActiveScheme.dart';
import 'package:admin/screens/dashboard/active_scheme/total_active_scheme/widgets/payment_history/total_fixed_payment.dart';
import 'package:admin/screens/dashboard/active_scheme/total_active_scheme/widgets/payment_history/total_flexible_payment.dart';

class PaymentHistorySection extends StatefulWidget {
  final TotalActiveScheme scheme;
  const PaymentHistorySection({super.key, required this.scheme});

  @override
  State<PaymentHistorySection> createState() => _PaymentHistorySectionState();
}

class _PaymentHistorySectionState extends State<PaymentHistorySection> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Header Row with Expand/Collapse
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.account_balance_wallet_rounded,
                      color: Colors.blue, size: 22),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "Payment History",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() => isExpanded = !isExpanded);
                  },
                  icon: AnimatedRotation(
                    turns: isExpanded ? 0 : 0.5,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: Colors.black54,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),

            //  Smooth Expand/Collapse Transition
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: isExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: _buildPaymentHistoryContent(),
              ),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentHistoryContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: widget.scheme.schemeType.toLowerCase() == "flexible"
          ? FlexiblePaymentHistoryWidget(
              key: ValueKey("${widget.scheme.savingId}_flexible"),
              history: widget.scheme.history,
              savingId: widget.scheme.savingId,
            )
          : FixedPaymentHistoryWidget(
              key: ValueKey("${widget.scheme.savingId}_fixed"),
              history: widget.scheme.history,
              savingId: widget.scheme.savingId,
            ),
    );
  }
}
