import 'package:admin/blocs/cash_payment/cash_payment_bloc.dart';
import 'package:admin/blocs/cash_payment/cash_payment_event.dart';
import 'package:admin/blocs/cash_payment/cash_payment_state.dart';
import 'package:admin/data/models/cash_payment.dart';
import 'package:admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CashPaymentScreen extends StatelessWidget {
  const CashPaymentScreen({super.key});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "paid":
        return Colors.green.shade600;
      case "unpaid":
        return Colors.orange.shade600;
      case "failed":
        return Colors.red.shade600;
      default:
        return Colors.grey.shade400;
    }
  }

  Icon _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case "paid":
        return const Icon(Icons.check_circle, color: Colors.white, size: 16);
      case "unpaid":
        return const Icon(
          Icons.hourglass_bottom,
          color: Colors.white,
          size: 16,
        );
      case "failed":
        return const Icon(Icons.error, color: Colors.white, size: 16);
      default:
        return const Icon(Icons.help, color: Colors.white, size: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cash Payments",style: TextStyle(color: Appcolors.white),),
        centerTitle: true,
         backgroundColor: Appcolors.headerbackground,
      ),
      body: BlocBuilder<CashPaymentBloc, CashPaymentState>(
        builder: (context, state) {
          if (state is CashPaymentInitial) {
            context.read<CashPaymentBloc>().add(
              FetchCashPayments(page: 1, limit: 10),
            );
            return const Center(child: CircularProgressIndicator());
          } else if (state is CashPaymentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CashPaymentLoaded) {
            final payments = state.response.data;
            if (payments.isEmpty) {
              return const Center(child: Text("No Cash Payments Found"));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final CashPayment payment = payments[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Row: Customer & Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                payment.customerName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _statusColor(payment.transactionStatus),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  _statusIcon(payment.transactionStatus),
                                  const SizedBox(width: 6),
                                  Text(
                                    payment.transactionStatus.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Middle Row: ID & Date
                        // Middle Row: ID & Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "ID: ${payment.transactionId}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                overflow:
                                    TextOverflow.ellipsis, // prevents overflow
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ), // spacing between ID & Date
                            Expanded(
                              child: Text(
                                "Date: ${payment.transactionDate}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                textAlign:
                                    TextAlign.end, // align date to the right
                                overflow:
                                    TextOverflow.ellipsis, // prevents overflow
                              ),
                            ),
                          ],
                        ),

                        const Divider(height: 16, thickness: 1),
                        // Bottom Row: Gold & Amount
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Gold: ${payment.transactionGoldGram} gm",
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              "₹${payment.transactionAmount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                                fontSize: 16,
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
          } else if (state is CashPaymentError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
