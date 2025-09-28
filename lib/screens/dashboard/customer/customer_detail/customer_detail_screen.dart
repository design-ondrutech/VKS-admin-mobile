import 'package:admin/screens/dashboard/customer/customer_detail/model/customer_details_model.dart';
import 'package:admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class CustomerDetailScreen extends StatelessWidget {
  final CustomerDetails details;
  const CustomerDetailScreen({super.key, required this.details});

  String formatDateTime(String apiDateTime) {
    try {
      final date = DateTime.parse(apiDateTime);
      return DateFormat('dd-MM-yyyy HH:mm').format(date);
    } catch (e) {
      return apiDateTime; // fallback if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasNominee = details.nominees.isNotEmpty;
    final nominee = hasNominee ? details.nominees.first : null;

    final hasAddress = details.addresses.isNotEmpty;
    final address = hasAddress ? details.addresses.first : null;

    final hasDocument = details.documents.isNotEmpty;
    final document = hasDocument ? details.documents.first : null;

    final hasSavings = details.savings.isNotEmpty;

    // Summed values for summary cards
    final totalAmount = details.savings.fold<double>(
      0,
      (sum, saving) => sum + (saving.totalAmount ?? 0),
    );

    final totalGoldWeight = details.savings.fold<double>(
      0,
      (sum, saving) => sum + (saving.totalGoldWeight ?? 0),
    );

    final totalBenefitGram = details.savings.fold<double>(
      0,
      (sum, saving) => sum + (saving.totalBenefitGram ?? 0),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          details.cName.isNotEmpty ? details.cName : "Customer Details",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Appcolors.headerbackground,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          // Summary cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _summaryCard(
                title: "Total Amount",
                value: "₹${totalAmount.toStringAsFixed(2)}",
                color: Colors.green[400]!,
                icon: Icons.account_balance_wallet,
              ),
              _summaryCard(
                title: "Total Gold Weight",
                value: "${totalGoldWeight.toStringAsFixed(2)} g",
                color: Colors.amber[700]!,
                icon: Icons.scale,
              ),
              _summaryCard(
                title: "Total Benefit Gram",
                value: "${totalBenefitGram.toStringAsFixed(2)} g",
                color: Colors.purple[400]!,
                icon: Icons.star,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Basic Info
          _buildCard(
            title: "Basic Info",
            color: Colors.indigo[50]!,
            children: [
              _iconRow(
                Icons.person,
                "Name",
                details.cName.isNotEmpty ? details.cName : 'N/A',
              ),
              _iconRow(
                Icons.email,
                "Email",
                details.cEmail.isNotEmpty ? details.cEmail : 'N/A',
              ),
              _iconRow(
                Icons.phone,
                "Phone",
                details.cPhoneNumber.isNotEmpty ? details.cPhoneNumber : 'N/A',
              ),
            ],
          ),

          // Address
          _buildCard(
            title: "Address",
            color: Colors.teal[50]!,
            children:
                hasAddress
                    ? [
                      _iconRow(Icons.home, "Address", address!.cDoorNo),
                      _iconRow(Icons.location_city, "City", address.cCity),
                      _iconRow(Icons.pin_drop, "Pin Code", address.cPinCode),

                      //     _iconRow(Icons.location_on, "Line 1", address.cAddressLine1),
                      //   if (address.cAddressLine2.isNotEmpty)
                      //      _iconRow(Icons.location_on, "Line 2", address.cAddressLine2),
                      //  _iconRow(Icons.map, "State", address.cState),
                      //  _iconRow(Icons.check_circle, "Primary", address.cIsPrimary ? 'Yes' : 'No'),
                    ]
                    : [const Text("No Address Found")],
          ),

          // Documents
          _buildCard(
            title: "Documents",
            color: Colors.orange[50]!,
            children:
                hasDocument
                    ? [
                      _iconRow(
                        Icons.credit_card,
                        "Aadhar",
                        document!.cAadharNo.isNotEmpty
                            ? document.cAadharNo
                            : 'N/A',
                      ),
                      _iconRow(
                        Icons.card_membership,
                        "PAN",
                        document.cPanNo.isNotEmpty ? document.cPanNo : 'N/A',
                      ),
                    ]
                    : [const Text("No Documents Found")],
          ),

          // Nominee
          _buildCard(
            title: "Nominee",
            color: Colors.purple[50]!,
            children:
                hasNominee
                    ? [
                      _iconRow(Icons.person, "Name", nominee!.cNomineeName),
                      _iconRow(
                        Icons.email,
                        "Email",
                        nominee.cNomineeEmail.isNotEmpty
                            ? nominee.cNomineeEmail
                            : 'N/A',
                      ),
                      _iconRow(
                        Icons.phone,
                        "Phone",
                        nominee.cNomineePhoneNo.isNotEmpty
                            ? nominee.cNomineePhoneNo
                            : 'N/A',
                      ),
                      // _iconRow(
                      //   Icons.pin_drop,
                      //   "Pin Code",
                      //   nominee.pinCode.isNotEmpty ? nominee.pinCode : 'N/A',
                      // ),
                    ]
                    : [const Text("No Nominee Added")],
          ),

          // Savings & Transactions
          _buildCard(
            title: "Savings & Transactions",
            color: Colors.green[50]!,
            children:
                hasSavings
                    ? details.savings.map((saving) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Scheme Name
                          Text(
                            saving.schemeName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),

                          _iconRow(
                            Icons.account_balance_wallet,
                            "Total Amount",
                            "₹${saving.totalAmount.toStringAsFixed(2)}",
                          ),
                          _iconRow(
                            Icons.scale,
                            "Total Gold Weight",
                            "${saving.totalGoldWeight} g",
                          ),
                          _iconRow(
                            Icons.date_range,
                            "Start Date",
                            formatDateTime(saving.startDate),
                          ),
                          _iconRow(
                            Icons.date_range,
                            "End Date",
                            formatDateTime(saving.endDate),
                          ),

                          const SizedBox(height: 8),

                          if (saving.transactions.isNotEmpty) ...[
                            const Text(
                              "Transactions:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            ...saving.transactions.map(
                              (tx) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.arrow_right,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        "${formatDateTime(tx.transactionDate)} - ₹${tx.transactionAmount} (${tx.transactionType})",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ] else
                            const Text("No Transactions Found"),

                          const Divider(thickness: 1),
                          const SizedBox(height: 8),
                        ],
                      );
                    }).toList()
                    : [const Text("No Savings Data")],
          ),
        ],
      ),
    );
  }

  // Card builder
  Widget _buildCard({
    required String title,
    required List<Widget> children,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  // Icon row
  Widget _iconRow(IconData icon, String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.indigo),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              "$key:",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(flex: 5, child: Text(value)),
        ],
      ),
    );
  }
}

// Summary card
Widget _summaryCard({
  required String title,
  required String value,
  required Color color,
  required IconData icon,
}) {
  return Expanded(
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
