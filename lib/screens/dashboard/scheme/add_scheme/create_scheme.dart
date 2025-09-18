import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/screens/dashboard/scheme/add_scheme/bloc/create_scheme_bloc.dart';
import 'package:admin/screens/dashboard/scheme/add_scheme/bloc/create_scheme_event.dart';
import 'package:admin/screens/dashboard/scheme/add_scheme/bloc/create_scheme_state.dart';

class AddSchemeDialog extends StatefulWidget {
  const AddSchemeDialog({super.key});

  @override
  State<AddSchemeDialog> createState() => _AddSchemeDialogState();
}

class _AddSchemeDialogState extends State<AddSchemeDialog> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController durationCtrl = TextEditingController();
  final TextEditingController minAmtCtrl = TextEditingController();
  final TextEditingController maxAmtCtrl = TextEditingController();
  final TextEditingController incrementCtrl = TextEditingController();
  final TextEditingController thresholdCtrl = TextEditingController();
  final TextEditingController bonusCtrl = TextEditingController();

  String selectedType = "Fixed";
  String selectedPayingType = "Monthly";
  String selectedDurationType = "Month";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: BlocConsumer<CreateSchemeBloc, CreateSchemeState>(
        listener: (context, state) {
          if (state.createdScheme != null) {
            Navigator.pop(context, true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      "✅ Scheme Created: ${state.createdScheme!.schemeName}")),
            );
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("❌ ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Create New Scheme",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Row 1: Scheme Name | Type | Paying Type
                  Row(
                    children: [
                      Expanded(
                          child: _buildTextField(
                              "Scheme Name", nameCtrl)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedType,
                          decoration: const InputDecoration(
                            labelText: "Type",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: "Fixed", child: Text("Fixed")),
                            DropdownMenuItem(
                                value: "Flexible", child: Text("Flexible")),
                          ],
                          onChanged: (val) {
                            setState(() {
                              selectedType = val!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedPayingType,
                          decoration: const InputDecoration(
                            labelText: "Paying Type",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: "Monthly", child: Text("Monthly")),
                            DropdownMenuItem(
                                value: "Daily", child: Text("Daily")),
                          ],
                          onChanged: (val) {
                            setState(() {
                              selectedPayingType = val!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Row 2: Duration | Min Amount | Max Amount
                  Row(
                    children: [
                      Expanded(
                          child: _buildTextField(
                              "Duration (${selectedDurationType})",
                              durationCtrl,
                              keyboardType: TextInputType.number)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _buildTextField("Min Amount", minAmtCtrl,
                              keyboardType: TextInputType.number)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _buildTextField("Max Amount", maxAmtCtrl,
                              keyboardType: TextInputType.number)),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Row 3: Increment Amount | Threshold | Bonus
                  Row(
                    children: [
                      Expanded(
                          child: _buildTextField("Increment Amount",
                              incrementCtrl,
                              keyboardType: TextInputType.number)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _buildTextField("Threshold", thresholdCtrl,
                              keyboardType: TextInputType.number)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _buildTextField("Bonus", bonusCtrl,
                              keyboardType: TextInputType.number)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel",
                            style: TextStyle(color: Colors.red)),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: state.isLoading
                            ? null
                            : () {
                                final data = {
                                  "scheme_name": nameCtrl.text,
                                  "scheme_type": selectedType.toLowerCase(),
                                  "duration_type":
                                      selectedDurationType.toLowerCase(),
                                  "duration":
                                      int.tryParse(durationCtrl.text) ?? 0,
                                  "min_amount":
                                      double.tryParse(minAmtCtrl.text) ?? 0,
                                  "max_amount":
                                      double.tryParse(maxAmtCtrl.text) ?? 0,
                                  "increment_amount":
                                      double.tryParse(incrementCtrl.text) ?? 0,
                                  "threshold":
                                      double.tryParse(thresholdCtrl.text) ?? 0,
                                  "bonus":
                                      double.tryParse(bonusCtrl.text) ?? 0,
                                  "paying_type":
                                      selectedPayingType.toLowerCase(),
                                  "is_active": true,
                                };
                                context
                                    .read<CreateSchemeBloc>()
                                    .add(SubmitCreateScheme(data));
                              },
                        child: state.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Text("Save"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
