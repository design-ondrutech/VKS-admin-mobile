import 'package:flutter/material.dart';

class AddGoldRateDialog extends StatefulWidget {
  const AddGoldRateDialog({super.key});

  @override
  State<AddGoldRateDialog> createState() => _AddGoldRateDialogState();
}

class _AddGoldRateDialogState extends State<AddGoldRateDialog> {
  String? selectedType;
  String? selectedCarat;
  String? selectedUnit;
  TextEditingController priceController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final List<String> types = ["Gold", "Silver"];
  final List<String> goldCarats = ["24K", "22K", "18K"];
  final List<String> units = ["Gram", "Kg"];

  @override
  void initState() {
    super.initState();
    dateController.text = _getTodayDate();
  }

  String _getTodayDate() {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: const [
                  SizedBox(width: 10),
                  Text(
                    "Add Gold/Silver Rate",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(height: 25, thickness: 1),

              // Date + Type Row
              Row(
                children: [
                  Expanded(child: _buildTextField("Date", dateController, readOnly: true, icon: Icons.date_range)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildDropdown(
                      "Type",
                      types,
                      selectedType,
                      (val) {
                        setState(() {
                          selectedType = val;
                          selectedCarat = null;
                        });
                      },
                      icon: Icons.category,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Carat + Unit Row
              Row(
                children: [
                  Expanded(
                    child: selectedType == "Gold"
                        ? _buildDropdown(
                            "Carat",
                            goldCarats,
                            selectedCarat,
                            (val) => setState(() => selectedCarat = val),
                            icon: Icons.star,
                          )
                        : _buildDisabledField("Select Type First", icon: Icons.block),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildDropdown(
                      "Unit",
                      units,
                      selectedUnit,
                      (val) => setState(() => selectedUnit = val),
                      icon: Icons.scale,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Price field
              _buildTextField("Price", priceController, icon: Icons.currency_rupee),

              const SizedBox(height: 25),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                      label: const Text("Cancel", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Save logic here
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text("Save", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool readOnly = false, IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon) : null,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? value,
    ValueChanged<String?> onChanged, {
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon) : null,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDisabledField(String hint, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Carat", style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon) : null,
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
