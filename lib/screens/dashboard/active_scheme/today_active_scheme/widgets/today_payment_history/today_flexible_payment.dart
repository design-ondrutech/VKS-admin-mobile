import 'package:admin/blocs/today_active_scheme/today_active_bloc.dart';
import 'package:admin/blocs/today_active_scheme/today_active_event.dart';
import 'package:admin/blocs/today_active_scheme/today_active_state.dart';
import 'package:admin/data/models/TodayActiveScheme.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodayFlexiblePaymentWidget extends StatefulWidget {
  final List<PaymentHistory> history;
  final String savingId;

  const TodayFlexiblePaymentWidget({
    super.key,
    required this.history,
    required this.savingId,
  });

  @override
  State<TodayFlexiblePaymentWidget> createState() =>
      _TodayFlexiblePaymentWidgetState();
}

class _TodayFlexiblePaymentWidgetState
    extends State<TodayFlexiblePaymentWidget> {
  final TextEditingController _amountCtrl = TextEditingController();
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final validPayments = widget.history.where((tx) => tx.amount > 0).toList();

    return BlocConsumer<TodayActiveSchemeBloc, TodayActiveSchemeState>(
      listener: (context, state) async {
        if (state is AddCashSavingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text("✅ Payment Successful"),
            ),
          );

          setState(() {
            isProcessing = false;
          });

          _amountCtrl.clear();

          await Future.delayed(const Duration(milliseconds: 400));

          final today = DateTime.now().toIso8601String().split('T').first;
          context.read<TodayActiveSchemeBloc>().add(
            FetchTodayActiveSchemes(startDate: today, page: 1, limit: 10),
          );
        } else if (state is AddCashSavingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red[700],
              content: Text("Payment Failed ❌: ${state.message}"),
            ),
          );
          setState(() {
            isProcessing = false;
          });
        } else if (state is AddCashSavingLoading) {
          setState(() {
            isProcessing = true;
          });
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Payment Entry Box
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountCtrl,
                        decoration: InputDecoration(
                          hintText: "Enter amount",
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed:
                          isProcessing
                              ? null
                              : () async {
                                final entered = _amountCtrl.text.trim();
                                final amount = double.tryParse(entered);

                                if (entered.isEmpty ||
                                    amount == null ||
                                    amount <= 0) {
                                  _showAlert(
                                    context,
                                    "Invalid Amount",
                                    "Please enter a valid number",
                                  );
                                  return;
                                }

                                final confirm = await _showConfirmDialog(
                                  context,
                                  amount,
                                );
                                if (confirm == true) {
                                  context.read<TodayActiveSchemeBloc>().add(
                                    AddCashCustomerSavingEvent(
                                      savingId: widget.savingId,
                                      amount: amount,
                                    ),
                                  );

                                  setState(() {
                                    isProcessing = true;
                                  });
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.buttoncolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          isProcessing
                              ? Row(
                                children: const [
                                  SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Processing...",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              )
                              : const Text(
                                "Pay Now",
                                style: TextStyle(color: Colors.white),
                              ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            //  Payment History Section
            if (validPayments.isNotEmpty)
              Column(
                children:
                    validPayments.map((tx) {
                      bool isPaid = tx.status.toLowerCase() == "paid";
                      return Card(
                        elevation: 2,
                        color: isPaid ? Colors.green[50] : Colors.orange[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "₹${formatAmount(tx.amount)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),

                                  const SizedBox(height: 4),
                                  Text("Due: ${formatDate(tx.dueDate)}"),
                                  Text(
                                    "Paid:  ${tx.paidDate.isNotEmpty ? formatDate(tx.paidDate) : '-'}",
                                  ),
                                  Text("Mode: ${tx.paymentMode}"),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      isPaid
                                          ? Colors.green[200]
                                          : Colors.orange[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 12,
                                ),
                                child: Text(
                                  isPaid ? "PAID" : "Pending",
                                  style: TextStyle(
                                    color:
                                        isPaid
                                            ? Colors.green[800]
                                            : Colors.orange[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              )
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("No Payment History Found"),
                ),
              ),
          ],
        );
      },
    );
  }

  //  Alert Helper
  void _showAlert(BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(msg),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  //  Confirmation Dialog
  Future<bool?> _showConfirmDialog(BuildContext context, double amount) async {
    return showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
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
