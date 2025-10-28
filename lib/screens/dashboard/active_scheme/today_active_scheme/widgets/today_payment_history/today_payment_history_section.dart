import 'package:flutter/material.dart';
import 'package:admin/data/models/TodayActiveScheme.dart';
import 'package:admin/screens/dashboard/active_scheme/today_active_scheme/widgets/today_payment_history/today_fixed_payment.dart';
import 'package:admin/screens/dashboard/active_scheme/today_active_scheme/widgets/today_payment_history/today_flexible_payment.dart';

class TodayPaymentHistorySection extends StatefulWidget {
  final TodayActiveScheme scheme;
  const TodayPaymentHistorySection({super.key, required this.scheme});

  @override
  State<TodayPaymentHistorySection> createState() =>
      _TodayPaymentHistorySectionState();
}

class _TodayPaymentHistorySectionState
    extends State<TodayPaymentHistorySection> {
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
            //  Header Row (Wallet Icon + Title + Expand Button)
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.blue,
                    size: 22,
                  ),
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

            //  Smooth Expand / Collapse Animation
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

  //  Inside Payment History Content
  Widget _buildPaymentHistoryContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: widget.scheme.schemeType.toLowerCase() == "flexible"
          ? TodayFlexiblePaymentWidget(
              key: ValueKey("${widget.scheme.savingId}_flexible"),
              history: widget.scheme.history,
              savingId: widget.scheme.savingId,
            )
          : TodayFixedPaymentWidget(
              key: ValueKey("${widget.scheme.savingId}_fixed"),
              history: widget.scheme.history,
              savingId: widget.scheme.savingId,
            ),
    );
  }
}
