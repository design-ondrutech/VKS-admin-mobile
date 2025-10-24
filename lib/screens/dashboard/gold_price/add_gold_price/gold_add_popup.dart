import 'package:admin/data/models/gold_rate.dart';
import 'package:admin/screens/dashboard/gold_price/add_gold_price/add_gold_price.dart';
import 'package:admin/screens/dashboard/gold_price/add_gold_price/bloc/add_gld_bloc.dart';
import 'package:admin/blocs/gold_price/gold_bloc.dart';
import 'package:admin/blocs/gold_price/gold_event.dart';
import 'package:admin/screens/dashboard/gold_price/add_gold_price/bloc/add_gold_event.dart';
import 'package:admin/screens/dashboard/gold_price/add_gold_price/bloc/add_gold_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddGoldRateDialog extends StatefulWidget {
  final GoldPrice? existingPrice; //  now GoldPrice, not GoldPriceInput

  const AddGoldRateDialog({super.key, this.existingPrice, String? id});

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
  final List<String> silverCarats = ["99.9%(Pure Silver)"];
  final List<String> units = ["1g", "10g", "1Kg"];

  @override
  void initState() {
    super.initState();

    if (widget.existingPrice != null) {
      final price = widget.existingPrice!;
      selectedType = price.metal;
      selectedCarat = price.value;
      selectedUnit = units.contains(price.unit) ? price.unit : units.first;
      priceController.text = price.price.toString();
      dateController.text = price.date;
    } else {
      final now = DateTime.now();
      dateController.text =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    }
  }

  @override
@override
Widget build(BuildContext context) {
  return BlocListener<AddGoldPriceBloc, AddGoldPriceState>(
    listener: (context, state) {
      if (state is AddGoldPriceSuccess) {
        Navigator.pop(context); //  close popup
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existingPrice != null
                ? "Rate updated successfully"
                : "Rate added successfully"),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh gold price list
        context.read<GoldPriceBloc>().add(const FetchGoldPriceEvent());
      } else if (state is AddGoldPriceFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error),
            backgroundColor: Colors.red,
          ),
        );
      }
    },
    child: Dialog(
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.existingPrice != null
                      ? "Edit Jewelry Rate"
                      : "Add Jewelry Rate",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(thickness: 1, height: 20),
            _buildTextField("Date (YYYY-MM-DD)", dateController, readOnly: true),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown("Type", types, selectedType, (val) {
                    setState(() {
                      selectedType = val;
                      selectedCarat = null;
                    });
                  }),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDropdown("Unit", units, selectedUnit,
                      (val) => setState(() => selectedUnit = val)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDropdown(
              "Carat",
              selectedType == "Gold" ? goldCarats : silverCarats,
              selectedCarat,
              (val) => setState(() => selectedCarat = val),
            ),
            const SizedBox(height: 12),
            _buildTextField("Price", priceController),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: _onSavePressed,
                  child: Text(
                    widget.existingPrice != null ? "Update" : "Save",
                    style: const TextStyle(color: Colors.white),
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


  /// --- Save Button Logic ---
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

  final addBloc = context.read<AddGoldPriceBloc>();

  if (widget.existingPrice != null && widget.existingPrice!.priceId.isNotEmpty) {
    addBloc.add(UpdateGoldPrice(
      id: widget.existingPrice!.priceId,
      input: input,
    ));
  } else {
    addBloc.add(SubmitGoldPrice(input: input)); //  fixed here
  }
}



  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
  }) {
    bool isPriceField = label.toLowerCase().contains("price");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: isPriceField
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          inputFormatters: isPriceField
              ? [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ]
              : [],
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

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? value,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value:
              items.contains(value) ? value : (value != null ? items.first : null),
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
