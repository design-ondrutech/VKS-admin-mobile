import 'package:admin/blocs/online_payment/online_payment_bloc.dart';
import 'package:admin/blocs/online_payment/online_payment_event.dart';
import 'package:admin/blocs/online_payment/online_payment_state.dart';
import 'package:admin/data/models/online_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnlinePaymentScreen extends StatelessWidget {
  const OnlinePaymentScreen({super.key});

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
      appBar: AppBar(title: const Text("Online Payments"), centerTitle: true),
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
              return const Center(child: Text("No Online Payments Found"));
            }
            ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final OnlinePayment payment = payments[index];

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
                    title: Text(
                      payment.customerName.isNotEmpty
                          ? payment.customerName
                          : "No Name",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Chip(
                      label: Text(
                        payment.transactionStatus,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: _statusColor(payment.transactionStatus),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ID: ${payment.transactionId}",
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Date: ${payment.transactionDate}",
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Gold: ${payment.transactionGoldGram.toStringAsFixed(2)} gm",
                            ),
                            Text(
                              "₹${payment.transactionAmount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
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
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
