import 'package:admin/blocs/total_active_scheme/total_active_bloc.dart';
import 'package:admin/blocs/total_active_scheme/total_active_event.dart';
import 'package:admin/blocs/total_active_scheme/total_active_state.dart';
import 'package:admin/data/models/TotalActiveScheme.dart';
import 'package:admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/utils/style.dart';

class FixedPaymentHistoryWidget extends StatelessWidget {
  final List<History> history;
  final String savingId;
  final bool goldDelivered; // ✅ NEW

  const FixedPaymentHistoryWidget({
    super.key,
    required this.history,
    required this.savingId,
    required this.goldDelivered, // ✅ NEW
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

    double fixedAmount = history
        .firstWhere((tx) => tx.amount > 0, orElse: () => history.first)
        .amount;

    int firstUnpaidIndex =
        history.indexWhere((t) => t.status.toLowerCase() != "paid");

    return BlocConsumer<TotalActiveBloc, TotalActiveState>(
      listener: (context, state) async {
        if (state is CashPaymentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green[700],
              content: const Text(
                "✅ Payment Successful",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );

          await Future.delayed(const Duration(milliseconds: 500));
          context
              .read<TotalActiveBloc>()
              .add(FetchTotalActiveSchemes(page: 1, limit: 10));
        } else if (state is CashPaymentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red[700],
              content: Text(
                "❌ Payment Failed: ${state.message}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        bool isLoading = state is CashPaymentLoading;
        String? currentPayingId;
        if (state is CashPaymentLoading) currentPayingId = state.savingId;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          child: goldDelivered
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ✅ Success message
                    Container(
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
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 48),
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

                    // ✅ Show entire payment history
                    ...history.map((tx) {
                      bool isPaid = tx.status.toLowerCase() == "paid";
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
              : // 🔹 Default (active scheme payment flow)
              Column(
                  key: ValueKey(DateTime.now().millisecondsSinceEpoch),
                  children: history.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final tx = entry.value;
                    bool isPaid = tx.status.toLowerCase() == "paid";
                    bool isNextDue = !isPaid && idx == firstUnpaidIndex;
                    bool isButtonLocked = isLoading &&
                        currentPayingId == savingId &&
                        isNextDue;

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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Text(
                                                      "You are about to pay:",
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      "₹${fixedAmount.toStringAsFixed(0)}",
                                                      style: const TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                        Navigator.pop(
                                                            context, false),
                                                    child: const Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Appcolors.buttoncolor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, true),
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
                                                .read<TotalActiveBloc>()
                                                .add(AddCashPayment(
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
                                    child: (isButtonLocked && isNextDue)
                                        ? Row(
                                            children: const [
                                              SizedBox(
                                                height: 16,
                                                width: 16,
                                                child:
                                                    CircularProgressIndicator(
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
}
