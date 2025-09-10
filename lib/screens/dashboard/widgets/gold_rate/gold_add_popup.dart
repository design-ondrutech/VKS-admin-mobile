import 'package:admin/blocs/gold/add_gld_bloc.dart';
import 'package:admin/blocs/gold/add_gold_event.dart';
import 'package:admin/data/models/add_gold_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final List<String> silverCarats = ["99.9% (Pure Silver)"];
  final List<String> units = ["1g", "10g", "1Kg"];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    dateController.text =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Title + Close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Add Jewelry Rate",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(thickness: 1, height: 20),

            /// Date
            _buildTextField("Date (YYYY-MM-DD)", dateController, readOnly: true),

            const SizedBox(height: 12),

            /// Type + Unit
            Row(
              children: [
                Expanded(
                  child: _buildDropdown("Type", types, selectedType,
                      (val) => setState(() => selectedType = val)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDropdown("Unit", units, selectedUnit,
                      (val) => setState(() => selectedUnit = val)),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Carat
            _buildDropdown(
              "Carat",
              selectedType == "Gold" ? goldCarats : silverCarats,
              selectedCarat,
              (val) => setState(() => selectedCarat = val),
            ),

            const SizedBox(height: 12),

            /// Price
            _buildTextField("Price", priceController),

            const SizedBox(height: 20),

            /// Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel",
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: _onSavePressed,
                  child: const Text("Save",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// --- Save Button Action ---
  void _onSavePressed() {
    if (selectedType == null ||
        selectedCarat == null ||
        selectedUnit == null ||
        priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    final input = GoldPriceInput(
      date: dateController.text, 
      metal: selectedType!,
      value: selectedCarat!,
      unit: selectedUnit!,
      price: double.tryParse(priceController.text) ?? 0,
    );

    context.read<AddGoldPriceBloc>().add(SubmitGoldPrice(input));

    Navigator.pop(context);
  }

  /// --- Common Widgets ---
  Widget _buildTextField(String label, TextEditingController controller,
      {bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isDense: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
