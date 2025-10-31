import 'package:admin/blocs/today_active_scheme/today_active_bloc.dart';
import 'package:admin/blocs/today_active_scheme/today_active_event.dart';
import 'package:admin/blocs/today_active_scheme/today_active_state.dart';
import 'package:admin/data/models/TodayActiveScheme.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodayFixedPaymentWidget extends StatefulWidget {
  final List<PaymentHistory> history;
  final String savingId;
  final bool goldDelivered;

  const TodayFixedPaymentWidget({
    super.key,
    required this.history,
    required this.savingId,
    required this.goldDelivered,
  });

  @override
  State<TodayFixedPaymentWidget> createState() =>
      _TodayFixedPaymentWidgetState();
}

class _TodayFixedPaymentWidgetState extends State<TodayFixedPaymentWidget> {
  String? currentPayingId;
  bool isButtonLocked = false;

  @override
  Widget build(BuildContext context) {
    if (widget.history.isEmpty) {
      return const Center(child: Text("No Payment History Found"));
    }

    final double fixedAmount = widget.history
        .firstWhere(
          (tx) => (tx.amount) > 0,
          orElse: () => widget.history.first,
        )
        .amount;

    final int firstUnpaidIndex =
        widget.history.indexWhere((t) => t.status.toLowerCase() != "paid");

    return BlocConsumer<TodayActiveSchemeBloc, TodayActiveSchemeState>(
      listener: (context, state) async {
        if (state is AddCashSavingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text("✅ Payment Successful"),
            ),
          );

          await Future.delayed(const Duration(milliseconds: 400));

          final today = DateTime.now().toIso8601String().split('T').first;
          context.read<TodayActiveSchemeBloc>().add(
                FetchTodayActiveSchemes(startDate: today, page: 1, limit: 10),
              );

          setState(() {
            currentPayingId = null;
            isButtonLocked = false;
          });
        } else if (state is AddCashSavingLoading) {
          setState(() {
            currentPayingId = widget.savingId;
            isButtonLocked = true;
          });
        } else if (state is AddCashSavingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red[700],
              content: Text("Payment Failed ❌: ${state.message}"),
            ),
          );

          setState(() {
            currentPayingId = null;
            isButtonLocked = false;
          });
        }
      },
      builder: (context, state) {
        return AnimatedSwitcher(
  duration: const Duration(milliseconds: 400),
  child: widget.goldDelivered == true
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ Success message card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    "Gold Fully Delivered",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "All payments are completed and gold has been delivered to the customer.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "✨ Scheme Completed Successfully",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Show payment history below
            ...widget.history.map((tx) {
              bool isPaid = tx.status.toLowerCase() == "paid";
              return Card(
                elevation: 3,
                margin:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: isPaid ? Colors.green[50] : Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹${formatAmount(tx.amount)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            child: const Text(
                              "PAID",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text("Due: ${formatDate(tx.dueDate)}"),
                      Text(
                        "Paid: ${tx.paidDate.isNotEmpty ? formatDate(tx.paidDate) : '-'}",
                      ),
                      Text("Mode: ${tx.paymentMode}"),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        )
      : // 🔹 Original payment UI (for ongoing payments)
      Column(
          key: ValueKey(DateTime.now().millisecondsSinceEpoch),
          children: widget.history.asMap().entries.map((entry) {
            final idx = entry.key;
            final tx = entry.value;

            bool isPaid = tx.status.toLowerCase() == "paid";
            bool isNextDue = !isPaid && idx == firstUnpaidIndex;

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: isPaid
                  ? Colors.green[50]
                  : isNextDue
                      ? Colors.yellow[50]
                      : Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Amount + Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹${formatAmount(fixedAmount)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        InkWell(
                          onTap: isNextDue && !isButtonLocked
                              ? () async {
                                  final confirm = await _showConfirmDialog(
                                      context, fixedAmount);
                                  if (confirm == true) {
                                    context
                                        .read<TodayActiveSchemeBloc>()
                                        .add(AddCashCustomerSavingEvent(
                                          savingId: widget.savingId,
                                          amount: fixedAmount,
                                        ));

                                    setState(() {
                                      isButtonLocked = true;
                                    });
                                  }
                                }
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isPaid
                                  ? Colors.green[100]
                                  : isNextDue
                                      ? Colors.blue[50]
                                      : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            child: (isButtonLocked && isNextDue)
                                ? Row(
                                    children: const [
                                      SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "Processing...",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    isPaid
                                        ? "PAID"
                                        : isNextDue
                                            ? "Pay Now"
                                            : "Pending",
                                    style: TextStyle(
                                      color: isPaid
                                          ? Colors.green
                                          : isNextDue
                                              ? Colors.blue
                                              : Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text("Due: ${formatDate(tx.dueDate)}"),
                    Text(
                        "Paid: ${tx.paidDate.isNotEmpty ? formatDate(tx.paidDate) : '-'}"),
                    Text("Mode: ${tx.paymentMode}"),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
);

      },
    );
  }

  Widget _buildPaymentCard(
      PaymentHistory tx, double fixedAmount, bool isNextDue) {
    bool isPaid = tx.status.toLowerCase() == "paid";
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isPaid
          ? Colors.green[50]
          : isNextDue
              ? Colors.yellow[50]
              : Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount + Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹${formatAmount(fixedAmount)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                // Hide pay button if gold delivered
                if (!widget.goldDelivered)
                  InkWell(
                    onTap: isNextDue && !isButtonLocked
                        ? () async {
                            final confirm =
                                await _showConfirmDialog(context, fixedAmount);
                            if (confirm == true) {
                              context
                                  .read<TodayActiveSchemeBloc>()
                                  .add(AddCashCustomerSavingEvent(
                                    savingId: widget.savingId,
                                    amount: fixedAmount,
                                  ));

                              setState(() {
                                isButtonLocked = true;
                              });
                            }
                          }
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isPaid
                            ? Colors.green[100]
                            : isNextDue
                                ? Colors.blue[50]
                                : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
                      child: (isButtonLocked && isNextDue)
                          ? Row(
                              children: const [
                                SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Processing...",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              isPaid
                                  ? "PAID"
                                  : isNextDue
                                      ? "Pay Now"
                                      : "Pending",
                              style: TextStyle(
                                color: isPaid
                                    ? Colors.green
                                    : isNextDue
                                        ? Colors.blue
                                        : Colors.grey[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text("Due: ${formatDate(tx.dueDate)}"),
            Text(
                "Paid: ${tx.paidDate.isNotEmpty ? formatDate(tx.paidDate) : '-'}"),
            Text("Mode: ${tx.paymentMode}"),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showConfirmDialog(BuildContext context, double amount) async {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          "Confirm Payment",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("You are about to pay:"),
            const SizedBox(height: 8),
            Text(
              "₹${amount.toStringAsFixed(0)}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Appcolors.buttoncolor,
            ),
            child: const Text(
              "Confirm",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
