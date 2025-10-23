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
  late OnlinePaymentBloc bloc;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final client = GraphQLProvider.of(context).value;
      bloc = OnlinePaymentBloc(OnlinePaymentRepository(client));
      bloc.add(FetchOnlinePayments(page: 1, limit: 10));
      _initialized = true;
    }
  }

  // ---------- Helper Functions ----------
  String _safeNumber(dynamic value, {int digits = 4}) {
    if (value == null) return "0.0000";
    try {
      final num? parsed = value is num ? value : num.tryParse(value.toString());
      if (parsed == null || parsed.isNaN) return "0.0000";
      return parsed.toStringAsFixed(digits);
    } catch (_) {
      return "0.0000";
    }
  }

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
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Page Button ----------
  Widget _pageButton(String label, bool enabled, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: enabled ? onTap : null,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            enabled ? Appcolors.headerbackground : Colors.grey.shade300,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: enabled ? Colors.white : Colors.grey.shade600,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _loadPage(int page) {
    bloc.add(FetchOnlinePayments(page: page, limit: 10));
  }

  // ---------- Build ----------
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text(
            "Online Payments",
            style: TextStyle(color: Appcolors.white),
          ),
          centerTitle: true,
          backgroundColor: Appcolors.headerbackground,
          elevation: 0,
        ),
        body: BlocBuilder<OnlinePaymentBloc, OnlinePaymentState>(
          builder: (context, state) {
            if (state is OnlinePaymentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OnlinePaymentError) {
              return Center(
                child: Text(
                  "Error: ${state.message}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is OnlinePaymentLoaded) {
              final payments = state.response!.data;
              if (payments.isEmpty) {
                return const Center(child: Text("No Online Payments Found"));
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: payments.length,
                      itemBuilder: (context, index) {
                        final OnlinePayment payment = payments[index];
                        final txnStatus = _statusString(
                          payment.transactionStatus,
                        );

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header (Customer name + Status)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _statusColor(txnStatus),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            _statusIcon(txnStatus),
                                            size: 16,
                                            color: _statusTextColor(txnStatus),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            txnStatus.toUpperCase(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: _statusTextColor(
                                                txnStatus,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Card body
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _infoRow(
                                      Icons.calendar_today,
                                      _formatDate(payment.transactionDate),
                                    ),
                                    const Divider(height: 24),

                                    // Amount Left — Gram Right
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.currency_rupee,
                                                size: 18,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                _safeNumber(
                                                  payment.transactionAmount,
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.workspace_premium,
                                              size: 18,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${_safeNumber(payment.transactionGoldGram)} gm",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // ---------- Pagination Footer ----------
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: const Border(
                        top: BorderSide(color: Colors.black12, width: 0.6),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Page ${state.response!.currentPage} of ${state.response!.totalPages}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            _pageButton(
                              "Previous",
                              state.response!.currentPage > 1,
                              () => _loadPage(state.response!.currentPage - 1),
                            ),
                            const SizedBox(width: 8),
                            _pageButton(
                              "Next",
                              state.response!.currentPage <
                                  state.response!.totalPages,
                              () => _loadPage(state.response!.currentPage + 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
