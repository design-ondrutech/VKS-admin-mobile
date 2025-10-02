import 'package:admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/blocs/schemes/schemes_bloc.dart';
import 'package:admin/blocs/schemes/schemes_event.dart';
import 'package:admin/blocs/schemes/schemes_state.dart';
import 'package:admin/data/models/scheme.dart';

class AddUpdateSchemeDialog extends StatefulWidget {
  final Scheme? initialScheme;
  const AddUpdateSchemeDialog({Key? key, this.initialScheme}) : super(key: key);

  @override
  State<AddUpdateSchemeDialog> createState() => _AddUpdateSchemeDialogState();
}

class _AddUpdateSchemeDialogState extends State<AddUpdateSchemeDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameCtrl,
      durationCtrl,
      minCtrl,
      maxCtrl,
      incrementCtrl,
      thresholdCtrl,
      bonusCtrl;
  late String selectedType, selectedDurationType;

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
    selectedType = s?.schemeType ?? "fixed";
    selectedDurationType = s?.durationType ?? "Monthly";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey, // 👈 wrap with Form
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.initialScheme == null ? "Create Scheme" : "Edit Scheme",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildTextField("Name", nameCtrl,),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  items: const [
                    DropdownMenuItem(value: "fixed", child: Text("Fixed")),
                    DropdownMenuItem(value: "flexible", child: Text("Flexible")),
                  ],
                  onChanged: (val) => setState(() => selectedType = val!),
                  decoration: _dropdownDecoration("Scheme Type"),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedDurationType,
                  items: const [
                    DropdownMenuItem(value: "Monthly", child: Text("Monthly")),
                    DropdownMenuItem(value: "Daily", child: Text("Daily")),
                  ],
                  onChanged: (val) => setState(() => selectedDurationType = val!),
                  decoration: _dropdownDecoration("Duration Type"),
                ),
                const SizedBox(height: 12),
                _buildTextField("Duration", durationCtrl, isNumber: true,  ),
                const SizedBox(height: 12),
                _buildTextField("Min Amount", minCtrl, isNumber: true, ),
                const SizedBox(height: 12),
                _buildTextField("Max Amount", maxCtrl, isNumber: true),
                const SizedBox(height: 12),
                _buildTextField("Increment Amount", incrementCtrl, isNumber: true),
                const SizedBox(height: 12),
                _buildTextField("Threshold", thresholdCtrl, isNumber: true),
                const SizedBox(height: 12),
                _buildTextField("Bonus", bonusCtrl, isNumber: true),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel", style: TextStyle(color: Colors.red)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.buttoncolor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        widget.initialScheme == null ? "Add Scheme" : "Update",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
  if (!_formKey.currentState!.validate()) {
    return; // stop if any field invalid
  }

  final scheme = Scheme(
    schemeId: widget.initialScheme?.schemeId ?? "",
    schemeName: nameCtrl.text.trim(),
    schemeType: selectedType,
    durationType: selectedDurationType,
    duration: int.tryParse(durationCtrl.text) ?? 0,
    minAmount: double.tryParse(minCtrl.text) ?? 0,
    maxAmount: double.tryParse(maxCtrl.text) ?? 0,
    incrementAmount: double.tryParse(incrementCtrl.text) ?? 0,
    isActive: true,
    threshold: double.tryParse(thresholdCtrl.text) ?? 0,
    bonus: double.tryParse(bonusCtrl.text) ?? 0,
  );

  final bloc = context.read<SchemesBloc>();
  if (widget.initialScheme == null) {
    bloc.add(AddScheme(scheme));
  } else {
    bloc.add(UpdateScheme(scheme));
  }
}


  Widget _buildTextField(
  String label,
  TextEditingController controller, {
  bool isNumber = false,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
    validator: (val) {
      if (val == null || val.trim().isEmpty) {
        return "$label is required"; //  red error inside box
      }
      return null;
    },
  );
}


  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
