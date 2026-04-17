import 'package:flutter/material.dart';

class AdminPayoutApprovalScreen extends StatelessWidget {
  const AdminPayoutApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Text("Payout Approvals"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _PayoutCard(
            writerName: "Rahul Sharma",
            amount: "₹3,200",
            date: "10 Feb 2026",
            status: "Pending",
          ),
          _PayoutCard(
            writerName: "Anjali Mehta",
            amount: "₹1,850",
            date: "09 Feb 2026",
            status: "Pending",
          ),
          _PayoutCard(
            writerName: "Kunal Verma",
            amount: "₹5,400",
            date: "08 Feb 2026",
            status: "On Hold",
          ),
        ],
      ),
    );
  }
}

//
// 💳 PAYOUT CARD
//

class _PayoutCard extends StatelessWidget {
  final String writerName;
  final String amount;
  final String date;
  final String status;

  const _PayoutCard({
    required this.writerName,
    required this.amount,
    required this.date,
    required this.status,
  });

  Color get _statusColor {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "On Hold":
        return Colors.amber;
      case "Approved":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                writerName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha:0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            "Requested on $date",
            style: const TextStyle(color: Colors.white60),
          ),

          const SizedBox(height: 12),

          Text(
            "Amount: $amount",
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text("Approve"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text("Reject"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
