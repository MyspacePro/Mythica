import 'package:flutter/material.dart';

class ReaderCoinScreen extends StatefulWidget {
  const ReaderCoinScreen({super.key});

  @override
  State<ReaderCoinScreen> createState() => _ReaderCoinScreenState();
}

class _ReaderCoinScreenState extends State<ReaderCoinScreen> {
  int coins = 250;
  double walletBalance = 120.0;

  void _convertCoins() {
    if (coins >= 100) {
      setState(() {
        coins -= 100;
        walletBalance += 10;
      });
    }
  }

  void _withdraw() {
    if (walletBalance >= 50) {
      setState(() {
        walletBalance = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF140F26),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1533),
        elevation: 0,
        title: const Text("Reader Coins"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// COIN CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2A1E47), Color(0xFF1F1533)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    "Your Coins",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "$coins 🪙",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF5C84C),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: _convertCoins,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5C84C),
                    ),
                    child: const Text("Convert to Cash"),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// WALLET CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF251A3F),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    "Wallet Balance",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "₹${walletBalance.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: _withdraw,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text("Withdraw"),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// OFFERS TITLE
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Earn More Coins",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// REFER & EARN
            _offerCard(
              title: "Refer & Earn",
              description:
                  "Invite friends & earn 50 coins per friend.\n\n*Minimum 5 friends must join & download app.",
              buttonText: "Invite",
              icon: Icons.share,
            ),

            const SizedBox(height: 15),

            /// DAILY REWARD
            _offerCard(
              title: "Daily Reading Reward",
              description:
                  "Read daily for 20 minutes and earn 20 coins.",
              buttonText: "Start Reading",
              icon: Icons.menu_book,
            ),

            const SizedBox(height: 15),

            /// WATCH ADS
            _offerCard(
              title: "Watch & Earn",
              description:
                  "Watch short ads and earn instant coins.",
              buttonText: "Watch Now",
              icon: Icons.play_circle_fill,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _offerCard({
    required String title,
    required String description,
    required String buttonText,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF2E224F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFF5C84C), size: 32),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5C84C),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}