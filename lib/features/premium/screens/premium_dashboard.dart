import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mythica/features/home/mainicon/premium_icon/services/premium_controller.dart';

class PremiumDashboard extends StatefulWidget {
  const PremiumDashboard({super.key});

  @override
  State<PremiumDashboard> createState() => _PremiumDashboardState();
}

class _PremiumDashboardState extends State<PremiumDashboard> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      final controller = context.read<PremiumController>();

      controller.addListener(() {

        final message = controller.message;

        if (message != null && message.isNotEmpty) {

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(message)),
            );

          controller.clearMessage();
        }

        if (controller.status == PremiumStatus.success) {
          Navigator.of(context).maybePop();
        }
      });

    });
  }

  @override
  Widget build(BuildContext context) {

    final controller = context.watch<PremiumController>();

    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [
              Color(0xFF2A2150),
              Color(0xFF1B1B2F),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  const SizedBox(height: 30),

                  const Text(
                    'Unlock Premium Experience',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Read unlimited. Write without limits.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 40),

                  Container(
                    height: 130,
                    width: 130,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFFD700),
                          Color(0xFFB8860B),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      size: 70,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// FEATURES
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha:0.06),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha:0.08),
                      ),
                    ),
                    child: const Column(
                      children: [
                        _FeatureTile('Unlimited Book Downloads'),
                        _FeatureTile('Ad-Free Reading Experience'),
                        _FeatureTile('Early Access to New Releases'),
                        _FeatureTile('Cloud Backup & Sync'),
                        _FeatureTile('Exclusive Author Analytics'),
                        _FeatureTile('Custom Themes & Fonts'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// PLAN CARD
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF2C2C54),
                          Color(0xFF1F1F3D),
                        ],
                      ),
                      border: Border.all(
                        color: const Color(0xFFFFD700).withValues(alpha:0.4),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monthly Plan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₹199/month',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₹1499/year',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Cancel anytime • Save 20%',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// BUTTON
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF8E2DE2),
                          Color(0xFFFFD700),
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: controller.isProcessing
                          ? null
                          : () => context
                              .read<PremiumController>()
                              .startTrial(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: controller.isProcessing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Start 7-Day Free Trial',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final String title;

  const _FeatureTile(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFFFFD700),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}