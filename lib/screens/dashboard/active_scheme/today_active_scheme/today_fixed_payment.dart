import 'package:admin/blocs/today_active_scheme/today_active_bloc.dart';
import 'package:admin/blocs/today_active_scheme/today_active_event.dart';
import 'package:admin/blocs/today_active_scheme/today_active_state.dart';
import 'package:admin/data/models/TodayActiveScheme.dart';
import 'package:admin/data/models/TotalActiveScheme.dart'; // For History model
import 'package:admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/utils/style.dart';

class FixedPaymentHistoryWidget extends StatelessWidget {
  final List<PaymentHistory> history;
  final String savingId;

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

    //  Fixed installment amount
    double fixedAmount = history.isNotEmpty
        ? history.firstWhere(
            (tx) => (tx.amount) > 0,
            orElse: () => history.first,
          ).amount
        : 0;

    //  Find first unpaid installment
    int firstUnpaidIndex = history.indexWhere(
      (t) => t.status.toLowerCase() != "paid",
    );

    return BlocConsumer<TodayActiveSchemeBloc, TodayActiveSchemeState>(
      listener: (context, state) {
        if (state is AddCashSavingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green[700],
              content: const Text(
                "Payment Successful ✅",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );

          // Refresh data after successful payment
          context.read<TodayActiveSchemeBloc>().add(FetchTodayActiveSchemes(page: 1, limit: 10, startDate: ''));
        } else if (state is AddCashSavingError) {
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
        bool isLoading = state is AddCashSavingLoading;

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
                    //  Amount & Button Row
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
                                            onPressed: () =>
                                                Navigator.pop(context, false),
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
                                            child: const Text(
                                              "Confirm",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm == true) {
                                    context
                                        .read<TodayActiveSchemeBloc>()
                                        .add(AddCashCustomerSavingEvent(
                                          savingId: savingId,
                                          amount: fixedAmount,
                                        ));
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
