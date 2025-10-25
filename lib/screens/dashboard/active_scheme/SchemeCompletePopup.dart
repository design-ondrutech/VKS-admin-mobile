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
  bool _isMaxLimit = false;

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
  double currentValue = double.tryParse(_controller.text) ?? 0.0;
  double newValue = currentValue + 0.0001;

  if (newValue > widget.remainingGold) {
    newValue = widget.remainingGold;
    _isMaxLimit = false; 
  } else {
    _isMaxLimit = false;
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _controller.text = newValue.toStringAsFixed(4);
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  });

  setState(() {});
}

  void _decrease() {
    double currentValue = double.tryParse(_controller.text) ?? 0.0;
    double newValue = currentValue - 0.0001;
    if (newValue <= 0) newValue = 0.0;
    _isMaxLimit = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.text = newValue.toStringAsFixed(4);
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    });
    setState(() {});
  }
  String get currentStatus {
    if (widget.alreadyDelivered == 0) {
      return "Not Delivered";
    } else if (widget.alreadyDelivered < widget.totalGoldRequired) {
      return "Partially Delivered";
    } else {
      return "Fully Delivered";
    }
  }

  String get previewStatus {
    if (_inputValue == 0 && widget.alreadyDelivered == 0) {
      return "Not Delivered";
    } else if (_inputValue < widget.alreadyDelivered ) {
      return "Partially Delivered ";
    } else if (_inputValue == widget.remainingGold) {
      return "Fully Delivered ";
    } else {
      return "Partially Delivered";
    }
  }

  @override
  Widget build(BuildContext context) {
    final potentialNewTotal = widget.alreadyDelivered + _inputValue;
    final remainingAfterUpdate = widget.totalGoldRequired - potentialNewTotal;

    final bool isInputValid =
        _inputValue > 0 && _inputValue <= widget.remainingGold;
    final bool isFullDelivery =
        (_inputValue >= widget.remainingGold - 0.00005); 

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  Header
              Row(
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    color: Colors.green,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Scheme Fully Paid!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                "This scheme is fully paid. Please confirm if gold delivery is completed.",
                style: TextStyle(
                  fontSize: 13.5,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              //  Info Boxes
             // _infoCard("Total Gold Required", widget.totalGoldRequired),
              _infoCard("Already Delivered (DB)", widget.alreadyDelivered),
           //   _infoCard("Remaining Gold", widget.remainingGold),
              const SizedBox(height: 18),

              //  Input field + Stepper
              Text(
                "Enter Additional Delivery (grams)",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "0.0000",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (val) {
                          double entered = double.tryParse(val) ?? 0.0;

                          if (entered > widget.remainingGold) {
                            entered = widget.remainingGold;
                            _isMaxLimit = true;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _controller.text = entered.toStringAsFixed(4);
                              _controller
                                  .selection = TextSelection.fromPosition(
                                TextPosition(offset: _controller.text.length),
                              );
                            });
                          } else {
                            _isMaxLimit = false;
                          }

                          if (entered < 0) {
                            entered = 0.0;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _controller.text = entered.toStringAsFixed(4);
                              _controller
                                  .selection = TextSelection.fromPosition(
                                TextPosition(offset: _controller.text.length),
                              );
                            });
                          }

                          setState(() {});
                        },
                      ),
                    ),
                    Column(
                      children: [
                        _stepButton(Icons.arrow_drop_up, _increase),
                        _stepButton(Icons.arrow_drop_down, _decrease),
                      ],
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
              if (_isMaxLimit)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    "⚠️ Maximum limit reached",
                    style: TextStyle(
                      color: Colors.red.shade600,
                      fontSize: 12.5,
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    "Maximum allowed: ${remainingAfterUpdate < 0 ? '0.0000' : remainingAfterUpdate.toStringAsFixed(4)} g",
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),

              const SizedBox(height: 18),

              // Calculation
              Row(
                children: [
                  _calcBox(
                    "New Total",
                    "${potentialNewTotal.toStringAsFixed(4)} g",
                  ),
                  _calcBox(
                    "Remaining After Update",
                    remainingAfterUpdate < 0
                        ? "0.0000 g"
                        : "${remainingAfterUpdate.toStringAsFixed(4)} g",
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey.shade300),

              //  Status
              _statusRow("Current Status (DB)", currentStatus),
              _statusRow("Preview Status", previewStatus),
              const SizedBox(height: 16),

              //  Confirm Checkbox (only when full)
              if (isFullDelivery)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isConfirmed,
                        activeColor: Colors.green,
                        onChanged: (val) {
                          setState(() => _isConfirmed = val ?? false);
                        },
                      ),
                      Expanded(
                        child: Text(
                          "Confirm Gold Delivered (Total: ${widget.totalGoldRequired.toStringAsFixed(4)} g)",
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 22),

              //  Buttons
              Row(
                children: [
                  Expanded(
                    child: _button(
                      label: "Cancel",
                      bgColor: Colors.grey.shade200,
                      textColor: Colors.black87,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          isInputValid
                              ? () {
                                Navigator.pop(
                                  context,
                                  _inputValue,
                                ); //  Return entered gold gram
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isInputValid ? Colors.amber : Colors.grey.shade300,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        "Save ${_inputValue.toStringAsFixed(4)} g",
                        style: TextStyle(
                          color: isInputValid ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _button(
                      label: "Mark Fully Delivered",
                      bgColor:
                          isFullDelivery && _isConfirmed
                              ? Colors.green.shade600
                              : Colors.grey.shade300,
                      textColor:
                          isFullDelivery && _isConfirmed
                              ? Colors.white
                              : Colors.grey.shade500,
                      onTap:
                          isFullDelivery && _isConfirmed
                              ? () {
                                Navigator.pop(
                                  context,
                                  widget.totalGoldRequired,
                                );
                              }
                              : null,
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

  // --- Helper Widgets ---
  Widget _infoCard(String title, double value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          Text(
            "${value.toStringAsFixed(4)} g",
            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _stepButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 20, color: Colors.black54),
      ),
    );
  }

  Widget _calcBox(String label, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusRow(String title, String value) {
    Color color;
    if (value.contains("Fully")) {
      color = Colors.green;
    } else if (value.contains("Partial")) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _button({
    required String label,
    required Color bgColor,
    required Color textColor,
    required VoidCallback? onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
          fontSize: 13.5,
        ),
      ),
    );
  }
}
