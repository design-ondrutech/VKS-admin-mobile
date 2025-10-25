import 'package:flutter/material.dart';
import 'package:admin/data/models/TotalActiveScheme.dart';
import 'package:admin/utils/style.dart';

class PaymentDetailsSection extends StatefulWidget {
  final TotalActiveScheme scheme;
  const PaymentDetailsSection({super.key, required this.scheme});

  @override
  State<PaymentDetailsSection> createState() => _PaymentDetailsSectionState();
}

class _PaymentDetailsSectionState extends State<PaymentDetailsSection> {
  bool isExpanded = true; // initial open

  String formatGram(double? value, {int digits = 4}) {
    if (value == null) return "0.0000";
    return value.toStringAsFixed(digits);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = widget.scheme;
    final totalAmount = scheme.totalAmount;
    final paidAmount = scheme.paidAmount;
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
            // Header row with toggle icon
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.currency_rupee,
                    color: Colors.blue,
                    size: 20,
                  ),
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
                    child: const Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.black54,
                      size: 28,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ],
            ),

            // Animated expand/collapse body
            AnimatedCrossFade(
              crossFadeState:
                  isExpanded
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
    BuildContext context,
    TotalActiveScheme scheme,
    double progress,
  ) {
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

  Widget _buildAmountSection(TotalActiveScheme scheme, double progress) {
    final isFixed = scheme.schemeType.toLowerCase() == "fixed";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Header Row (labels)
        if (isFixed)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Total Amount",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              Text(
                "Paid",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          )
        else
          const Text(
            "Paid Amount",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        const SizedBox(height: 4),

        // 🔹 Amount Row (values)
        if (isFixed)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${scheme.totalAmount.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
              Text(
                "₹${scheme.paidAmount.toStringAsFixed(0)}",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          )
        else
          Text(
            "₹${scheme.paidAmount.toStringAsFixed(0)}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ),
          ),

        const SizedBox(height: 8),
        const Divider(),

        // 🔹 Next Due On Section
        if (scheme.schemeType.toLowerCase() == "fixed") ...[
          const Text(
            "Next Due On",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            (scheme.status.toLowerCase() == "completed" ||
                    scheme.status.toLowerCase() == "scheme completed")
                ? "--"
                : scheme.history.isNotEmpty
                ? "Due: ${formatDate(_getNextDueDate(scheme))}"
                : "-",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],

        if (isFixed) ...[
          const SizedBox(height: 12),
          const Text(
            "Payment Breakdown",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0), // Limit between 0%–100%
              backgroundColor: Colors.grey.shade200,
              color: Colors.blue,
              minHeight: 6,
            ),
          ),

          const SizedBox(height: 6),
          Text(
            "${(progress.clamp(0.0, 1.0) * 100).toStringAsFixed(0)}%",
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),

          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildGoldSection(TotalActiveScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total Gold (without benefits)",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            Text(
              "Benefits",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.green.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${formatGram(scheme.totalGoldWeight)} g",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              "+${formatGram(scheme.totalBenefitGram)} g",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 6),
        Text.rich(
          TextSpan(
            text: "Total Gold Weight (incl. Benefits): ",
            style: const TextStyle(fontSize: 13, color: Colors.black54),
            children: [
              TextSpan(
                text: "${formatGram(scheme.tottalbonusgoldweight)} g",
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Delivered: ${formatGram(scheme.deliveredGoldWeight)} g",
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),

            //  Dynamic delivery badge
            Builder(
              builder: (context) {
                final double delivered = scheme.deliveredGoldWeight;
                final double? totalRequired = scheme.tottalbonusgoldweight;

                String deliveryText;
                IconData deliveryIcon;
                Color deliveryColor;
                Color bgColor;

                if (delivered >= totalRequired! && totalRequired > 0) {
                  deliveryText = "Delivered";
                  deliveryIcon = Icons.check_circle;
                  deliveryColor = Colors.green.shade700;
                  bgColor = Colors.green.shade50;
                } else if (delivered > 0 && delivered < totalRequired) {
                  deliveryText = "Partially Delivered";
                  deliveryIcon = Icons.hourglass_bottom;
                  deliveryColor = Colors.orange.shade700;
                  bgColor = Colors.orange.shade50;
                } else {
                  deliveryText = "Not Delivered";
                  deliveryIcon = Icons.settings_outlined;
                  deliveryColor = Colors.black54;
                  bgColor = Colors.grey.shade200;
                }

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(deliveryIcon, size: 14, color: deliveryColor),
                      const SizedBox(width: 4),
                      Text(
                        deliveryText,
                        style: TextStyle(
                          color: deliveryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  String _getNextDueDate(TotalActiveScheme scheme) {
    final unpaidTx =
        scheme.history
            .where((tx) => tx.status.toLowerCase() != "paid")
            .toList();

    if (unpaidTx.isNotEmpty) {
      unpaidTx.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      return unpaidTx.first.dueDate;
    }

    final allTx = List.of(scheme.history);
    allTx.sort((a, b) => b.dueDate.compareTo(a.dueDate));
    return allTx.first.dueDate;
  }
}
