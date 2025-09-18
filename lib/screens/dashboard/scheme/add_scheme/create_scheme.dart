import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.85),
        child: BlocConsumer<CreateSchemeBloc, CreateSchemeState>(
          listener: (context, state) {
            if (state.createdScheme != null) {
              Navigator.pop(context, true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("✅ Scheme Created: ${state.createdScheme!.schemeName}"),
                ),
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
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Create New Scheme",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Row 1
                    Row(
                      children: [
                        Expanded(child: _buildTextField("Scheme Name", nameCtrl)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedType,
                            decoration: _dropdownDecoration("Type"),
                            items: const [
                              DropdownMenuItem(value: "Fixed", child: Text("Fixed")),
                              DropdownMenuItem(value: "Flexible", child: Text("Flexible")),
                            ],
                            onChanged: (val) => setState(() => selectedType = val!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedPayingType,
                            decoration: _dropdownDecoration("Paying Type"),
                            items: const [
                              DropdownMenuItem(value: "Monthly", child: Text("Monthly")),
                              DropdownMenuItem(value: "Daily", child: Text("Daily")),
                            ],
                            onChanged: (val) => setState(() => selectedPayingType = val!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Row 2
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField("Duration ($selectedDurationType)", durationCtrl,
                              isNumber: true),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField("Min Amount", minAmtCtrl, isNumber: true)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField("Max Amount", maxAmtCtrl, isNumber: true)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Row 3
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField("Increment Amount", incrementCtrl, isNumber: true),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField("Threshold", thresholdCtrl, isNumber: true)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField("Bonus", bonusCtrl, isNumber: true)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel", style: TextStyle(color: Colors.red)),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(100, 45),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  final data = {
                                    "scheme_name": nameCtrl.text,
                                    "scheme_type": selectedType.toLowerCase(),
                                    "duration_type": selectedDurationType.toLowerCase(),
                                    "duration": int.tryParse(durationCtrl.text) ?? 0,
                                    "min_amount": double.tryParse(minAmtCtrl.text) ?? 0,
                                    "max_amount": double.tryParse(maxAmtCtrl.text) ?? 0,
                                    "increment_amount":
                                        double.tryParse(incrementCtrl.text) ?? 0,
                                    "threshold": double.tryParse(thresholdCtrl.text) ?? 0,
                                    "bonus": double.tryParse(bonusCtrl.text) ?? 0,
                                    "paying_type": selectedPayingType.toLowerCase(),
                                    "is_active": true,
                                  };
                                  context.read<CreateSchemeBloc>().add(SubmitCreateScheme(data));
                                },
                          child: state.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
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
      ),
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
