import 'package:admin/blocs/cash_payment/cash_payment_bloc.dart';
import 'package:admin/blocs/cash_payment/cash_payment_event.dart';
import 'package:admin/blocs/cash_payment/cash_payment_state.dart';
import 'package:admin/data/models/cash_payment.dart';
import 'package:admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CashPaymentScreen extends StatelessWidget {
  const CashPaymentScreen({super.key});

  // ===== Helper Functions =====
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "paid":
        return Colors.green.shade100;
      case "unpaid":
        return Colors.orange.shade100;
      case "failed":
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _statusTextColor(String status) {
    switch (status.toLowerCase()) {
      case "paid":
        return Colors.green.shade800;
      case "unpaid":
        return Colors.orange.shade800;
      case "failed":
        return Colors.red.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case "paid":
        return Icons.check_circle;
      case "unpaid":
        return Icons.pending;
      case "failed":
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String _formatDate(String date) {
    try {
      final parsed = DateTime.tryParse(date);
      if (parsed != null) {
        return DateFormat("dd MMM yyyy, hh:mm a").format(parsed);
      }
    } catch (_) {}
    return date;
  }

  String _statusString(dynamic status) {
    if (status == 2 || status == '2') return "paid";
    if (status == 1 || status == '1') return "unpaid";
    if (status == 3 || status == '3') return "failed";
    return "unknown";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Cash Payments", style: TextStyle(color: Appcolors.white)),
        centerTitle: true,
        backgroundColor: Appcolors.headerbackground,
        elevation: 0,
      ),
      body: BlocBuilder<CashPaymentBloc, CashPaymentState>(
        builder: (context, state) {
          if (state is CashPaymentInitial) {
            context.read<CashPaymentBloc>().add(FetchCashPayments());
            return const Center(child: CircularProgressIndicator());
          } else if (state is CashPaymentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CashPaymentLoaded) {
            final payments = state.payments;
            if (payments.isEmpty) {
              return const Center(
                child: Text(
                  "No Cash Payments Found",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: payments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final CashPayment payment = payments[index];

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Customer + Status
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                payment.customerName.isNotEmpty
                                    ? payment.customerName
                                    : "No Name",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _statusColor(_statusString(payment.transactionStatus)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _statusIcon(_statusString(payment.transactionStatus)),
                                    size: 16,
                                    color: _statusTextColor(_statusString(payment.transactionStatus)),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _statusString(payment.transactionStatus).toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: _statusTextColor(_statusString(payment.transactionStatus)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Body: Transaction info
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        //    _infoRow(Icons.receipt_long, "Txn ID: ${payment.transactionId}"),
                            const SizedBox(height: 8),
                            _infoRow(Icons.calendar_today, _formatDate(payment.transactionDate)),
                            const Divider(height: 24),
                            _infoRow(
                              Icons.workspace_premium,
                              payment.transactionGoldGram > 0
                                  ? "${payment.transactionGoldGram.toStringAsFixed(2)} gm"
                                  : "Data not available",
                            ),
                            _infoRow(
                              Icons.currency_rupee,
                              payment.transactionAmount > 0
                                  ? "₹${payment.transactionAmount.toStringAsFixed(2)}"
                                  : "Data not available",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is CashPaymentError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // ===== Helper Row Widget =====
  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade700),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
