import 'package:admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      bonusCtrl,
      benefitsCtrl; //  Properly typed

  late String selectedType, selectedDurationType;

  @override
  void initState() {
    super.initState();
    final s = widget.initialScheme;

    nameCtrl = TextEditingController(text: s?.schemeName ?? "");
    durationCtrl = TextEditingController(text: s?.duration.toString() ?? "");
    minCtrl = TextEditingController(
      text:
          (s?.minAmount != null && s!.minAmount % 1 == 0)
              ? s.minAmount.toInt().toString()
              : s?.minAmount.toString() ?? "",
    );
    maxCtrl = TextEditingController(
      text:
          (s?.maxAmount != null && s!.maxAmount! % 1 == 0)
              ? s.maxAmount!.toInt().toString()
              : s?.maxAmount?.toString() ?? "",
    );
    incrementCtrl = TextEditingController(
      text:
          (s?.incrementAmount != null && s!.incrementAmount! % 1 == 0)
              ? s.incrementAmount!.toInt().toString()
              : s?.incrementAmount?.toString() ?? "",
    );
    thresholdCtrl = TextEditingController(
      text:
          (s?.threshold != null && s!.threshold! % 1 == 0)
              ? s.threshold!.toInt().toString()
              : s?.threshold?.toString() ?? "",
    );
    bonusCtrl = TextEditingController(
      text:
          (s?.bonus != null && s!.bonus! % 1 == 0)
              ? s.bonus!.toInt().toString()
              : s?.bonus?.toString() ?? "",
    );

    selectedType = s?.schemeType ?? "fixed";
    selectedDurationType = s?.durationType ?? "Monthly";
    benefitsCtrl = TextEditingController(text: s?.benefits ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SchemesBloc, SchemesState>(
      listener: (context, state) {
        if (state is SchemeActionSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          Navigator.pop(context, true); // close the dialog
        } else if (state is SchemeError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error: ${state.error}")));
        }
      },
      builder: (context, state) {
        final isLoading = state is SchemeLoading;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.initialScheme == null
                          ? "Create Scheme"
                          : "Edit Scheme",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField("Name", nameCtrl),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      items: const [
                        DropdownMenuItem(value: "fixed", child: Text("Fixed")),
                        DropdownMenuItem(
                          value: "flexible",
                          child: Text("Flexible"),
                        ),
                      ],
                      onChanged: (val) => setState(() => selectedType = val!),
                      decoration: _dropdownDecoration("Scheme Type"),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedDurationType,
                      items: const [
                        DropdownMenuItem(
                          value: "Monthly",
                          child: Text("Monthly"),
                        ),
                        DropdownMenuItem(value: "Daily", child: Text("Daily")),
                      ],
                      onChanged:
                          (val) => setState(() => selectedDurationType = val!),
                      decoration: _dropdownDecoration("Duration Type"),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField("Benefits", benefitsCtrl),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: durationCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // only numbers
                      ],
                      decoration: InputDecoration(
                        labelText: "Duration",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //  Up arrow
                            InkWell(
                              onTap: () {
                                int current =
                                    int.tryParse(durationCtrl.text) ?? 0;
                                if (current < 20) {
                                  durationCtrl.text = (current + 1).toString();
                                }
                              },
                              child: const Icon(Icons.arrow_drop_up, size: 20),
                            ),
                            //  Down arrow
                            InkWell(
                              onTap: () {
                                int current =
                                    int.tryParse(durationCtrl.text) ?? 0;
                                if (current > 0) {
                                  durationCtrl.text = (current - 1).toString();
                                }
                              },
                              child: const Icon(
                                Icons.arrow_drop_down,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        counterText: "", // hide 0/20 counter
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          int val = int.tryParse(value) ?? 0;
                          if (val > 20) {
                            durationCtrl.text = '20';
                            durationCtrl.selection = TextSelection.fromPosition(
                              TextPosition(offset: durationCtrl.text.length),
                            );
                          }
                        }
                      },
                      validator:
                          (val) =>
                              val == null || val.trim().isEmpty
                                  ? "Duration is required"
                                  : null,
                    ),

                    const SizedBox(height: 12),
                    _buildTextField("Min Amount", minCtrl, isNumber: true),
                    const SizedBox(height: 12),
                    if (selectedType == "fixed") ...[
                      const SizedBox(height: 12),
                      _buildTextField("Max Amount", maxCtrl, isNumber: true),
                    ],
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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: isLoading ? null : _onSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Appcolors.buttoncolor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child:
                              isLoading
                                  ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    widget.initialScheme == null
                                        ? "Add Scheme"
                                        : "Update",
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
      },
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

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
      benefits: benefitsCtrl.text.trim(),
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
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters:
          isNumber
              ? [FilteringTextInputFormatter.digitsOnly] // only numbers
              : [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ], // only letters & spaces
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        counterText: "",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator:
          (val) =>
              val == null || val.trim().isEmpty ? "$label is required" : null,
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
