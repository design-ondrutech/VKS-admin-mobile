import 'package:admin/blocs/active_scheme/active_scheme_bloc.dart';
import 'package:admin/blocs/active_scheme/active_scheme_event.dart';
import 'package:admin/blocs/active_scheme/active_scheme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalActiveSchemesScreen extends StatelessWidget {
  const TotalActiveSchemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Total Active Schemes"),
        centerTitle: true,
      ),
      body: BlocBuilder<TotalActiveSchemesBloc, TotalActiveSchemesState>(
        builder: (context, state) {
          if (state is TotalActiveSchemesInitial) {
            context.read<TotalActiveSchemesBloc>().add(FetchTotalActiveSchemes());
            return const Center(child: CircularProgressIndicator());
          } else if (state is TotalActiveSchemesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TotalActiveSchemesLoaded) {
            final schemes = state.response.data;
            if (schemes.isEmpty) {
              return const Center(
                child: Text(
                  "No Active Schemes Found",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: schemes.length,
              itemBuilder: (context, index) {
                final scheme = schemes[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Scheme Name
                        Text(
                          scheme.schemeName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Customer Info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              scheme.customer.cName,
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              scheme.customer.cPhoneNumber,
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          scheme.customer.cEmail,
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(height: 12),

                        // Scheme Type & Status Chips
                        Wrap(
                          spacing: 8,
                          children: [
                            Chip(
                              label: Text(scheme.schemeType),
                              backgroundColor: Colors.blue.shade100,
                              labelStyle: const TextStyle(color: Colors.blue),
                            ),
                            Chip(
                              label: Text(scheme.status),
                              backgroundColor: scheme.status.toLowerCase() == 'active'
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              labelStyle: TextStyle(
                                color: scheme.status.toLowerCase() == 'active'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Gold and Amount Info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Gold: ${scheme.totalGoldWeight} gm",
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              "₹${scheme.totalAmount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Start Date
                        Text(
                          "Start Date: ${scheme.startDate}",
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is TotalActiveSchemesError) {
            return Center(
              child: Text(
                "Error: ${state.message}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
