import 'package:flutter/material.dart';

class ReaderSubscriptionScreen extends StatelessWidget {
  const ReaderSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1A1A),
        elevation: 0,
        title: const Text("Reader Plans"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            _ReaderPlanCard(
              title: "Free Reader",
              price: "₹0",
              highlight: false,
              benefits: [
                "Read limited free books",
                "Ads enabled",
                "Basic recommendations",
              ],
            ),
            SizedBox(height: 20),
            _ReaderPlanCard(
              title: "Premium Reader",
              price: "₹199 / month",
              highlight: true,
              benefits: [
                "Unlimited premium books",
                "Ad-free experience",
                "Offline reading",
                "Early access to new releases",
              ],
            ),
            SizedBox(height: 20),
            _ReaderPlanCard(
              title: "Annual Premium",
              price: "₹1,999 / year",
              highlight: false,
              benefits: [
                "Everything in Premium",
                "Save 15% annually",
                "Exclusive premium content",
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//
// 💎 READER PLAN CARD
//

class _ReaderPlanCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> benefits;
  final bool highlight;

  const _ReaderPlanCard({
    required this.title,
    required this.price,
    required this.benefits,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFF2A3B55) : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: highlight
            ? Border.all(color: Colors.amber, width: 1.2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            price,
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          ...benefits.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.greenAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      b,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    highlight ? Colors.amber : const Color(0xFF334155),
                foregroundColor:
                    highlight ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: Text(
                highlight ? "Upgrade Now" : "Choose Plan",
              ),
            ),
          )
        ],
      ),
    );
  }
}
