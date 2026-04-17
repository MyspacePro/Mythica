import 'package:flutter/material.dart';

class StoryAnalyticsScreen extends StatefulWidget {
  const StoryAnalyticsScreen({super.key});

  @override
  State<StoryAnalyticsScreen> createState() => _StoryAnalyticsScreenState();
}

class _StoryAnalyticsScreenState extends State<StoryAnalyticsScreen> {
  final int totalViews = 10000;
  final int uniqueReaders = 7200;
  final double completionRate = 85;
  final int totalLikes = 1250;
  final int totalComments = 540;
  final int totalShares = 320;
  final int followersGained = 180;
  final int totalReadingMinutes = 54000;

  final List<ChapterAnalytics> chapters = [
    ChapterAnalytics("Chapter 1", 10000, 95),
    ChapterAnalytics("Chapter 2", 9200, 88),
    ChapterAnalytics("Chapter 3", 7000, 70),
    ChapterAnalytics("Chapter 4", 6200, 60),
    ChapterAnalytics("Chapter 5", 5800, 55),
  ];

  final List<GrowthAnalytics> weeklyGrowth = [
    GrowthAnalytics("Week 1", 1200),
    GrowthAnalytics("Week 2", 2400),
    GrowthAnalytics("Week 3", 4200),
    GrowthAnalytics("Week 4", 10000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Story Analytics",
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFF5C84C)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1F1533),
              Color(0xFF2A1E47),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SectionTitle(title: "Overview"),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    AnalyticsCard("Total Views", totalViews.toString(), Icons.remove_red_eye),
                    AnalyticsCard("Unique Readers", uniqueReaders.toString(), Icons.people),
                    AnalyticsCard("Completion Rate", "$completionRate%", Icons.check_circle),
                    AnalyticsCard("Reading Minutes", totalReadingMinutes.toString(), Icons.timer),
                    AnalyticsCard("Likes", totalLikes.toString(), Icons.favorite),
                    AnalyticsCard("Comments", totalComments.toString(), Icons.comment),
                    AnalyticsCard("Shares", totalShares.toString(), Icons.share),
                    AnalyticsCard("Followers Gained", followersGained.toString(), Icons.person_add),
                  ],
                ),

                const SizedBox(height: 40),

                const SectionTitle(title: "Chapter Engagement"),
                const SizedBox(height: 16),

                Column(
                  children: chapters
                      .map((chapter) => ChapterEngagementCard(chapter: chapter))
                      .toList(),
                ),

                const SizedBox(height: 40),

                const SectionTitle(title: "Weekly Growth"),
                const SizedBox(height: 16),

                Column(
                  children: weeklyGrowth
                      .map((growth) => GrowthCard(growth: growth))
                      .toList(),
                ),

                const SizedBox(height: 40),

                const SectionTitle(title: "Story Comparison Example"),
                const SizedBox(height: 16),

                const StoryComparisonCard(),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// MODELS

class ChapterAnalytics {
  final String title;
  final int views;
  final double engagementRate;

  ChapterAnalytics(this.title, this.views, this.engagementRate);
}

class GrowthAnalytics {
  final String label;
  final int reads;

  GrowthAnalytics(this.label, this.reads);
}

// UI COMPONENTS

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFFFFFFFF),
      ),
    );
  }
}

class AnalyticsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const AnalyticsCard(this.title, this.value, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 28,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF3A2D5C)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD76A).withValues(alpha:0.15),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: const Color(0xFFF5C84C)),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFFCFC8E8),
            ),
          ),
        ],
      ),
    );
  }
}

class ChapterEngagementCard extends StatelessWidget {
  final ChapterAnalytics chapter;

  const ChapterEngagementCard({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chapter.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFFFFFFFF),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Views: ${chapter.views}",
            style: const TextStyle(color: Color(0xFFCFC8E8)),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: chapter.engagementRate / 100,
              minHeight: 10,
              backgroundColor: const Color(0xFF3A2D5C),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFF5C84C)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Engagement: ${chapter.engagementRate}%",
            style: const TextStyle(color: Color(0xFF9F96C8)),
          ),
        ],
      ),
    );
  }
}

class GrowthCard extends StatelessWidget {
  final GrowthAnalytics growth;

  const GrowthCard({super.key, required this.growth});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            growth.label,
            style: const TextStyle(color: Color(0xFFCFC8E8)),
          ),
          Text(
            "${growth.reads} Reads",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFF5C84C),
            ),
          ),
        ],
      ),
    );
  }
}

class StoryComparisonCard extends StatelessWidget {
  const StoryComparisonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Story A",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF))),
          SizedBox(height: 8),
          Text("10,000 Views", style: TextStyle(color: Color(0xFFCFC8E8))),
          Text("85% Completion Rate", style: TextStyle(color: Color(0xFFCFC8E8))),
          Text("500 Comments", style: TextStyle(color: Color(0xFFCFC8E8))),
          Divider(color: Color(0xFF3A2D5C), height: 30),
          Text("Story B",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF))),
          SizedBox(height: 8),
          Text("10,000 Views", style: TextStyle(color: Color(0xFFCFC8E8))),
          Text("30% Completion Rate", style: TextStyle(color: Color(0xFFCFC8E8))),
          Text("20 Comments", style: TextStyle(color: Color(0xFFCFC8E8))),
          SizedBox(height: 16),
          Text(
            "Insight: Story A has stronger engagement despite equal views.",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFFF5C84C),
            ),
          ),
        ],
      ),
    );
  }
}