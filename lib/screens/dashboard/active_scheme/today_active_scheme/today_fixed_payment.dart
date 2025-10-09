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

  const TodayFixedPaymentWidget({
    super.key,
    required this.history,
    required this.savingId,
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

    final double fixedAmount = widget.history.firstWhere(
      (tx) => (tx.amount) > 0,
      orElse: () => widget.history.first,
    ).amount;

    final int firstUnpaidIndex = widget.history.indexWhere(
      (t) => t.status.toLowerCase() != "paid",
    );

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
                FetchTodayActiveSchemes(
                  startDate: today,
                  page: 1,
                  limit: 10,
                ),
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
        bool isLoading = state is AddCashSavingLoading &&
            currentPayingId == widget.savingId;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: Column(
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
                    borderRadius: BorderRadius.circular(12)),
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
                            "₹${fixedAmount.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          InkWell(
                            onTap: isNextDue && !isButtonLocked
                                ? () async {
                                    final confirm =
                                        await _showConfirmDialog(
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
                                        )
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

  Future<bool?> _showConfirmDialog(
      BuildContext context, double amount) async {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Confirm Payment",
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold),
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
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: Appcolors.buttoncolor),
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
