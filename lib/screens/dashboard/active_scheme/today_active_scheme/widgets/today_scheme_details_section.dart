import 'package:flutter/material.dart';
import 'package:admin/data/models/TodayActiveScheme.dart';
import 'package:admin/utils/style.dart';

class TodaySchemeDetailsSection extends StatefulWidget {
  final TodayActiveScheme scheme;
  const TodaySchemeDetailsSection({super.key, required this.scheme});

  @override
  State<TodaySchemeDetailsSection> createState() =>
      _TodaySchemeDetailsSectionState();
}

class _TodaySchemeDetailsSectionState extends State<TodaySchemeDetailsSection> {
  bool isExpanded = true;
  late TodayActiveScheme _currentScheme;

  @override
  void initState() {
    super.initState();
    _currentScheme = widget.scheme;
  }

  String formatGram(double? value, {int digits = 4}) {
    if (value == null) return "0.0000";
    return value.toStringAsFixed(digits);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = _currentScheme;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header Row (Title + Expand/Collapse)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.redAccent,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Scheme Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
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
            const SizedBox(height: 8),

            AnimatedCrossFade(
              crossFadeState:
                  isExpanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
              firstChild: _buildContent(scheme),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(TodayActiveScheme scheme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        return isWide
            ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildLeftSection(scheme)),
                const SizedBox(width: 20),
                Expanded(flex: 1, child: _buildGoldSummary(scheme)),
              ],
            )
            : Column(
              children: [
                _buildLeftSection(scheme),
                const SizedBox(height: 20),
                _buildGoldSummary(scheme),
              ],
            );
      },
    );
  }

  Widget _buildLeftSection(TodayActiveScheme scheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT COLUMN
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoBlock(
                "Scheme Name",
                scheme.schemeName,
                highlight: true,
                fontSize: 18,
              ),
              const SizedBox(height: 16),
              _infoBlock("Purpose", scheme.schemePurpose),
              const SizedBox(height: 16),
              _infoBlock("Start Date", formatDate(scheme.startDate)),
              const SizedBox(height: 16),
              _infoBlock("End Date", formatDate(scheme.endDate)),
            ],
          ),
        ),
        const SizedBox(width: 60),

        // RIGHT COLUMN
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoBlock(
                scheme.schemeType.toLowerCase() == "fixed"
                    ? "Total Amount"
                    : "Paid Amount",
                scheme.schemeType.toLowerCase() == "fixed"
                    ? "₹${formatAmount(scheme.totalAmount)}"
                    : "₹${formatAmount(scheme.paidAmount)}",
                highlight: true,
                fontSize: 20,
                color: Colors.black,
                valueColor: Colors.black87,
              ),

              const SizedBox(height: 16),
              _infoBlock(
                "Scheme Type",
                scheme.schemeType,
                badgeColor: Colors.amber.shade100,
                badgeTextColor: Colors.orange.shade900,
              ),
              const SizedBox(height: 16),
              _infoBlock(
                "KYC Status",
                scheme.isKyc ? "Verified" : "KYC Pending",
                badgeColor:
                    scheme.isKyc ? Colors.green.shade100 : Colors.red.shade100,
                badgeTextColor:
                    scheme.isKyc ? Colors.green.shade900 : Colors.red.shade900,
              ),
              const SizedBox(height: 16),
              _infoBlock(
                "Status",
                scheme.status,
                badgeColor: Colors.yellow.shade100,
                badgeTextColor: Colors.orange.shade900,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGoldSummary(TodayActiveScheme scheme) {
    double totalRequired = (scheme.tottalbonusgoldweight ?? 0);
    double delivered = scheme.deliveredGoldWeight;

    final double totalWithBonus = scheme.tottalbonusgoldweight ?? 0.0;
    final double remaining = (totalWithBonus - delivered).clamp(
      0.0,
      double.infinity,
    );

    // Determine display status
    if (scheme.status.toLowerCase() == "completed") {
      if (delivered >= totalRequired && totalRequired > 0) {
      } else {}
    } else {}

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "✨ Gold Summary",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        _goldCard(
          title: "Total Gold (incl. benefits)",
          value: formatGram(scheme.tottalbonusgoldweight),
          subtitle: "Includes benefit grams",
          color: Colors.blue.shade50,
          textColor: Colors.blue.shade700,
        ),
        const SizedBox(height: 10),

        _goldCard(
          title: "Total Gold (without benefits)",
          value: formatGram(scheme.totalGoldWeight),
          subtitle: "Without benefit grams",
          color: Colors.yellow.shade50,
          textColor: Colors.orange.shade700,
        ),
        const SizedBox(height: 10),

        _goldCard(
          title: "Delivered (stored)",
          value: formatGram(scheme.deliveredGoldWeight),
          subtitle: "Already recorded in DB",
          color: Colors.green.shade50,
          textColor: Colors.green.shade700,
        ),
        const SizedBox(height: 10),

        _goldCard(
          title: "Remaining",
          value: formatGram(remaining),
          subtitle: "Remaining to reach total",
          color: Colors.grey.shade100,
          textColor: Colors.grey.shade700,
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Status Label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Builder(
                builder: (context) {
                  String deliveryText;
                  IconData deliveryIcon;
                  Color deliveryColor;

                  if (delivered >= totalRequired && totalRequired > 0) {
                    deliveryText = "Delivered";
                    deliveryIcon = Icons.check_circle;
                    deliveryColor = Colors.green.shade700;
                  } else if (delivered > 0 && delivered < totalRequired) {
                    deliveryText = "Partially Delivered";
                    deliveryIcon = Icons.hourglass_bottom;
                    deliveryColor = Colors.orange.shade700;
                  } else {
                    deliveryText = "Not Delivered";
                    deliveryIcon = Icons.settings_outlined;
                    deliveryColor = Colors.black54;
                  }

                  return Row(
                    children: [
                      Icon(deliveryIcon, size: 16, color: deliveryColor),
                      const SizedBox(width: 6),
                      Text(
                        deliveryText,
                        style: TextStyle(
                          color: deliveryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            //  Update Gold Delivered Button (only if awaiting delivery)
            // if (displayStatus == "Completed (Awaiting Delivery)")
            //   ElevatedButton.icon(
            //     onPressed: () async {
            //       final addedGoldGram = await showDialog<double>(
            //         context: context,
            //         builder:
            //             (context) => SchemeCompletePopup(
            //               totalGoldRequired: totalRequired,
            //               alreadyDelivered: delivered,
            //               remainingGold: pending,
            //             ),
            //       );

            //       if (addedGoldGram != null && addedGoldGram > 0) {
            //         setState(() {
            //           _currentScheme = _currentScheme.copyWith(
            //             deliveredGoldWeight:
            //                 _currentScheme.deliveredGoldWeight + addedGoldGram,
            //             pendingGoldWeight: (_currentScheme.pendingGoldWeight -
            //                     addedGoldGram)
            //                 .clamp(0.0, double.infinity),
            //           );
            //         });

            //         final success = await context
            //             .read<TodayActiveSchemeRepository>()
            //             .updateDeliveredGold(
            //               savingId: _currentScheme.savingId,
            //               deliveredGold: _currentScheme.deliveredGoldWeight,
            //             );

            //         if (!success) {
            //           ScaffoldMessenger.of(context).showSnackBar(
            //             SnackBar(
            //               content: const Text(
            //                 "⚠️ Failed to sync with server",
            //                 style: TextStyle(color: Colors.white),
            //               ),
            //               backgroundColor: Colors.redAccent,
            //             ),
            //           );
            //         } else {
            //           ScaffoldMessenger.of(context).showSnackBar(
            //             SnackBar(
            //               content: Text(
            //                 "✅ ${addedGoldGram.toStringAsFixed(4)} g added to Delivered Gold",
            //                 style: const TextStyle(color: Colors.white),
            //               ),
            //               backgroundColor: Colors.green.shade600,
            //               duration: const Duration(seconds: 2),
            //             ),
            //           );
            //         }
            //       }
            //     },
            //     icon: const Icon(
            //       Icons.upload_rounded,
            //       color: Colors.white,
            //       size: 18,
            //     ),
            //     label: const Text(
            //       "Update Gold Delivered",
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontWeight: FontWeight.w600,
            //         fontSize: 13,
            //       ),
            //     ),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.blue,
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 1,
            //         vertical: 10,
            //       ),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ],
    );
  }

  Widget _infoBlock(
    String label,
    String value, {
    bool highlight = false,
    double fontSize = 15,
    Color? color,
    Color? valueColor,
    Color? badgeColor,
    Color? badgeTextColor,
  }) {
    return SizedBox(
      width: 230,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 3),
          if (badgeColor != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: badgeTextColor ?? Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            )
          else
            Text(
              value,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
                color: valueColor ?? Colors.black87,
              ),
            ),
        ],
      ),
    );
  }

  Widget _goldCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$value g",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: textColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  "0g",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
