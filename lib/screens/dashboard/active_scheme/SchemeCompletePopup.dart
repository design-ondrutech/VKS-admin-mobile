import 'package:flutter/material.dart';

class SchemeCompletePopup extends StatefulWidget {
  final double totalGoldRequired;
  final double alreadyDelivered;
  final double remainingGold;

  const SchemeCompletePopup({
    super.key,
    required this.totalGoldRequired,
    required this.alreadyDelivered,
    required this.remainingGold,
  });

  @override
  State<SchemeCompletePopup> createState() => _SchemeCompletePopupState();
}

class _SchemeCompletePopupState extends State<SchemeCompletePopup> {
  final TextEditingController _controller = TextEditingController();
  bool _isConfirmed = false;

  double get _inputValue {
    final text = _controller.text.trim();
    if (text.isEmpty) return 0.0;
    return double.tryParse(text) ?? 0.0;
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  void _increase() {
    double newValue = _inputValue + 0.01;
    if (newValue > widget.remainingGold) {
      newValue = widget.remainingGold;
    }
    setState(() {
      _controller.text = newValue.toStringAsFixed(4);
    });
  }

  void _decrease() {
    double newValue = _inputValue - 0.01;
    if (newValue < 0) newValue = 0.0;
    setState(() {
      _controller.text = newValue.toStringAsFixed(4);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Real-time calculation
    final potentialNewTotal = widget.alreadyDelivered + _inputValue;
    final remainingAfterUpdate = widget.totalGoldRequired - potentialNewTotal;

    final bool isInputValid =
        _inputValue > 0 && _inputValue <= widget.remainingGold;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Header
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 28),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "All Payments Completed!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                "This scheme has been successfully paid in full.\nPlease confirm if Gold has been delivered.",
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 20),

              // ✅ Already Delivered
              _infoRow("Already Delivered (DB):",
                  "${widget.alreadyDelivered.toStringAsFixed(4)} g"),
              const SizedBox(height: 10),

              // ✅ Input Field + Stepper
              Text(
                "Additional Delivered (g)",
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: "Enter additional delivered weight",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                      onChanged: (val) {
                        double entered = double.tryParse(val) ?? 0.0;
                        if (entered > widget.remainingGold) {
                          entered = widget.remainingGold;
                          _controller.text = entered.toStringAsFixed(4);
                          _controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: _controller.text.length),
                          );
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  Column(
                    children: [
                      InkWell(
                        onTap: _increase,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.arrow_drop_up, size: 24),
                        ),
                      ),
                      InkWell(
                        onTap: _decrease,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.arrow_drop_down, size: 24),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Maximum allowed: ${widget.remainingGold.toStringAsFixed(4)} g",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // ✅ Live Calculations
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _smallBox("Potential New Total",
                      "${potentialNewTotal.toStringAsFixed(4)} g"),
                  _smallBox(
                    "Remaining After Update",
                    remainingAfterUpdate < 0
                        ? "0.0000 g"
                        : "${remainingAfterUpdate.toStringAsFixed(4)} g",
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _infoRow("Total Gold Required:",
                  "${widget.totalGoldRequired.toStringAsFixed(4)} g"),
              _infoRow("Current Status (DB):", "Not Delivered"),
              _infoRow("Preview Status:",
                  _isConfirmed ? "Delivered" : "Not Delivered"),
              const SizedBox(height: 16),

              // ✅ Confirm Checkbox (only when input > 0)
              if (isInputValid)
                Row(
                  children: [
                    Checkbox(
                      value: _isConfirmed,
                      onChanged: (val) {
                        setState(() => _isConfirmed = val ?? false);
                      },
                    ),
                    Expanded(
                      child: Text(
                        "Confirm Gold Delivered (Total: ${widget.totalGoldRequired.toStringAsFixed(4)} g)",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 12),

              // ✅ Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _bottomButton(
                    label: "Cancel",
                    color: Colors.grey[300]!,
                    textColor: Colors.black87,
                    onPressed: () => Navigator.pop(context),
                  ),
                  _bottomButton(
                    label: "Save ${_inputValue.toStringAsFixed(4)} g",
                    color: isInputValid ? Colors.amber[600]! : Colors.grey[300]!,
                    textColor: isInputValid ? Colors.black : Colors.grey[500]!,
                    onPressed: isInputValid
                        ? () {
                            Navigator.pop(context, {
                              "addedGold": _inputValue,
                              "confirmed": _isConfirmed,
                            });
                          }
                        : null,
                  ),
                  _bottomButton(
                    label: "Mark Fully Delivered",
                    color: isInputValid && _isConfirmed
                        ? Colors.green[600]!
                        : Colors.grey[300]!,
                    textColor: isInputValid && _isConfirmed
                        ? Colors.white
                        : Colors.grey[500]!,
                    onPressed: isInputValid && _isConfirmed
                        ? () {
                            Navigator.pop(context, {
                              "fullyDelivered": true,
                              "total": widget.totalGoldRequired,
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Small UI Helper Widgets ---
  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          Text(value,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _smallBox(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Text(title,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 4),
            Text(value,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _bottomButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback? onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: onPressed,
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontSize: 13)),
        ),
      ),
    );
  }
}
