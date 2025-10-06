import 'package:admin/blocs/total_active_scheme/active_scheme_bloc.dart';
import 'package:admin/blocs/total_active_scheme/active_scheme_event.dart';
import 'package:admin/blocs/total_active_scheme/active_scheme_state.dart';
import 'package:admin/data/models/total_active_scheme.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FixedPaymentHistoryWidget extends StatelessWidget {
  final List<PaymentHistory> history;
  final String savingId; // required for mutation call

  const FixedPaymentHistoryWidget({
    super.key,
    required this.history,
    required this.savingId,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("No Payment History Found"),
        ),
      );
    }

    //  Find the fixed installment amount (first non-zero)
    double fixedAmount = history.firstWhere(
      (tx) => (tx.amount ?? 0) > 0,
      orElse: () => history.first,
    ).amount ?? 0;

    //  Find the first unpaid card
    int firstUnpaidIndex = history.indexWhere(
      (t) => t.status.toLowerCase() != "paid",
    );

    return BlocConsumer<TotalActiveBloc, TotalActiveState>(
      listener: (context, state) {
     if (state is CashPaymentSuccess) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.green[700],
      content: Text(
        "Payment Successful (Total: ₹${state.totalAmount})",
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );

  //  Refresh data immediately after payment
  context.read<TotalActiveBloc>().add(FetchTotalActiveSchemes());
}
 else if (state is CashPaymentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red[700],
              content: Text(
                "Payment Failed ❌: ${state.message}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        bool isLoading = state is CashPaymentLoading;

        return Column(
          children: history.asMap().entries.map((entry) {
            final idx = entry.key;
            final tx = entry.value;

            bool isPaid = tx.status.toLowerCase() == "paid";
            bool isNextDue = !isPaid && idx == firstUnpaidIndex;

            return Card(
              elevation: 2,
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
                    //  Amount & Status Row
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
                          onTap: isNextDue && !isLoading
                              ? () async {
                                  //  Show confirmation dialog
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        title: const Text(
                                          "Confirm Payment",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "You are about to pay:",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "₹${fixedAmount.toStringAsFixed(0)}",
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              "Do you want to proceed?",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, false),
                                            child: const Text(
                                              "Cancel",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Appcolors.buttoncolor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text("Confirm",style: TextStyle(color: Colors.white),)
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm == true) {
                                    // 🪄 Trigger the same mutation
                                    context.read<TotalActiveBloc>().add(
                                          AddCashPayment(
                                            savingId: savingId,
                                            amount: fixedAmount,
                                          ),
                                        );
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
                                vertical: 6, horizontal: 12),
                            child: isLoading && isNextDue
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
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

                    //  Dates & Mode
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
        );
      },
    );
  }
}
