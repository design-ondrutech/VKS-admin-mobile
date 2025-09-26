import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/blocs/online_payment/online_payment_bloc.dart';
import 'package:admin/blocs/online_payment/online_payment_event.dart';
import 'package:admin/blocs/online_payment/online_payment_state.dart';
import 'package:admin/data/models/online_payment.dart';
import 'package:admin/utils/colors.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

class OnlinePaymentScreen extends StatefulWidget {
  const OnlinePaymentScreen({super.key});

  @override
  State<OnlinePaymentScreen> createState() => _OnlinePaymentScreenState();
}

class _OnlinePaymentScreenState extends State<OnlinePaymentScreen> {
  late ScrollController _scrollController;
  late OnlinePaymentBloc bloc;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final client = GraphQLProvider.of(context).value;
      bloc = OnlinePaymentBloc(OnlinePaymentRepository(client));
      bloc.add(FetchOnlinePayments(page: 1, limit: 10));

      _scrollController = ScrollController();
      _scrollController.addListener(_scrollListener);

      _initialized = true;
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = bloc.state;
      if (state is OnlinePaymentLoaded) {
        if (state.response!.currentPage < state.response!.totalPages) {
          bloc.add(FetchOnlinePayments(
              page: state.response!.currentPage + 1, limit: 10));
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    bloc.close();
    super.dispose();
  }

  // ---------- Status & Helper Methods ----------
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "paid":
        return Colors.green.shade100;
      case "unpaid":
        return Colors.orange.shade100;
      case "failed":
        return Colors.red.shade100;
      default:
        return Colors.grey.shade300;
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
        return Icons.help;
    }
  }

  String _statusString(dynamic status) {
    if (status == 2 || status == '2') return "paid";
    if (status == 1 || status == '1') return "unpaid";
    if (status == 3 || status == '3') return "failed";
    return "unknown";
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return "N/A";
    try {
      final parsed = DateTime.tryParse(date);
      if (parsed != null) {
        return DateFormat("dd MMM yyyy, hh:mm a").format(parsed);
      }
    } catch (_) {}
    return date;
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  // ---------- Build Method ----------
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text("Online Payments",
              style: TextStyle(color: Appcolors.white)),
          centerTitle: true,
          backgroundColor: Appcolors.headerbackground,
          elevation: 0,
        ),
        body: BlocBuilder<OnlinePaymentBloc, OnlinePaymentState>(
          builder: (context, state) {
            if (state is OnlinePaymentLoading && bloc.allPayments.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OnlinePaymentError) {
              return Center(
                  child: Text("Error: ${state.message}",
                      style: const TextStyle(color: Colors.red)));
            } else if (state is OnlinePaymentLoaded ||
                state is OnlinePaymentLoading) {
              final payments = bloc.allPayments;
              if (payments.isEmpty) {
                return const Center(child: Text("No Online Payments Found"));
              }

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: payments.length + 1,
                itemBuilder: (context, index) {
                  if (index < payments.length) {
                    final OnlinePayment payment = payments[index];
                    final txnStatus = _statusString(payment.transactionStatus);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)),
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
                                            color: Colors.blue.shade900),
                                        overflow: TextOverflow.ellipsis)),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _statusColor(txnStatus),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(_statusIcon(txnStatus),
                                          size: 16,
                                          color: _statusTextColor(txnStatus)),
                                      const SizedBox(width: 4),
                                      Text(txnStatus.toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color:
                                                  _statusTextColor(txnStatus))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // _infoRow(Icons.receipt,
                                //     "Txn ID: ${payment.transactionId}"),
                                _infoRow(Icons.calendar_today,
                                    _formatDate(payment.transactionDate)),
                                const Divider(height: 24),
                                _infoRow(Icons.workspace_premium,
                                    "${payment.transactionGoldGram.toStringAsFixed(2)} gm"),
                                _infoRow(Icons.currency_rupee,
                                    "₹${payment.transactionAmount.toStringAsFixed(2)}"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return bloc.isFetching
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox.shrink();
                  }
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
