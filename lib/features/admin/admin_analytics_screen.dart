import 'package:flutter/material.dart';

class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Text("Analytics"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _GrowthStatsRow(),
            SizedBox(height: 28),
            _RevenueBarChart(),
            SizedBox(height: 28),
            _TopBooksSection(),
          ],
        ),
      ),
    );
  }
}

//
// 📈 GROWTH STATS
//

class _GrowthStatsRow extends StatelessWidget {
  const _GrowthStatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _GrowthCard(
            title: "User Growth",
            value: "+18%",
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _GrowthCard(
            title: "Revenue Growth",
            value: "+24%",
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _GrowthCard(
            title: "New Books",
            value: "+320",
          ),
        ),
      ],
    );
  }
}

class _GrowthCard extends StatelessWidget {
  final String title;
  final String value;

  const _GrowthCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

//
// 📊 REVENUE BAR CHART (SIMPLE + SAFE)
//

class _RevenueBarChart extends StatelessWidget {
  const _RevenueBarChart();

  @override
  Widget build(BuildContext context) {
    final monthlyRevenue = [
      120,
      180,
      150,
      220,
      260,
      300,
    ]; // mock data

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Monthly Revenue (₹ in thousands)",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: monthlyRevenue.map((value) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Container(
                      height: value.toDouble(),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

//
// 📚 TOP BOOKS
//

class _TopBooksSection extends StatelessWidget {
  const _TopBooksSection();

  @override
  Widget build(BuildContext context) {
    final topBooks = [
      {"title": "Soul Journey", "sales": "4,200"},
      {"title": "Inner Power", "sales": "3,850"},
      {"title": "Mind Awakening", "sales": "3,100"},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Top Performing Books",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...topBooks.map(
            (book) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    book["title"]!,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "${book["sales"]} sales",
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
