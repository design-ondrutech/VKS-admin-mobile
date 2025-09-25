import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:admin/blocs/schemes/schemes_bloc.dart';
import 'package:admin/blocs/schemes/schemes_event.dart';
import 'package:admin/blocs/schemes/schemes_state.dart';
import 'package:admin/data/models/scheme.dart';
import 'package:admin/utils/colors.dart';

class AddUpdateSchemeDialog extends StatefulWidget {
  final Scheme? initialScheme;

  const AddUpdateSchemeDialog({Key? key, this.initialScheme, required Null Function(dynamic savedScheme) onSchemeSaved}) : super(key: key);

  @override
  State<AddUpdateSchemeDialog> createState() => _AddUpdateSchemeDialogState();
}

class _AddUpdateSchemeDialogState extends State<AddUpdateSchemeDialog> {
  late TextEditingController nameCtrl, durationCtrl, minCtrl, maxCtrl, incrementCtrl, thresholdCtrl, bonusCtrl;
  late String selectedType, selectedDurationType;
  String? nameError, durationError, minError;

  @override
  void initState() {
    super.initState();
    final s = widget.initialScheme;

    nameCtrl = TextEditingController(text: s?.schemeName ?? "");
    durationCtrl = TextEditingController(text: s?.duration.toString() ?? "");
    minCtrl = TextEditingController(text: s?.minAmount.toString() ?? "");
    maxCtrl = TextEditingController(text: s?.maxAmount?.toString() ?? "");
    incrementCtrl = TextEditingController(text: s?.incrementAmount?.toString() ?? "");
    thresholdCtrl = TextEditingController(text: s?.threshold?.toString() ?? "");
    bonusCtrl = TextEditingController(text: s?.bonus?.toString() ?? "");

    selectedType = (s?.schemeType.toLowerCase() == "flexible") ? "Flexible" : "Fixed";
    selectedDurationType = (s?.durationType.toLowerCase() == "daily") ? "Daily" : "Monthly";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: BlocConsumer<SchemesBloc, SchemesState>(
        listener: (context, state) {
          if (state is SchemeOperationSuccess) {
            Navigator.pop(context); // Dialog auto close
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("✅ Scheme saved/updated: ${state.scheme.schemeName}")),
            );
          } else if (state is SchemeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("❌ ${state.message}")),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is SchemeLoading;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(widget.initialScheme == null ? "Create Scheme" : "Edit Scheme",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  _buildTextField("Name", nameCtrl, errorText: nameError),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: _dropdownDecoration("Scheme Type"),
                    items: const [
                      DropdownMenuItem(value: "Fixed", child: Text("Fixed")),
                      DropdownMenuItem(value: "Flexible", child: Text("Flexible")),
                    ],
                    onChanged: (val) => setState(() => selectedType = val!),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedDurationType,
                    decoration: _dropdownDecoration("Duration Type"),
                    items: const [
                      DropdownMenuItem(value: "Monthly", child: Text("Monthly")),
                      DropdownMenuItem(value: "Daily", child: Text("Daily")),
                    ],
                    onChanged: (val) => setState(() => selectedDurationType = val!),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField("Duration", durationCtrl, isNumber: true, errorText: durationError),
                  const SizedBox(height: 12),
                  _buildTextField("Min Amount", minCtrl, isNumber: true, errorText: minError),
                  const SizedBox(height: 12),
                  _buildTextField("Max Amount", maxCtrl, isNumber: true),
                  const SizedBox(height: 12),
                  _buildTextField("Increment Amount", incrementCtrl, isNumber: true),
                  const SizedBox(height: 12),
                  _buildTextField("Threshold", thresholdCtrl, isNumber: true),
                  const SizedBox(height: 12),
                  _buildTextField("Bonus", bonusCtrl, isNumber: true),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel", style: TextStyle(color: Colors.red)),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Appcolors.buttoncolor,
                          minimumSize: const Size(120, 45),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: isLoading ? null : _onSubmit,
                        child: isLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : Text(widget.initialScheme == null ? "Save" : "Update",
                                style: const TextStyle(color: Colors.white)),
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

  void _onSubmit() {
    setState(() {
      nameError = nameCtrl.text.trim().isEmpty ? "Enter name" : null;
      durationError = durationCtrl.text.trim().isEmpty ? "Enter duration" : null;
      minError = minCtrl.text.trim().isEmpty ? "Enter min amount" : null;
      
    });

    if (nameError != null || durationError != null || minError != null) return;

    final scheme = Scheme(
      schemeId: widget.initialScheme?.schemeId ?? "",
      schemeName: nameCtrl.text.trim(),
      schemeType: selectedType.toLowerCase(),
      durationType: selectedDurationType.toLowerCase(),
      duration: int.tryParse(durationCtrl.text) ?? 0,
      minAmount: double.tryParse(minCtrl.text) ?? 0,
      maxAmount: double.tryParse(maxCtrl.text),
      incrementAmount: double.tryParse(incrementCtrl.text),
      isActive: true,
      threshold: double.tryParse(thresholdCtrl.text),
      bonus: double.tryParse(bonusCtrl.text),
    );

    final bloc = context.read<SchemesBloc>();
    if (widget.initialScheme == null) {
      bloc.add(AddScheme(scheme));
      
    } else {
      bloc.add(UpdateScheme(scheme));
    }
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false, String? errorText}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        errorText: errorText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
