import 'package:admin/data/graphql_config.dart';
import 'package:admin/data/repo/auth_repository.dart';
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  // -------- Header Row --------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Schemes",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<SchemesBloc>().add(OpenAddSchemePopup());
                        },
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

                  // ---- Table Header ----
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 10,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: const [
                        _HeaderCell("ID", flex: 1),
                        _HeaderCell("SCHEME", flex: 2),
                        _HeaderCell("DURATION", flex: 2),
                        _HeaderCell("MIN AMOUNT", flex: 2),
                        _HeaderCell("MAX AMOUNT", flex: 2),
                      ],
                    ),
                  ),

                  // ---- API Data Rows ----
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
                            final scheme =
                                entry.value; 
                            return _buildRow(
                              index.toString(),
                              scheme.schemeName,
                              "${scheme.duration} months",
                              scheme.minAmount.toString(),
                              scheme.maxAmount.toString(),
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

  // ---------------- POPUP FORM ----------------
  void _showAddSchemePopup(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final schemeNameController = TextEditingController();
    final durationController = TextEditingController();
    final minAmountController = TextEditingController();
    final maxAmountController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return BlocBuilder<SchemesBloc, SchemesState>(
          builder: (context, state) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              insetPadding: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.add_chart,
                            color: Colors.deepPurple,
                            size: 28,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Create New Scheme",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: schemeNameController,
                              decoration: InputDecoration(
                                labelText: "Scheme Name",
                                prefixIcon: const Icon(Icons.card_giftcard),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator:
                                  (value) =>
                                      value!.isEmpty
                                          ? "Enter scheme name"
                                          : null,
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: durationController,
                              decoration: InputDecoration(
                                labelText: "Duration (Months)",
                                prefixIcon: const Icon(Icons.timer),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: minAmountController,
                              decoration: InputDecoration(
                                labelText: "Minimum Amount",
                                prefixIcon: const Icon(Icons.money),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: maxAmountController,
                              decoration: InputDecoration(
                                labelText: "Maximum Amount",
                                prefixIcon: const Icon(Icons.attach_money),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              context.read<SchemesBloc>().add(
                                CloseAddSchemePopup(),
                              );
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close, color: Colors.red),
                            label: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Appcolors.buttoncolor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<SchemesBloc>().add(
                                  SubmitScheme(
                                    schemeName: schemeNameController.text,
                                    duration: durationController.text,
                                    minAmount: minAmountController.text,
                                    maxAmount: maxAmountController.text,
                                  ),
                                );
                              }
                            },
                            icon:
                                state.isSubmitting
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Icon(
                                      Icons.save,
                                      color: Colors.white,
                                    ),
                            label: const Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      context.read<SchemesBloc>().add(CloseAddSchemePopup());
    });
  }
}

// ---------------- Table Header + Rows ----------------
class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  const _HeaderCell(this.text, {required this.flex});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

Widget _buildRow(
  String id,
  String scheme,
  String duration,
  String minAmt,
  String maxAmt,
) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
    ),
    child: Row(
      children: [
        _TableCell(id, flex: 1),
        _TableCell(scheme, flex: 2),
        _TableCell(duration, flex: 2),
        _TableCell(minAmt, flex: 2),
        _TableCell(maxAmt, flex: 2),
      ],
    ),
  );
}

class _TableCell extends StatelessWidget {
  final String text;
  final int flex;
  final Color? textColor;
  final FontWeight? fontWeight;
  const _TableCell(
    this.text, {
    required this.flex,
    this.textColor,
    this.fontWeight,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: textColor ?? Colors.black,
          fontWeight: fontWeight ?? FontWeight.normal,
        ),
      ),
    );
  }
}
