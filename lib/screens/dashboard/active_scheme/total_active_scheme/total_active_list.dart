import 'package:admin/blocs/today_active_scheme/today_active_bloc.dart';
import 'package:admin/blocs/today_active_scheme/today_active_event.dart';
import 'package:admin/blocs/today_active_scheme/today_active_state.dart';
import 'package:admin/data/models/total_active_scheme.dart';
import 'package:admin/screens/dashboard/active_scheme/total_active_scheme/total_active_detail_screen.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TodayActiveSchemesScreen extends StatelessWidget {
  const TodayActiveSchemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Total's Active Schemes",
          style: TextStyle(color: Appcolors.white),
        ),
        centerTitle: true,
        backgroundColor: Appcolors.headerbackground,
        elevation: 0,
      ),
      body: BlocBuilder<TodayActiveSchemeBloc, TodayActiveSchemeState>(
        builder: (context, state) {
          if (state is TodayActiveSchemeInitial) {
            context.read<TodayActiveSchemeBloc>().add(
              FetchTodayActiveSchemes(startDate: today),
            );
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodayActiveSchemeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodayActiveSchemeLoaded) {
            final schemes = state.response.data;
            if (schemes.isEmpty) {
              return const Center(
                child: Text(
                  "No Active Schemes Found",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: schemes.length,
              itemBuilder: (context, index) {
                final TodayActiveScheme scheme = schemes[index];

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
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  Header: Scheme Name + View All
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
                                scheme.schemeName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TodayActiveSchemeDetailScreen(scheme: scheme),
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

                      //  Body: Customer name with icon + status
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Customer Name + Status Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.person, size: 18, color: Colors.black87),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          scheme.customer.cName,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: scheme.status.toLowerCase() == "active"
                                        ? Colors.green.shade100
                                        : Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    scheme.status,
                                    style: TextStyle(
                                      color: scheme.status.toLowerCase() == "active"
                                          ? Colors.green.shade800
                                          : Colors.red.shade800,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),
                            _infoRow(Icons.phone, scheme.customer.cPhoneNumber),
                            _infoRow(Icons.email, scheme.customer.cEmail),
                            const Divider(height: 24),
                            _infoRow(Icons.category, "Type: ${scheme.schemeType}"),
                            _infoRow(Icons.work_outline, "Purpose: ${scheme.schemePurpose}"),
                            _infoRow(Icons.scale, "Total Gold: ${scheme.totalGoldWeight} gm"),
                            _infoRow(Icons.currency_rupee, "Total Amount: ₹${scheme.totalAmount}"),
                            if (scheme.paidAmount != null)
                              _infoRow(Icons.check_circle, "Paid: ₹${scheme.paidAmount}"),
                            if (scheme.pendingAmount != null)
                              _infoRow(Icons.pending, "Pending: ₹${scheme.pendingAmount}"),
                            _infoRow(Icons.calendar_today, "Start: ${formatDate(scheme.startDate)}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is TodayActiveSchemeError) {
            return Center(
              child: Text(
                "Error: ${state.message}",
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
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
}
