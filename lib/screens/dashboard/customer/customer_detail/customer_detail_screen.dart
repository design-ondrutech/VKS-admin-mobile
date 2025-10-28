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
        title: Text(
          details.cName.isNotEmpty ? details.cName : "Customer Details",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Summary Section
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
                  _summaryItem(
                    "Total Paid",
                    "₹${(details.summary?.totalPaidAmount ?? 0).toStringAsFixed(0)}",
                    Icons.account_balance_wallet,
                    Colors.green,
                  ),
                  _summaryItem(
                    "Gold Weight",
                    "${(details.summary?.totalPaidGoldWeight ?? 0)} g",
                    Icons.scale,
                    Colors.orange,
                  ),
                  _summaryItem(
                    "Benefit Gold",
                    "${details.summary?.totalBenefitGram ?? 0} g",
                    Icons.trending_up,
                    Colors.blue,
                  ),
                  _summaryItem(
                    "Bonus Gold",
                    "${details.summary?.totalBonusGoldWeight ?? 0} g",
                    Icons.card_giftcard,
                    Colors.purple,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Basic Info
            _section("Basic Info", [
              _infoRow(Icons.person, "Name", details.cName),
              _infoRow(Icons.email, "Email", details.cEmail),
              _infoRow(Icons.phone, "Phone", details.cPhoneNumber),
            ]),

            /// Address
            _section(
              "Address",
              hasAddress
                  ? [
                    _infoRow(Icons.home, "Address", address!.cAddressLine1),
                    _infoRow(Icons.location_city, "City", address.cCity),
                    _infoRow(Icons.pin_drop, "Pin Code", address.cPinCode),
                  ]
                  : [const Text("No Address Found")],
            ),

            /// Documents
            _section(
              "Documents",
              hasDocument
                  ? [
                    _infoRow(Icons.credit_card, "Aadhar", document!.cAadharNo),
                    _infoRow(Icons.card_membership, "PAN", document.cPanNo),
                  ]
                  : [const Text("No Documents Found")],
            ),

            /// Nominee
            _section(
              "Nominee",
              hasNominee
                  ? [
                    _infoRow(Icons.person, "Name", nominee!.cNomineeName),
                    _infoRow(Icons.email, "Email", nominee.cNomineeEmail),
                    _infoRow(Icons.phone, "Phone", nominee.cNomineePhoneNo),
                  ]
                  : [const Text("No Nominee Added")],
            ),

            /// Savings & Transactions
            _section(
              "Savings & Transactions",
              hasSavings
                  ? details.savings
                      .map(
                        (saving) => _ExpandableSavingCard(
                          saving: saving,
                          formatDate: formatDate,
                        ),
                      )
                      .toList()
                  : [const Text("No Savings Data")],
            ),
          ],
        ),
      ),
    );
  }

  /// Section Layout
  Widget _section(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  /// Info Row
  Widget _infoRow(IconData icon, String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.teal),
          const SizedBox(width: 10),
          Text(
            "$key:",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value.isNotEmpty ? value : "N/A")),
        ],
      ),
    );
  }

  /// Summary Grid Item
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
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Expandable Card for each Saving
class _ExpandableSavingCard extends StatefulWidget {
  final Saving saving;
  final String Function(String) formatDate;

  const _ExpandableSavingCard({required this.saving, required this.formatDate});

  @override
  State<_ExpandableSavingCard> createState() => _ExpandableSavingCardState();
}

class _ExpandableSavingCardState extends State<_ExpandableSavingCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final saving = widget.saving;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        //  Title with scheme name + status badge (using isCompleted)
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                saving.schemeName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildStatusBadge(saving.isCompleted ? 'completed' : 'active'),
          ],
        ),

        //  Animated arrow
        trailing: AnimatedRotation(
          turns: _isExpanded ? 0.5 : 0.0,
          duration: const Duration(milliseconds: 250),
          child: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.teal,
            size: 28,
          ),
        ),

        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },

        //  Expanded content
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(
                  Icons.wallet,
                  "Total Amount",
                  "₹${saving.totalAmount.toStringAsFixed(0)}",
                ),
                _infoRow(
                  Icons.workspace_premium,
                  "Total Gold (with Benefit)",
                  "${(saving.totalBonusGoldWeight).toStringAsFixed(4)} g",
                ),
                _infoRow(
                  Icons.scale,
                  "Total Gold (Without Benefit)",
                  "${saving.totalGoldWeight} g",
                ),
                _infoRow(
                  Icons.date_range,
                  "Start Date",
                  widget.formatDate(saving.startDate),
                ),
                _infoRow(
                  Icons.date_range,
                  "End Date",
                  widget.formatDate(saving.endDate),
                ),
                const SizedBox(height: 12),
                if (saving.transactions.isNotEmpty)
                  _stripedTable(saving.transactions)
                else
                  const Text("No Transactions Found"),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //  Status badge builder
  Widget _buildStatusBadge(String status) {
    final normalized = status.trim().toLowerCase();

    Color color;
    IconData icon;
    String label;

 if (normalized == 'completed' || normalized == 'complete') {
  color = Colors.green.shade800; //  green for completed
  icon = Icons.check_circle;
  label = 'Completed';
} else if (normalized == 'active' || normalized == 'progress') {
  color = Colors.amber.shade800; // yellow for progress
  icon = Icons.timelapse;
  label = 'Progress';
} else {
  color = Colors.grey;
  icon = Icons.help_outline;
  label = status;
}


    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  //  Info row builder
  Widget _infoRow(IconData icon, String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.teal),
          const SizedBox(width: 10),
          Text(
            "$key:",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value.isNotEmpty ? value : "N/A")),
        ],
      ),
    );
  }

  //  Transaction table
  Widget _stripedTable(List<Transaction> transactions) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.4),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(1.2),
        3: FlexColumnWidth(1),
      },
      border: TableBorder.all(color: Colors.grey.shade300, width: 1),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: const [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Amount",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Gold(g)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Type",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        ...transactions.asMap().entries.map((entry) {
          final i = entry.key;
          final tx = entry.value;
          return TableRow(
            decoration: BoxDecoration(
              color: i % 2 == 0 ? Colors.grey.shade50 : Colors.white,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(widget.formatDate(tx.transactionDate)),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text("₹${tx.transactionAmount.toStringAsFixed(0)}"),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text("${tx.transactionGoldGram} g"),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(tx.transactionType),
              ),
            ],
          );
        }),
      ],
    );
  }
}
