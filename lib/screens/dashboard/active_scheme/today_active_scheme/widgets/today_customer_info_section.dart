import 'package:flutter/material.dart';
import 'package:admin/data/models/customer.dart';

class TodayCustomerInfoSection extends StatefulWidget {
  final Customer customer;
  const TodayCustomerInfoSection({super.key, required this.customer});

  @override
  State<TodayCustomerInfoSection> createState() =>
      _TodayCustomerInfoSectionState();
}

class _TodayCustomerInfoSectionState extends State<TodayCustomerInfoSection> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final customer = widget.customer;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue.shade50,
                  child: Text(
                    customer.name.isNotEmpty
                        ? customer.name[0].toUpperCase()
                        : "?",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name.isNotEmpty
                            ? customer.name
                            : "Customer Info",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Customer Profile",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: AnimatedRotation(
                    turns: isExpanded ? 0.0 : 0.5,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.black54,
                      size: 28,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ],
            ),

            AnimatedCrossFade(
              crossFadeState: isExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
              firstChild: _buildCustomerDetails(customer),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerDetails(Customer customer) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final emailCard =
              _infoCard(Icons.email, "Email", customer.email, Colors.blue);
          final phoneCard =
              _infoCard(Icons.phone, "Phone", customer.phoneNumber, Colors.green);

          return isWide
              ? Row(
                  children: [
                    Expanded(child: emailCard),
                    const SizedBox(width: 16),
                    Expanded(child: phoneCard),
                  ],
                )
              : Column(
                  children: [
                    emailCard,
                    const SizedBox(height: 12),
                    phoneCard,
                  ],
                );
        },
      ),
    );
  }

  Widget _infoCard(
      IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.black54)),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : "N/A",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
