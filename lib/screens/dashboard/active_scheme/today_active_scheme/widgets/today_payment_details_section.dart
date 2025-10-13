import 'package:flutter/material.dart';
import 'package:admin/data/models/TodayActiveScheme.dart';
import 'package:admin/utils/style.dart';

class TodayPaymentDetailsSection extends StatefulWidget {
  final TodayActiveScheme scheme;
  const TodayPaymentDetailsSection({super.key, required this.scheme});

  @override
  State<TodayPaymentDetailsSection> createState() =>
      _TodayPaymentDetailsSectionState();
}

class _TodayPaymentDetailsSectionState
    extends State<TodayPaymentDetailsSection> {
  bool isExpanded = true;

  String formatGram(double? value, {int digits = 4}) {
    if (value == null) return "0.0000";
    return value.toStringAsFixed(digits);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = widget.scheme;
    final totalAmount = scheme.totalAmount ?? 0;
    final paidAmount = scheme.paidAmount ?? 0;
    final progress = totalAmount > 0 ? (paidAmount / totalAmount) : 0.0;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.only(top: 8, bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Header Row with Toggle Icon
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.currency_rupee,
                      color: Colors.blue, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Payment Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Clear summary of amounts & gold progress",
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: AnimatedRotation(
                    turns: isExpanded ? 0.0 : 0.5,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(Icons.keyboard_arrow_down,
                        color: Colors.black54, size: 28),
                  ),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ],
            ),

            //  Animated Expand/Collapse Body
            AnimatedCrossFade(
              crossFadeState: isExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
              firstChild: _buildContent(context, scheme, progress),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, TodayActiveScheme scheme, double progress) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final amountSection = _buildAmountSection(scheme, progress);
          final goldSection = _buildGoldSection(scheme);

          return isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: amountSection),
                    const SizedBox(width: 16),
                    Expanded(child: goldSection),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    amountSection,
                    const SizedBox(height: 16),
                    goldSection,
                  ],
                );
        },
      ),
    );
  }

  //  LEFT SECTION — Amount Details
  Widget _buildAmountSection(TodayActiveScheme scheme, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Total Amount",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black54)),
        const SizedBox(height: 4),
        Text("₹${scheme.totalAmount?.toStringAsFixed(2) ?? "0.00"}",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.black)),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Paid",
                style: TextStyle(fontSize: 13, color: Colors.black54)),
            Text("₹${scheme.paidAmount?.toStringAsFixed(2) ?? "0.00"}",
                style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        const Text("Next Due On",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black54)),
        const SizedBox(height: 4),
        Text(
          scheme.history.isNotEmpty
              ? formatDate(scheme.history.first.dueDate)
              : "-",
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        const Text("Payment Breakdown",
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black54)),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            color: Colors.blue,
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 6),
        Text("${(progress * 100).toStringAsFixed(2)}%",
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }

  //  RIGHT SECTION — Gold Summary
  Widget _buildGoldSection(TodayActiveScheme scheme) {
    final double goldWithoutBenefits = scheme.history.isNotEmpty
        ? scheme.history.first.goldWeight
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Headings Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total Gold (without benefits)",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
            ),
            Text("Benefits",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade700)),
          ],
        ),
        const SizedBox(height: 6),

        // Gold Values
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${formatGram(goldWithoutBenefits)} g",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              "+${formatGram(scheme.totalBenefitGram)} g",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.green),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 6),

        // Total Gold Weight
        Text.rich(
          TextSpan(
            text: "Total Gold Weight (incl. Benefits): ",
            style: const TextStyle(fontSize: 13, color: Colors.black54),
            children: [
              TextSpan(
                text: "${formatGram(scheme.tottalbonusgoldweight)} g",
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // Delivery Status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Delivered: ${formatGram(scheme.deliveredGoldWeight)} g",
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: scheme.goldDelivered
                    ? Colors.green.shade50
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                scheme.goldDelivered ? "Delivered" : "Not Delivered",
                style: TextStyle(
                  color: scheme.goldDelivered
                      ? Colors.green.shade700
                      : Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
