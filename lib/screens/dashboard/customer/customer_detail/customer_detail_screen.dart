import 'package:admin/screens/dashboard/customer/customer_detail/model/customer_details_model.dart';
import 'package:admin/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomerDetailScreen extends StatelessWidget {
  final CustomerDetails details;
  const CustomerDetailScreen({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final hasNominee = details.nominees.isNotEmpty;
    final nominee = hasNominee ? details.nominees.first : null;

    final hasAddress = details.addresses.isNotEmpty;
    final address = hasAddress ? details.addresses.first : null;

    final hasDocument = details.documents.isNotEmpty;
    final document = hasDocument ? details.documents.first : null;

    final hasSavings = details.savings.isNotEmpty;
    final saving = hasSavings ? details.savings.first : null;

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
          // Profile Header
          //_profileHeader(),
             const SizedBox(height: 16),
          // Inside the ListView, just after the profile header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _summaryCard(
                title: "Total Amount",
                value:
                    hasSavings
                        ? "₹${saving!.totalAmount.toStringAsFixed(2)}"
                        : "₹0.00",
                color: Colors.green[400]!,
                icon: Icons.account_balance_wallet,
              ),
              _summaryCard(
                title: "Total Gold Weight",
                value: hasSavings ? "${saving!.totalGoldWeight} g" : "0 g",
                color: Colors.amber[700]!,
                icon: Icons.scale,
              ),
            ],
          ),

          const SizedBox(height: 16),

          const SizedBox(height: 20),

          // Basic Info
          _buildCard(
            title: "Basic Info",
            color: Colors.indigo[50]!,
            children: [
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
                      _iconRow(Icons.home, "Door No", address!.cDoorNo),
                      _iconRow(
                        Icons.location_on,
                        "Line 1",
                        address.cAddressLine1,
                      ),
                      if (address.cAddressLine2.isNotEmpty)
                        _iconRow(
                          Icons.location_on,
                          "Line 2",
                          address.cAddressLine2,
                        ),
                      _iconRow(Icons.location_city, "City", address.cCity),
                      _iconRow(Icons.map, "State", address.cState),
                      _iconRow(Icons.pin_drop, "Pin Code", address.cPinCode),
                      _iconRow(
                        Icons.check_circle,
                        "Primary",
                        address.cIsPrimary ? 'Yes' : 'No',
                      ),
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
                      _iconRow(
                        Icons.pin_drop,
                        "Pin Code",
                        nominee.pinCode.isNotEmpty ? nominee.pinCode : 'N/A',
                      ),
                    ]
                    : [const Text("No Nominee Added")],
          ),

          // Savings & Transactions
          _buildCard(
            title: "Savings & Transactions",
            color: Colors.green[50]!,
            children:
                hasSavings
                    ? [
                      _iconRow(
                        Icons.account_balance_wallet,
                        "Total Amount",
                        "₹${saving!.totalAmount.toStringAsFixed(2)}",
                      ),
                      _iconRow(
                        Icons.scale,
                        "Total Gold Weight",
                        "${saving.totalGoldWeight} g",
                      ),
                      _iconRow(
                        Icons.card_giftcard,
                        "Scheme",
                        saving.schemeName,
                      ),
                      _iconRow(
                        Icons.date_range,
                        "Start Date",
                        saving.startDate,
                      ),
                      _iconRow(Icons.date_range, "End Date", saving.endDate),
                      const SizedBox(height: 8),
                      if (saving.transactions.isNotEmpty) ...[
                        const Text(
                          "Transactions:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        ...saving.transactions.map(
                          (tx) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
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
                                    "${tx.transactionDate} - ₹${tx.transactionAmount} (${tx.transactionType})",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] else
                        const Text("No Transactions Found"),
                    ]
                    : [const Text("No Savings Data")],
          ),
        ],
      ),
    );
  }

  // Profile header widget
  Widget _profileHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.indigo,
              child: Text(
                details.cName.isNotEmpty ? details.cName[0] : "C",
                style: const TextStyle(fontSize: 32, color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    details.cName.isNotEmpty ? details.cName : "Customer Name",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    details.cEmail.isNotEmpty ? details.cEmail : 'N/A',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    details.cPhoneNumber.isNotEmpty
                        ? details.cPhoneNumber
                        : 'N/A',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card builder for each section
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

  // Row with icon and value
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
Widget _summaryCard({required String title, required String value, required Color color, required IconData icon}) {
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
            Text(title, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ),
  );
}
