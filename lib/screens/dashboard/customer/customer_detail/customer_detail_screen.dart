import 'package:admin/screens/dashboard/customer/customer_detail/model/customer_details_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerDetailScreen extends StatelessWidget {
  final CustomerDetails details;
  const CustomerDetailScreen({super.key, required this.details});

  String formatDate(String apiDate) {
    try {
      return DateFormat('dd-MM-yyyy').format(DateTime.parse(apiDate));
    } catch (e) {
      return apiDate;
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

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(details.cName.isNotEmpty ? details.cName : "Customer Details",
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///  Summary Section (Flat Style)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _summaryItem("Total Paid",
                      "₹${(details.summary?.totalPaidAmount ?? 0).toStringAsFixed(0)}",
                      Icons.account_balance_wallet, Colors.green),
                  _summaryItem("Gold Weight",
                      "${(details.summary?.totalPaidGoldWeight ?? 0)} g",
                      Icons.scale, Colors.orange),
                  _summaryItem("Benefit Gold",
                      "${details.summary?.totalBenefitGram ?? 0} g",
                      Icons.trending_up, Colors.blue),
                  _summaryItem("Bonus Gold",
                      "${details.summary?.totalBonusGoldWeight ?? 0} g",
                      Icons.card_giftcard, Colors.purple),
                ],
              ),
            ),

            const SizedBox(height: 24),

            ///  Sections
            _section("Basic Info", [
              _infoRow(Icons.person, "Name", details.cName),
              _infoRow(Icons.email, "Email", details.cEmail),
              _infoRow(Icons.phone, "Phone", details.cPhoneNumber),
            ]),

            _section("Address", hasAddress ? [
              _infoRow(Icons.home, "Address", address!.cAddressLine1),
              _infoRow(Icons.location_city, "City", address.cCity),
              _infoRow(Icons.pin_drop, "Pin Code", address.cPinCode),
            ] : [const Text("No Address Found")]),

            _section("Documents", hasDocument ? [
              _infoRow(Icons.credit_card, "Aadhar", document!.cAadharNo),
              _infoRow(Icons.card_membership, "PAN", document.cPanNo),
            ] : [const Text("No Documents Found")]),

            _section("Nominee", hasNominee ? [
              _infoRow(Icons.person, "Name", nominee!.cNomineeName),
              _infoRow(Icons.email, "Email", nominee.cNomineeEmail),
              _infoRow(Icons.phone, "Phone", nominee.cNomineePhoneNo),
            ] : [const Text("No Nominee Added")]),

            _section("Savings & Transactions", hasSavings ? details.savings.map((saving) {
              return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          saving.schemeName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        //   decoration: BoxDecoration(
        //     color: DateTime.parse(saving.endDate).isBefore(DateTime.now())
        //         ? Colors.red[100]
        //         : Colors.green[100],
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   child: Text(
        //     DateTime.parse(saving.endDate).isBefore(DateTime.now())
        //         ? "Complete"
        //         : "Active",
        //     style: TextStyle(
        //       fontSize: 12,
        //       fontWeight: FontWeight.bold,
        //       color: DateTime.parse(saving.endDate).isBefore(DateTime.now())
        //           ? Colors.red[800]
        //           : Colors.green[800],
        //     ),
        //   ),
        // ),
      ],
    ),

    const SizedBox(height: 8),
    _infoRow(Icons.wallet, "Total Amount",
        "₹${saving.totalAmount.toStringAsFixed(0)}"),
    _infoRow(Icons.scale, "Gold Weight", "${saving.totalGoldWeight} g"),
    _infoRow(Icons.date_range, "Start Date", formatDate(saving.startDate)),
    _infoRow(Icons.date_range, "End Date", formatDate(saving.endDate)),

    const SizedBox(height: 12),
    if (saving.transactions.isNotEmpty)
      _stripedTable(saving.transactions)
    else
      const Text("No Transactions Found"),

    const Divider(),
  ],
);

            }).toList() : [const Text("No Savings Data")]),
          ],
        ),
      ),
    );
  }

  ///  Flat Section
  Widget _section(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          )
        ],
      ),
    );
  }

  ///  Info Row
  Widget _infoRow(IconData icon, String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.teal),
          const SizedBox(width: 10),
          Text("$key:",
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(child: Text(value.isNotEmpty ? value : "N/A")),
        ],
      ),
    );
  }

  ///  Summary Item (flat style inside grid)
  Widget _summaryItem(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  ///  Striped Table for Transactions
  Widget _stripedTable(List<Transaction> transactions) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(1.3),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),

      },
      border: TableBorder.all(color: Colors.grey.shade300, width: 1),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: const [
            Padding(padding: EdgeInsets.all(8), child: Text("Date", style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.all(8), child: Text("Gold(g)", style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.all(8), child: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.all(8), child: Text("Type", style: TextStyle(fontWeight: FontWeight.bold))),
            
          ],
        ),
        ...transactions.asMap().entries.map((entry) {
          final i = entry.key;
          final tx = entry.value;
          return TableRow(
            decoration: BoxDecoration(
                color: i % 2 == 0 ? Colors.grey.shade50 : Colors.white),
            children: [
              Padding(padding: const EdgeInsets.all(8), child: Text(formatDate(tx.transactionDate))),
              Padding(padding: const EdgeInsets.all(8), child: Text("${tx.transactionGoldGram} g")),
              Padding(padding: const EdgeInsets.all(8), child: Text("₹${tx.transactionAmount.toStringAsFixed(0)}")),
              Padding(padding: const EdgeInsets.all(8), child: Text(tx.transactionType)),
            ],
          );
        }),
      ],
    );
  }
}
