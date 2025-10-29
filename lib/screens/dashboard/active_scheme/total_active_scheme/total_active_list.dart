import 'package:admin/blocs/total_active_scheme/total_active_bloc.dart';
import 'package:admin/blocs/total_active_scheme/total_active_event.dart';
import 'package:admin/blocs/total_active_scheme/total_active_state.dart';
import 'package:admin/screens/dashboard/active_scheme/total_active_scheme/Total_active_detail_screen.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TotalActiveSchemesScreen extends StatelessWidget {
  const TotalActiveSchemesScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Total Active Schemes",
          style: TextStyle(color: Appcolors.white),
        ),
        centerTitle: true,
        backgroundColor: Appcolors.headerbackground,
        elevation: 0,
        
      ),
      body: BlocBuilder<TotalActiveBloc, TotalActiveState>(
        builder: (context, state) {
          // Initial Fetch
          if (state is TotalActiveInitial) {
            context.read<TotalActiveBloc>().add(
                  FetchTotalActiveSchemes(page: 1, limit: 10),
                );
            return const Center(child: CircularProgressIndicator());
          }

          // Loading
          else if (state is TotalActiveLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Loaded
          else if (state is TotalActiveLoaded) {
            final schemes = state.response.data;
            if (schemes.isEmpty) {
              return const Center(
                child: Text(
                  "No active schemes found.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      // Pull-down refresh
                      context.read<TotalActiveBloc>().add(
                            FetchTotalActiveSchemes(page: 1, limit: 10),
                          );
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: schemes.length,
                      itemBuilder: (context, index) {
                        final scheme = schemes[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
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
                                        scheme.schemeName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade900,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                BlocProvider.value(
                                              value:
                                                  BlocProvider.of<TotalActiveBloc>(
                                                      context),
                                              child:
                                                  TotalActiveSchemeDetailScreen(
                                                scheme: scheme,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "View All",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
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
                                        Expanded(
                                          child: Row(
                                            children: [
                                              const Icon(Icons.person,
                                                  size: 18,
                                                  color: Colors.black87),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  scheme.customer.name,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: scheme.status
                                                        .toLowerCase() ==
                                                    "active"
                                                ? Colors.yellow.shade100
                                                : scheme.status
                                                            .toLowerCase() ==
                                                        "completed"
                                                    ? Colors.green.shade100
                                                    : Colors.red.shade100,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            scheme.status,
                                            style: TextStyle(
                                              color: scheme.status
                                                          .toLowerCase() ==
                                                      "active"
                                                  ? Colors.orange.shade800
                                                  : scheme.status
                                                              .toLowerCase() ==
                                                          "completed"
                                                      ? Colors.green.shade800
                                                      : Colors.red.shade800,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    _infoRow(Icons.phone,
                                        scheme.customer.phoneNumber),
                                    const Divider(height: 24),
                                    _infoRow(Icons.category,
                                        "Type: ${scheme.schemeType}"),
                                    _infoRow(Icons.work_outline,
                                        "Purpose: ${scheme.schemePurpose}"),
                                    _infoRow(Icons.scale,
                                        "Gold: ${formatGram(scheme.totalGoldWeight)} gm"),
                                    if (scheme.schemeType.toLowerCase() ==
                                      "fixed") ...[
                                    _infoRow(
                                      Icons.currency_rupee,
                                      "Amount: ₹${formatAmount(scheme.totalAmount)}",
                                    ),
                                  ],
                                    _infoRow(
                                      Icons.check_circle,
                                      "Paid: ₹${formatAmount(scheme.paidAmount)}",
                                    ),
                                    _infoRow(
                                      Icons.calendar_today,
                                      "Start Date: ${formatDate(scheme.startDate)}",
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
                ),

                // Pagination
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.black12, width: 0.6),
                    ),
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
                          ElevatedButton(
                            onPressed: state.response.currentPage > 1
                                ? () {
                                    context.read<TotalActiveBloc>().add(
                                          FetchTotalActiveSchemes(
                                            page:
                                                state.response.currentPage - 1,
                                            limit: state.response.limit,
                                          ),
                                        );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  state.response.currentPage > 1
                                      ? Appcolors.headerbackground
                                      : Colors.grey.shade300,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              "Previous",
                              style: TextStyle(
                                color: state.response.currentPage > 1
                                    ? Colors.white
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: state.response.currentPage <
                                    state.response.totalPages
                                ? () {
                                    context.read<TotalActiveBloc>().add(
                                          FetchTotalActiveSchemes(
                                            page:
                                                state.response.currentPage + 1,
                                            limit: state.response.limit,
                                          ),
                                        );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  state.response.currentPage <
                                          state.response.totalPages
                                      ? Appcolors.headerbackground
                                      : Colors.grey.shade300,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              "Next",
                              style: TextStyle(
                                color: state.response.currentPage <
                                        state.response.totalPages
                                    ? Colors.white
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // Empty State
          else if (state is TotalActiveEmpty) {
            return const Center(
              child: Text(
                "No active schemes found.",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            );
          }

          // Error
          else if (state is TotalActiveError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String? text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text ?? "N/A",
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
