import 'package:admin/blocs/cash_payment/cash_payment_bloc.dart';
import 'package:admin/blocs/cash_payment/cash_payment_event.dart';
import 'package:admin/blocs/cash_payment/cash_payment_state.dart';
import 'package:admin/data/models/cash_payment.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CashPaymentScreen extends StatefulWidget {
  const CashPaymentScreen({super.key});

  @override
  State<CashPaymentScreen> createState() => _CashPaymentScreenState();
}

class _CashPaymentScreenState extends State<CashPaymentScreen> {
  late CashPaymentBloc bloc;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final client = GraphQLProvider.of(context).value;
      final repository = CashPaymentRepository(client);
      bloc = CashPaymentBloc(repository);
      bloc.add(FetchCashPayments(page: 1, limit: 10));
      _initialized = true;
    }
  }



  String _statusString(dynamic status) {
    if (status == 2 || status == '2') return "paid";
    if (status == 1 || status == '1') return "unpaid";
    if (status == 3 || status == '3') return "failed";
    return "unknown";
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
    bloc.add(FetchCashPayments(page: page, limit: 10));
  }

  // ---------- Build ----------
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text("Cash Payments",
              style: TextStyle(color: Appcolors.white)),
          centerTitle: true,
          backgroundColor: Appcolors.headerbackground,
          elevation: 0,
        ),
        body: BlocBuilder<CashPaymentBloc, CashPaymentState>(
          builder: (context, state) {
            if (state is CashPaymentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CashPaymentError) {
              return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.red)),
              );
            } else if (state is CashPaymentLoaded) {
              final payments = state.response.data;
              if (payments.isEmpty) {
                return const Center(child: Text("No Cash Payments Found"));
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: payments.length,
                      itemBuilder: (context, index) {
                        final CashPayment payment = payments[index];
                        final txnStatus =
                            _statusString(payment.transactionStatus);

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
                              // Header
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)),
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
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _statusColor(txnStatus),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(_statusIcon(txnStatus),
                                              size: 16,
                                              color:
                                                  _statusTextColor(txnStatus)),
                                          const SizedBox(width: 4),
                                          Text(
                                            txnStatus.toUpperCase(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color:
                                                  _statusTextColor(txnStatus),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Body
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.currency_rupee,
                                                size: 18, color: Colors.grey),
                                            const SizedBox(width: 4),
                                             Text(
                                                formatAmount(
                                                  payment.transactionAmount,
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.workspace_premium,
                                                size: 18, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${formatGram(payment.transactionGoldGram)} gm",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 20),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today,
                                            size: 18, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(formatDate(
                                            payment.transactionDate)),
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

                  // Pagination Footer
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          top: BorderSide(color: Colors.black12, width: 0.6)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Page ${state.response.currentPage} of ${state.response.totalPages}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            _pageButton(
                              "Previous",
                              state.response.currentPage > 1,
                              () => _loadPage(state.response.currentPage - 1),
                            ),
                            const SizedBox(width: 8),
                            _pageButton(
                              "Next",
                              state.response.currentPage <
                                  state.response.totalPages,
                              () => _loadPage(state.response.currentPage + 1),
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
