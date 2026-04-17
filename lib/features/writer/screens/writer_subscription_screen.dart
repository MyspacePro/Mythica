import 'package:flutter/material.dart';

class WriterSubscribersScreen extends StatelessWidget {
  const WriterSubscribersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1533),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Subscribers",
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFF5C84C),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1F1533),
              Color(0xFF2A1E47),
              Color(0xFF140F26),
            ],
          ),
        ),
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(20),
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SubscriberHeroCard(),
              SizedBox(height: 28),
              _SubscriberStatsRow(),
              SizedBox(height: 34),
              _SectionTitle("Recent Subscribers"),
              SizedBox(height: 16),
              _SubscribersList(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// HERO CARD
////////////////////////////////////////////////////////////

class _SubscriberHeroCard extends StatelessWidget {
  const _SubscriberHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3A2D5C)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4DFFD76A), // 30% gold glow
            blurRadius: 20,
            spreadRadius: 1,
          )
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Subscribers",
            style: TextStyle(
              color: Color(0xFFCFC8E8),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "1,284",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF5C84C),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "+18% growth this month",
            style: TextStyle(
              color: Color(0xFF9F96C8),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// STATS ROW
////////////////////////////////////////////////////////////

class _SubscriberStatsRow extends StatelessWidget {
  const _SubscriberStatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _SubscriberStatCard(
            title: "Free",
            value: "820",
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _SubscriberStatCard(
            title: "Premium",
            value: "464",
          ),
        ),
      ],
    );
  }
}

class _SubscriberStatCard extends StatelessWidget {
  final String title;
  final String value;

  const _SubscriberStatCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF9F96C8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// SUBSCRIBERS LIST
////////////////////////////////////////////////////////////

class _SubscribersList extends StatelessWidget {
  const _SubscribersList();

  @override
  Widget build(BuildContext context) {
    final subscribers = [
      {"name": "Amit Sharma", "type": "Premium", "date": "Today"},
      {"name": "Neha Verma", "type": "Free", "date": "Yesterday"},
      {"name": "Rahul Mehta", "type": "Premium", "date": "12 Apr"},
      {"name": "Sneha Patel", "type": "Free", "date": "10 Apr"},
    ];

    return Column(
      children: subscribers.map((s) {
        final isPremium = s["type"] == "Premium";

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF251A3F),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF3A2D5C)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFF5C84C),
                child: Text(
                  s["name"]![0],
                  style: const TextStyle(
                    color: Color(0xFF1F1533),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s["name"]!,
                      style: const TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s["date"]!,
                      style: const TextStyle(
                        color: Color(0xFF9F96C8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isPremium
                      ? const Color(0xFFF5C84C).withValues(alpha:0.15)
                      : const Color(0xFF251A3F),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF3A2D5C),
                  ),
                ),
                child: Text(
                  s["type"]!,
                  style: const TextStyle(
                    color: Color(0xFFCFC8E8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

////////////////////////////////////////////////////////////
/// SECTION TITLE
////////////////////////////////////////////////////////////

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Recent Subscribers",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFFFFFFFF),
      ),
    );
  }
}