import 'package:admin/screens/dashboard/scheme/add_scheme/create_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/blocs/schemes/schemes_bloc.dart';
import 'package:admin/blocs/schemes/schemes_event.dart';
import 'package:admin/blocs/schemes/schemes_state.dart';
import 'package:admin/data/models/scheme.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:admin/data/graphql_config.dart';
import 'package:admin/utils/colors.dart';

class SchemesTab extends StatelessWidget {
  const SchemesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SchemesBloc(SchemeRepository(getGraphQLClient()))..add(FetchSchemes()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7FC),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<SchemesBloc, SchemesState>(
                  builder: (context, state) => _buildStateUI(context, state),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Schemes", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Appcolors.buttoncolor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text("Add Scheme", style: TextStyle(color: Colors.white)),
          onPressed: () => _showAddEditDialog(context),
        ),
      ],
    );
  }

  void _showAddEditDialog(BuildContext context, [Scheme? scheme]) {
    showDialog(
      context: context,
      builder: (_) => AddUpdateSchemeDialog(
        initialScheme: scheme,
        onSchemeSaved: (savedScheme) {
          final bloc = context.read<SchemesBloc>();
          if (scheme == null) {
            bloc.add(AddScheme(savedScheme));
          } else {
            bloc.add(UpdateScheme(savedScheme));
          }
        },
      ),
    );
  }

  Widget _buildStateUI(BuildContext context, SchemesState state) {
    if (state is SchemeLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is SchemeError) {
      return Center(child: Text("Error: ${state.message}", style: const TextStyle(color: Colors.red)));
    } else if (state is SchemeLoaded) {
      final schemes = state.schemes;
      if (schemes.isEmpty) return const Center(child: Text("No schemes found"));

      return ListView.builder(
        itemCount: schemes.length,
        itemBuilder: (context, index) {
          final scheme = schemes[index];
          return _buildSchemeCard(context, scheme);
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }

 Widget _buildSchemeCard(BuildContext context, Scheme scheme) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: scheme name + action icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  scheme.schemeName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A235A),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showAddEditDialog(context, scheme),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteDialog(context, scheme),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Type chip
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              scheme.schemeType,
              style: const TextStyle(fontSize: 12, color: Color(0xFF4A235A), fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 10),

          // Details row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _detailItem("Duration", "${scheme.duration} ${scheme.durationType}"),
              _detailItem("Min", "₹${scheme.minAmount}"),
              if (scheme.maxAmount != null) _detailItem("Max", "₹${scheme.maxAmount}"),
            ],
          ),
          if (scheme.incrementAmount != null || scheme.threshold != null || scheme.bonus != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Benefits",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF4A235A)),
                  ),
                  const SizedBox(height: 4),
                  if (scheme.incrementAmount != null) Text("Increment: ₹${scheme.incrementAmount}"),
                  if (scheme.threshold != null) Text("Threshold: ₹${scheme.threshold}"),
                  if (scheme.bonus != null) Text("Bonus: ₹${scheme.bonus}"),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}

// Helper widget for small detail item
Widget _detailItem(String title, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      const SizedBox(height: 2),
      Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
    ],
  );
}


  void _showDeleteDialog(BuildContext context, Scheme scheme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Scheme"),
        content: Text("Are you sure you want to delete '${scheme.schemeName}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                // TODO: call delete API
                Navigator.pop(ctx);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
