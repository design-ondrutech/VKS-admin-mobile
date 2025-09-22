import 'package:admin/data/models/scheme.dart';
import 'package:admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/screens/dashboard/scheme/add_scheme/bloc/create_scheme_bloc.dart';
import 'package:admin/screens/dashboard/scheme/add_scheme/bloc/create_scheme_event.dart';
import 'package:admin/screens/dashboard/scheme/add_scheme/bloc/create_scheme_state.dart';
// Import your SchemeModel if not already imported

class AddSchemeDialog extends StatefulWidget {
  final Scheme? initialScheme;

  const AddSchemeDialog({Key? key, this.initialScheme}) : super(key: key);

  @override
  State<AddSchemeDialog> createState() => _AddSchemeDialogState();
}

class _AddSchemeDialogState extends State<AddSchemeDialog> {
  
  late final TextEditingController nameCtrl;
  late final TextEditingController durationCtrl;
  late final TextEditingController minAmtCtrl;
  late final TextEditingController maxAmtCtrl;
  late final TextEditingController incrementCtrl;
  late final TextEditingController thresholdCtrl;
  late final TextEditingController bonusCtrl;

  late String selectedType;
  late String selectedDurationType;

  String? nameError;
  String? durationError;
  String? minAmtError;

  @override
  void initState() {
    super.initState();
    final s = widget.initialScheme;
    
    nameCtrl = TextEditingController(text: s?.schemeName ?? "");
    durationCtrl = TextEditingController(text: s?.duration?.toString() ?? "");
    minAmtCtrl = TextEditingController(text: s?.minAmount?.toString() ?? "");
    maxAmtCtrl = TextEditingController(text: s?.maxAmount?.toString() ?? "");
    incrementCtrl = TextEditingController(
      text: s?.incrementAmount?.toString() ?? "",
    );
    thresholdCtrl = TextEditingController(
      text: s?.amountBenefits?.threshold?.toString() ?? "",
    );
    bonusCtrl = TextEditingController(
      text: s?.amountBenefits?.bonus?.toString() ?? "",
    );

    selectedType =
        (s?.schemeType != null && s!.schemeType.toLowerCase() == "flexible")
            ? "Flexible"
            : "Fixed";
    selectedDurationType =
        (s?.durationType != null && s!.durationType.toLowerCase() == "daily")
            ? "Daily"
            : "Monthly";
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.85),
        child: BlocConsumer<CreateSchemeBloc, CreateSchemeState>(
          listener: (context, state) {
            if (state.createdScheme != null) {
              Navigator.pop(context, true); // close dialog and notify parent
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "✅ Scheme Created: ${state.createdScheme!.schemeName}",
                  ),
                ),
              );
            }
            if (state.error != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("❌ ${state.error}")));
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.initialScheme == null
                          ? "Create New Scheme"
                          : "Edit Scheme",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    _buildTextField("Scheme Name", nameCtrl, errorText: nameError),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: _dropdownDecoration("Scheme Type"),
                      items: const [
                        DropdownMenuItem(value: "Fixed", child: Text("Fixed")),
                        DropdownMenuItem(
                          value: "Flexible",
                          child: Text("Flexible"),
                        ),
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
                      onChanged:
                          (val) => setState(() => selectedDurationType = val!),
                    ),
                    const SizedBox(height: 12),

                    _buildTextField(
                      "Duration ($selectedDurationType)",
                      durationCtrl,
                      isNumber: true,
                      errorText: durationError,
                    ),
                    const SizedBox(height: 12),

                    _buildTextField("Min Amount", minAmtCtrl, isNumber: true, errorText: minAmtError),
                    const SizedBox(height: 12),

                    _buildTextField("Max Amount", maxAmtCtrl, isNumber: true),
                    const SizedBox(height: 12),

                    _buildTextField(
                      "Increment Amount",
                      incrementCtrl,
                      isNumber: true,
                    ),
                    const SizedBox(height: 12),

                    _buildTextField("Threshold", thresholdCtrl, isNumber: true),
                    const SizedBox(height: 12),

                    _buildTextField("Bonus", bonusCtrl, isNumber: true),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Appcolors.buttoncolor,
                            minimumSize: const Size(120, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  setState(() {
                                    nameError = nameCtrl.text.isEmpty ? "Please enter scheme name" : null;
                                    durationError = durationCtrl.text.isEmpty ? "Please enter duration" : null;
                                    minAmtError = minAmtCtrl.text.isEmpty ? "Please enter minimum amount" : null;
                                  });

                                  if (nameError != null || durationError != null || minAmtError != null) {
                                    return;
                                  }

                                  final data = {

                                    "scheme_name": nameCtrl.text.trim(),
                                    "scheme_type": selectedType.toLowerCase(),
                                    "duration_type": selectedDurationType.toLowerCase(),
                                    "duration": int.tryParse(durationCtrl.text) ?? 0,
                                    "min_amount": double.tryParse(minAmtCtrl.text) ?? 0,
                                    "max_amount": double.tryParse(maxAmtCtrl.text) ?? 0,
                                    "increment_amount": double.tryParse(incrementCtrl.text) ?? 0,
                                    "threshold": double.tryParse(thresholdCtrl.text) ?? 0,
                                    "bonus": double.tryParse(bonusCtrl.text) ?? 0,
                                    "is_active": true,
                                  };

                                  if (widget.initialScheme == null) {
                                    context.read<CreateSchemeBloc>().add(SubmitCreateScheme(data));
                                  } else {
                                    context.read<CreateSchemeBloc>().add(
                                      SubmitUpdateScheme(widget.initialScheme!.schemeId, data),
                                    );
                                  }
                                },
                          child: state.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  widget.initialScheme == null ? "Save" : "Update",
                                  style: const TextStyle(
                                    color: Appcolors.white,
                                  ),
                                ),
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

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        errorText: errorText, // This shows the error inside the box
      ),
    );
  }
}
