import 'package:admin/screens/dashboard/widgets/gold_rate/gold_add_popup.dart';
import 'package:admin/utils/colors.dart';
import 'package:flutter/material.dart';

class AddGoldRate extends StatelessWidget {
  const AddGoldRate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Gold & Silver Rates",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Gold Rate Card
            _rateCard(
              title: "Gold Rate (22K per gram)",
              rate: "₹5,450",
              gradient: [Colors.orange.shade400, Colors.orange.shade700],
              icon: Icons.circle, // Gold indicator
            ),
            const SizedBox(height: 16),

            // Silver Rate Card
            _rateCard(
              title: "Silver Rate (per gram)",
              rate: "₹74",
              gradient: [Colors.grey.shade400, Colors.grey.shade700],
              icon: Icons.circle, // Silver indicator
            ),

            const Spacer(),

            // Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Appcolors.buttoncolor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  showDialog(  
                    context: context,
                    builder: (context) => const AddGoldRateDialog(),
                  );
                  // Add navigation or update logic here
                },
                child: const Text(
                  "Update Rates",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rateCard({
    required String title,
    required String rate,
    required List<Color> gradient,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            rate,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
