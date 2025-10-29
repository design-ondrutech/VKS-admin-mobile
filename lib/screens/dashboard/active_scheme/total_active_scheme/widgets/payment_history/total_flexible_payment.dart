import 'package:admin/blocs/total_active_scheme/total_active_bloc.dart';
import 'package:admin/blocs/total_active_scheme/total_active_event.dart';
import 'package:admin/blocs/total_active_scheme/total_active_state.dart';
import 'package:admin/data/models/TotalActiveScheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/style.dart';

class FlexiblePaymentHistoryWidget extends StatefulWidget {
  final List<History> history;
  final String savingId;

  const FlexiblePaymentHistoryWidget({
    super.key,
    required this.history,
    required this.savingId,
  });

  @override
  State<FlexiblePaymentHistoryWidget> createState() =>
      _FlexiblePaymentHistoryWidgetState();
}

class _FlexiblePaymentHistoryWidgetState
    extends State<FlexiblePaymentHistoryWidget> {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Filter valid payments
    final validPayments = widget.history.where((tx) => tx.amount > 0).toList();

    return BlocConsumer<TotalActiveBloc, TotalActiveState>(
      listener: (context, state) async {
        if (state is CashPaymentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green[700],
              content: Text(
                "Payment Successful ",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );

          _amountController.clear();

          // Delay slightly to allow animation, then refresh data
          await Future.delayed(const Duration(milliseconds: 500));
          context.read<TotalActiveBloc>().add(
            FetchTotalActiveSchemes(page: 1, limit: 10),
          );
        } else if (state is CashPaymentFailure) {
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
        String? currentPayingId;
        if (state is CashPaymentLoading) {
          currentPayingId = state.savingId;
        }

        bool isProcessing = isLoading && currentPayingId == widget.savingId;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Column(
            key: ValueKey(DateTime.now().millisecondsSinceEpoch),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 💰 Payment Entry Card
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
                          controller: _amountController,
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
                          enabled: !isProcessing,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed:
                            isProcessing
                                ? null
                                : () async {
                                  final entered = _amountController.text.trim();

                                  if (entered.isEmpty) {
                                    _showAlert(
                                      context,
                                      "Invalid Amount",
                                      "Please enter a valid amount before proceeding.",
                                    );
                                    return;
                                  }

                                  final amount = double.tryParse(entered);

                                  if (amount == null || amount <= 0) {
                                    _showAlert(
                                      context,
                                      "Invalid Amount",
                                      "Please enter a valid numeric amount greater than zero.",
                                    );
                                    return;
                                  }

                                  final confirm = await _showConfirmDialog(
                                    context,
                                    amount,
                                  );
                                  if (confirm == true) {
                                    context.read<TotalActiveBloc>().add(
                                      AddCashPayment(
                                        savingId: widget.savingId,
                                        amount: amount,
                                      ),
                                    );
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

              if (validPayments.isNotEmpty)
                Column(
                  children:
                      validPayments.map((tx) {
                        bool isPaid = tx.status.toLowerCase() == "paid";
                        return Card(
                          color: isPaid ? Colors.green[50] : Colors.orange[50],
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                                      "Paid: ${tx.paidDate.isNotEmpty ? formatDate(tx.paidDate) : '-'}",
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
          ),
        );
      },
    );
  }

  // 🪄 Alert Dialog Helper
  void _showAlert(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  // 🪄 Confirmation Dialog
  Future<bool?> _showConfirmDialog(BuildContext context, double amount) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Confirm Payment",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
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
                "₹${amount.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Do you want to proceed?",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Appcolors.buttoncolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                "Confirm",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
