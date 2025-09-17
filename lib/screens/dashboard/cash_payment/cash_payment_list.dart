import 'package:admin/blocs/cash_payment/cash_payment_bloc.dart';
import 'package:admin/blocs/cash_payment/cash_payment_event.dart';
import 'package:admin/blocs/cash_payment/cash_payment_state.dart';
import 'package:admin/data/models/cash_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CashPaymentScreen extends StatelessWidget {
  const CashPaymentScreen({super.key});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "paid":
        return Colors.green;
      case "unpaid":
        return Colors.orange;
      case "failed":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cash Payments"), centerTitle: true),
      body: BlocBuilder<CashPaymentBloc, CashPaymentState>(
        builder: (context, state) {
          if (state is CashPaymentInitial) {
            context.read<CashPaymentBloc>().add(FetchCashPayments(page: 1, limit: 10));
            return const Center(child: CircularProgressIndicator());
          } else if (state is CashPaymentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CashPaymentLoaded) {
            final payments = state.response.data;
            if (payments.isEmpty) {
              return const Center(child: Text("No Cash Payments Found"));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final CashPayment payment = payments[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(payment.customerName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    trailing: Chip(
                      label: Text(payment.transactionStatus,
                          style: const TextStyle(color: Colors.white)),
                      backgroundColor: _statusColor(payment.transactionStatus),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ID: ${payment.transactionId}",
                            style: const TextStyle(fontSize: 12)),
                        Text("Date: ${payment.transactionDate}",
                            style: const TextStyle(fontSize: 12)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Gold: ${payment.transactionGoldGram} gm"),
                            Text("₹${payment.transactionAmount.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange)),
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
