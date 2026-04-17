import 'package:mythica/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:mythica/features/auth/provider/auth_provider.dart';
import 'package:mythica/providers/monetization_provider.dart';
import 'package:mythica/features/writer/provider/writer_provider.dart';
import 'package:provider/provider.dart';

class WriterEarningsScreen extends StatefulWidget {
  const WriterEarningsScreen({super.key});

  @override
  State<WriterEarningsScreen> createState() => _WriterEarningsScreenState();
}

class _WriterEarningsScreenState extends State<WriterEarningsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      context.read<WriterProvider>().loadWriterStudio(user: auth.currentUser, isGuest: auth.isGuest);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1533),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1533),
        elevation: 0,
        title: const Text(
          "Earnings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFF5C84C)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1F1533),
              Color(0xFF2A1E47),
              Color(0xFF140F26),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TotalEarningsCard(),
              const SizedBox(height: 26),
              const _StatsRow(),
              const SizedBox(height: 36),
              const Text(
                "Recent Transactions",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 16),
              const _TransactionsList(),
            ],
          ),
        ),
      ),
    );
  }
}

//
// 💎 TOTAL EARNINGS CARD
//

class _TotalEarningsCard extends StatelessWidget {
  const _TotalEarningsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFF3A2D5C)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4DFFD76A),
            blurRadius: 22,
            spreadRadius: 1,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Earnings",
            style: TextStyle(
              color: Color(0xFFCFC8E8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Consumer2<WriterProvider, AuthProvider>(
            builder: (context, writer, auth, _) {
              final total = isDummyMode
                  ? context.read<MonetizationProvider>().dummyTotalEarnings
                  : writer.totalEarnings;
              final safeTotal = total < 0 ? 0.0 : total;
              if (auth.currentUser == null) {
                return const Text(
                  '₹ 0',
                  style: TextStyle(
                    color: Color(0xFFF5C84C),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                );
              }

              return Text(
                '₹ ${safeTotal.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Color(0xFFF5C84C),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              );
            },
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5C84C),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x4DFFD76A),
                    blurRadius: 18,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Withdraw Earnings",
                  style: TextStyle(
                    color: Color(0xFF1F1533),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

//
// 📊 STATS ROW
//

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    final writer = context.watch<WriterProvider>();
    final monetization = context.watch<MonetizationProvider>();

    final thisMonth = isDummyMode
        ? monetization.transactions
            .where((tx) => tx['isCredit'] == true)
            .fold<double>(0, (sum, tx) => sum + ((tx['amount'] as num?)?.toDouble() ?? 0))
        : writer.writerBooks
            .where((book) => book.isPaid)
            .fold<double>(0, (sum, book) => sum + (book.totalEarnings * 0.25));

    final totalSales = writer.writerBooks.where((book) => book.isPaid).length;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'This Month',
            value: '₹ ${thisMonth.toStringAsFixed(0)}',
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: _StatCard(
            title: 'Total Sales',
            value: totalSales.toString(),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF9F96C8),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFF5C84C),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

//
// 📄 TRANSACTIONS LIST
//

class _TransactionsList extends StatelessWidget {
  const _TransactionsList();

  @override
  Widget build(BuildContext context) {
    final transactions = context.watch<MonetizationProvider>().transactions;

    return Column(
      children: transactions.map((tx) {
        final isCredit = tx['isCredit'] == true;

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
              Expanded(
                child: Text(
                  tx['title'].toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                '${isCredit ? '+' : '-'} ₹${(tx['amount'] as num).toStringAsFixed(0)}',
                style: TextStyle(
                  color: isCredit
                      ? const Color(0xFFF5C84C)
                      : const Color(0xFFE6B93E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}