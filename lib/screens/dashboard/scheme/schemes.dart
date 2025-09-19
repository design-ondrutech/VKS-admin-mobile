import 'package:admin/data/graphql_config.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:admin/screens/dashboard/scheme/add_scheme/bloc/create_scheme_bloc.dart';
import 'package:admin/screens/dashboard/scheme/add_scheme/create_scheme.dart';
import 'package:admin/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/blocs/schemes/schemes_bloc.dart';
import 'package:admin/blocs/schemes/schemes_event.dart';
import 'package:admin/blocs/schemes/schemes_state.dart';
import 'package:admin/utils/colors.dart';

class SchemesTab extends StatelessWidget {
  const SchemesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              SchemesBloc(SchemeRepository(getGraphQLClient()))
                ..add(FetchSchemes()),
      child: BlocConsumer<SchemesBloc, SchemesState>(
        listener: (context, state) {
          if (state.isPopupOpen) {
            _showAddSchemePopup(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F7FC),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -------- Header Row --------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Schemes", style: ThemeText.titleLarge),
                      ElevatedButton(
                        onPressed:
                            () => context.read<SchemesBloc>().add(
                              OpenAddSchemePopup(),
                            ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Appcolors.buttoncolor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Add Scheme",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if (state.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.error != null && state.error!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Error: ${state.error}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  else if (state.schemes.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No schemes found"),
                    )
                  else
                    Column(
                      children:
                          state.schemes.asMap().entries.map((entry) {
                            final index = entry.key + 1;
                            final scheme = entry.value;
                            return _buildSchemeCard(
                              id: index.toString(),
                              schemeName: scheme.schemeName,
                              schemeType: scheme.schemeType,
                              duration:
                                  "${scheme.duration} ${scheme.durationType}",
                              minAmount: scheme.minAmount.toString(),
                              maxAmount: scheme.maxAmount?.toString(),
                              incrementAmount:
                                  scheme.incrementAmount?.toString(),
                              threshold:
                                  scheme.amountBenefits?.threshold?.toString(),
                              bonus: scheme.amountBenefits?.bonus?.toString(),

                              onEdit:
                                  () {
                                showDialog(
                                  context: context,
                                  builder: (context) => BlocProvider.value(
                                    value: context.read<CreateSchemeBloc>(),
                                    child: AddSchemeDialog(
                                      initialScheme: scheme, // Pass the scheme object here
                                    ),
                                  ),
                                ).then((refresh) {
                                  if (refresh == true) {
                                    context.read<SchemesBloc>().add(FetchAllSchemes());
                                  }
                                });
                              },
                              onDelete: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (ctx) => AlertDialog(
                                        title: const Text("Delete Scheme"),
                                        content: Text(
                                          "Are you sure you want to delete '${scheme.schemeName}'?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx),
                                            child: const Text("Cancel"),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            onPressed: () {
                                              // TODO: Add Delete API
                                              Navigator.pop(ctx);
                                            },
                                            child: const Text(
                                              "Delete",
                                              style: TextStyle(
                                                color: Appcolors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );
                              },
                            );
                          }).toList(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddSchemePopup(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => BlocProvider.value(
            value: context.read<CreateSchemeBloc>(), // use existing bloc
            child: const AddSchemeDialog(),
          ),
    ).then((refresh) {
      if (refresh == true) {
        context.read<SchemesBloc>().add(
          FetchAllSchemes(),
        ); // refresh scheme list
        //  Reload scheme list from API
        // context.read<GetAllSchemesBloc>().add(FetchAllSchemes());
      }
    });
  }
}

/// ------------- SCHEME CARD WIDGET -------------
Widget _buildSchemeCard({
  required String id,
  required String schemeName,
  required String schemeType,
  required String duration,
  required String minAmount,
  String? threshold,
  String? bonus,
  String? maxAmount,
  String? incrementAmount,
  VoidCallback? onEdit,
  VoidCallback? onDelete,
}) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.symmetric(vertical: 8),
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row: Name + Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schemeName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A235A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Scheme Type: $schemeType",
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
          const Divider(),

          /// Duration, Min Amount, Max Amount, Increment + Amount Benefits (Threshold + Bonus)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: All details in a column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer, size: 16, color: Colors.deepPurple),
                        const SizedBox(width: 6),
                        Text(duration, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.currency_rupee, size: 16, color: Colors.green),
                        const SizedBox(width: 6),
                        Text(
                          "Min Amount: ₹$minAmount",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    if (maxAmount != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.arrow_upward, size: 16, color: Colors.orange),
                          const SizedBox(width: 6),
                          Text(
                            "Max Amount: ₹$maxAmount",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                    if (incrementAmount != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.trending_up,
                            size: 16,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Increment: ₹$incrementAmount",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Right side: Amount Benefits container
              if (threshold != null || bonus != null)
                Container(
                  margin: const EdgeInsets.only(left: 12, top: 0),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Amount Benefits",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      if (threshold != null)
                        Text(
                          "Threshold: ₹$threshold",
                          style: const TextStyle(fontSize: 13),
                        ),
                      if (bonus != null)
                        Text(
                          "Bonus: ₹$bonus",
                          style: const TextStyle(fontSize: 13),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}
