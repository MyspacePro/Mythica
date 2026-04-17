import 'package:mythica/features/writer/widgets/writer_stats.dart';
import 'package:flutter/material.dart';
import 'package:mythica/features/writer/widgets/writer_header.dart';
import 'package:mythica/features/writer/widgets/writer_actions.dart';

class WriterScreen extends StatelessWidget {
  const WriterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1533),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Writer Dashboard',
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
        child: const SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WriterHeader(),
                SizedBox(height: 32),
                WriterStatsRow(),
                SizedBox(height: 40),
                WriterActions(),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
