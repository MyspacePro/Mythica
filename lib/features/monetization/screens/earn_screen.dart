import 'package:mythica/features/monetization/provider/earn_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mythica/core/theme/app_colors.dart';

class EarnWrapper extends StatelessWidget {
  const EarnWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EarnProvider()..load(),
      child: const EarnPage(),
    );
  }
}

class EarnPage extends StatelessWidget {
  const EarnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EarnProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.primaryDark,
          appBar: AppBar(
            backgroundColor: AppColors.cardDark,
            elevation: 0,
            title: const Text(
              "Earn Money",
              style: TextStyle(color: AppColors.white),
            ),
          ),
          body: RefreshIndicator(
                  onRefresh: provider.load,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// Header
                        const Text(
                          "Earning Dashboard 💰",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Earn coins by reading books or money by publishing books.",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.lightText,
                          ),
                        ),
                        const SizedBox(height: 30),

                        /// ERROR HANDLING
                        if (provider.error != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    provider.error!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.refresh, color: Colors.white),
                                  onPressed: provider.load,
                                ),
                              ],
                            ),
                          ),

                        /// READER SECTION
                        _sectionTitle("Reader Earnings"),
                        const SizedBox(height: 14),
                        _earnCard(
                          context,
                          title: "Earn as Reader",
                          subtitle: "Read books and earn coins",
                          icon: Icons.menu_book,
                          isProcessing: provider.loadingReader,
                          onTap: provider.loadingReader
                              ? null
                              : () async {
                                  await provider.addReaderCoins(10);
                                  if (provider.error != null) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(content: Text(provider.error!)));
                                  }
                                },
                        ),
                        _earnCard(
                          context,
                          title: "Coin Wallet",
                          subtitle: "View your coin balance",
                          icon: Icons.account_balance_wallet,
                          onTap: provider.loadingReader
                              ? null
                              : () => Navigator.pushNamed(context, "/coin-wallet"),
                        ),
                        _earnCard(
                          context,
                          title: "Convert Coins",
                          subtitle: "Convert coins into real money",
                          icon: Icons.currency_rupee,
                          onTap: provider.loadingReader
                              ? null
                              : () => Navigator.pushNamed(context, "/convert-coins"),
                        ),
                        const SizedBox(height: 30),

                        /// READER EARNINGS DISPLAY
                        _infoBox(
                            "Your Coins: ${provider.earn.readerCoins} | Cash: ₹${provider.earn.readerCash.toStringAsFixed(2)} | Total Reads: ${provider.earn.totalReads}"),

                        /// WRITER SECTION
                        const SizedBox(height: 30),
                        _sectionTitle("Writer Earnings"),
                        const SizedBox(height: 14),
                        _earnCard(
                          context,
                          title: "Earn as Writer",
                          subtitle: "Track your book earnings",
                          icon: Icons.edit_note,
                          isProcessing: provider.loadingWriter,
                          onTap: provider.loadingWriter
                              ? null
                              : () async {
                                  await provider.addWriterChapterReads(5);
                                  if (provider.error != null) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(content: Text(provider.error!)));
                                  }
                                },
                        ),
                        _earnCard(
                          context,
                          title: "Withdraw Earnings",
                          subtitle: "Transfer money to bank / UPI",
                          icon: Icons.account_balance,
                          onTap: provider.loadingWriter
                              ? null
                              : () => Navigator.pushNamed(context, "/withdraw"),
                        ),
                        const SizedBox(height: 30),

                        _infoBox(
                            "Writer Earnings: ₹${provider.earn.writerEarnings.toStringAsFixed(2)}"),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  /// SECTION TITLE
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    );
  }

  /// INFO BOX
  Widget _infoBox(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.amber),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.lightText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// EARNING CARD
  static Widget _earnCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
    bool isProcessing = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.amber.withValues(alpha:0.3),
        highlightColor: Colors.transparent,
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              /// ICON or mini loader
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isProcessing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: Colors.amber,
                        ),
                      )
                    : Icon(
                        icon,
                        color: Colors.amber,
                        size: 24,
                      ),
              ),
              const SizedBox(width: 14),

              /// TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.lightText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              /// ARROW
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.lightText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}