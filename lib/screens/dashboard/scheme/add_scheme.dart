// lib/screens/schemes/add_scheme_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/blocs/schemes/schemes_bloc.dart';
import 'package:admin/blocs/schemes/schemes_event.dart';
import 'package:admin/blocs/schemes/schemes_state.dart';
import 'package:admin/utils/colors.dart';

class AddSchemeDialog extends StatelessWidget {
  AddSchemeDialog({super.key});

  final _formKey = GlobalKey<FormState>();

  final _schemeNameController = TextEditingController();
  final _schemeTypeController = TextEditingController();
  final _payingTypeController = TextEditingController();
  final _durationController = TextEditingController();
  final _minAmountController = TextEditingController();
  final _maxAmountController = TextEditingController();
  final _incrementAmountController = TextEditingController();
  final _thresholdController = TextEditingController();
  final _bonusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SchemesBloc, SchemesState>(
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add New Scheme",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    /// Row 1 - Scheme Name, Type, Paying Type
                    Row(
                      children: [
                        Expanded(child: _buildTextField(controller: _schemeNameController, label: "Scheme Name")),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField(controller: _schemeTypeController, label: "Type")),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField(controller: _payingTypeController, label: "Paying Type")),
                      ],
                    ),
                    const SizedBox(height: 15),

                    /// Row 2 - Duration, Min Amount, Max Amount
                    Row(
                      children: [
                        Expanded(child: _buildTextField(controller: _durationController, label: "Duration (Month)", keyboardType: TextInputType.number)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField(controller: _minAmountController, label: "Min Amount", keyboardType: TextInputType.number)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField(controller: _maxAmountController, label: "Max Amount", keyboardType: TextInputType.number)),
                      ],
                    ),
                    const SizedBox(height: 15),

                    /// Row 3 - Increment, Threshold, Bonus
                    Row(
                      children: [
                        Expanded(child: _buildTextField(controller: _incrementAmountController, label: "Increment Amount", keyboardType: TextInputType.number)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField(controller: _thresholdController, label: "Threshold", keyboardType: TextInputType.number)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField(controller: _bonusController, label: "Bonus", keyboardType: TextInputType.number)),
                      ],
                    ),
                    const SizedBox(height: 25),

                    /// Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            context.read<SchemesBloc>().add(CloseAddSchemePopup());
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel", style: TextStyle(color: Colors.red)),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Appcolors.buttoncolor,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<SchemesBloc>().add(
                                    SubmitScheme(
                                      schemeName: _schemeNameController.text,
                                      schemeType: _schemeTypeController.text,
                                      durationType: "month",
                                      duration: _durationController.text,
                                      minAmount: _minAmountController.text,
                                    ),
                                  );
                            }
                          },
                          child: state.isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text("Save", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      keyboardType: keyboardType,
      validator: (value) => (value == null || value.isEmpty) ? "Required" : null,
    );
  }
}
