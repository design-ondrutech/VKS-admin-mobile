import 'package:admin/blocs/online_payment/online_payment_bloc.dart';
import 'package:admin/blocs/online_payment/online_payment_event.dart';
import 'package:admin/blocs/online_payment/online_payment_state.dart';
import 'package:admin/data/models/online_payment.dart';
import 'package:admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OnlinePaymentScreen extends StatelessWidget {
  const OnlinePaymentScreen({super.key});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "paid":
        return Colors.green.shade600;
      case "unpaid":
        return Colors.orange.shade600;
      case "failed":
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
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
        return Icons.help;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Online Payments",style: TextStyle(color: Appcolors.white),),
        centerTitle: true,
         backgroundColor: Appcolors.headerbackground,
        elevation: 0,
      ),
      body: BlocBuilder<OnlinePaymentBloc, OnlinePaymentState>(
        builder: (context, state) {
          if (state is OnlinePaymentInitial) {
            context.read<OnlinePaymentBloc>().add(
                  FetchOnlinePayments(page: 1, limit: 10),
                );
            return const Center(child: CircularProgressIndicator());
          } else if (state is OnlinePaymentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OnlinePaymentLoaded) {
            final payments = state.response.data;
            if (payments.isEmpty) {
              return const Center(
                child: Text(
                  "No Online Payments Found",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final OnlinePayment payment = payments[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Top Row - Customer Name + Status Chip
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                payment.customerName.isNotEmpty
                                    ? payment.customerName
                                    : "No Name",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Chip(
                              avatar: Icon(
                                _statusIcon(payment.transactionStatus),
                                color: Colors.white,
                                size: 18,
                              ),
                              label: Text(
                                payment.transactionStatus.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              backgroundColor:
                                  _statusColor(payment.transactionStatus),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 0),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        /// Transaction ID + Date
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Txn ID: ${payment.transactionId}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                _formatDate(payment.transactionDate),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20, thickness: 1),

                        /// Bottom Row - Gold + Amount
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  const Icon(Icons.workspace_premium,
                                      color: Colors.amber, size: 20),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      "${payment.transactionGoldGram.toStringAsFixed(2)} gm",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "₹${payment.transactionAmount.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.orange.shade700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is OnlinePaymentError) {
            return Center(
              child: Text(
                "Error: ${state.message}",
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w500),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
