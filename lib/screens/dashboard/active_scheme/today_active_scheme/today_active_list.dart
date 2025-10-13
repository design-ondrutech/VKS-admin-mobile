import 'package:admin/blocs/today_active_scheme/today_active_bloc.dart';
import 'package:admin/blocs/today_active_scheme/today_active_event.dart';
import 'package:admin/blocs/today_active_scheme/today_active_state.dart';
import 'package:admin/screens/dashboard/active_scheme/today_active_scheme/today_active_detail_screen.dart';
import 'package:admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TodayActiveSchemesScreen extends StatefulWidget {
  const TodayActiveSchemesScreen({super.key});

  @override
  State<TodayActiveSchemesScreen> createState() =>
      _TodayActiveSchemesScreenState();
}

class _TodayActiveSchemesScreenState extends State<TodayActiveSchemesScreen> {
  int page = 1;
  final int limit = 10;

  @override
  void initState() {
    super.initState();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    context.read<TodayActiveSchemeBloc>().add(
      FetchTodayActiveSchemes(startDate: today, page: page, limit: limit),
    );
  }

  void _loadPage(int newPage) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    setState(() => page = newPage);
    context.read<TodayActiveSchemeBloc>().add(
      FetchTodayActiveSchemes(startDate: today, page: page, limit: limit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Today Active Schemes",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Appcolors.headerbackground,
      ),
      body: BlocBuilder<TodayActiveSchemeBloc, TodayActiveSchemeState>(
        builder: (context, state) {
          if (state is TodayActiveSchemeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodayActiveSchemeError) {
            return Center(
              child: Text(
                "Error: ${state.message}",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
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

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
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
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  TodayActiveSchemeDetailScreen(
                                                    scheme: scheme,
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
                                          const Icon(
                                            Icons.person,
                                            size: 18,
                                            color: Colors.black87,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            scheme.customer.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              scheme.status.toLowerCase() ==
                                                      "active"
                                                  ? Colors.green.shade100
                                                  : Colors.red.shade100,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          scheme.status,
                                          style: TextStyle(
                                            color:
                                                scheme.status.toLowerCase() ==
                                                        "active"
                                                    ? Colors.green.shade800
                                                    : Colors.red.shade800,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  _infoRow(
                                    Icons.phone,
                                    scheme.customer.phoneNumber,
                                  ),
                                //  _infoRow(Icons.email, scheme.customer.email),

                                  const Divider(height: 24),
                                  _infoRow(
                                    Icons.category,
                                    "Type: ${scheme.schemeType}",
                                  ),
                                  _infoRow(
                                    Icons.work_outline,
                                    "Purpose: ${scheme.schemePurpose}",
                                  ),
                                  _infoRow(
                                    Icons.scale,
                                    "Total Gold: ${scheme.totalGoldWeight} gm",
                                  ),
                                  _infoRow(
                                    Icons.currency_rupee,
                                    "Total Amount: ₹${scheme.totalAmount}",
                                  ),
                                    _infoRow(
                                      Icons.check_circle,
                                      "Paid: ₹${scheme.paidAmount}",
                                    ),
                                    // _infoRow(
                                    //   Icons.pending,
                                    //   "Pending: ₹${scheme.pendingAmount}",
                                    // ),
                                  _infoRow(
                                    Icons.calendar_today,
                                    "Start: ${formatDate(scheme.startDate)}",
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

                // Material Pagination Footer
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
                        "Page ${state.currentPage} of ${state.totalPages}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          _pageButton(
                            "Previous",
                            state.currentPage > 1,
                            () => _loadPage(state.currentPage - 1),
                          ),
                          const SizedBox(width: 8),
                          _pageButton(
                            "Next",
                            state.currentPage < state.totalPages,
                            () => _loadPage(state.currentPage + 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
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

  Widget _pageButton(String label, bool enabled, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: enabled ? onTap : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? Colors.blue : Colors.grey.shade300,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: enabled ? Colors.white : Colors.black54,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "-";
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(date));
    } catch (_) {
      return date;
    }
  }
}
