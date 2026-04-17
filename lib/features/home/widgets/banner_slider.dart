import 'dart:async';
import 'package:mythica/core/utils/responsive_helper.dart';
import 'package:mythica/core/utils/asset_helper.dart';
import 'package:flutter/material.dart';

class BannerSlider extends StatefulWidget {
  final List<String> banners;

  const BannerSlider({
    super.key,
    required this.banners,
  });

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_controller.hasClients) {
        _currentIndex = (_currentIndex + 1) % widget.banners.length;

        _controller.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = context.isMobile;

    // Responsive banner height
    late final double bannerHeight;
    late final double indicatorSize;

    if (isMobile) {
      bannerHeight = 160;
      indicatorSize = 6;
    } else if (context.isTablet) {
      bannerHeight = 200;
      indicatorSize = 8;
    } else {
      bannerHeight = 250;
      indicatorSize = 10;
    }

    return Column(
      children: [
        // Banner container
        Container(
          height: bannerHeight,
          margin: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.banners.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                return AssetHelper.loadImage(
                  assetPath: widget.banners[index],
                  width: screenWidth,
                  height: bannerHeight,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Indicator dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: indicatorSize,
              width: _currentIndex == index ? 20 : indicatorSize,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? Colors.white
                    : Colors.white38,
                borderRadius: BorderRadius.circular(indicatorSize / 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}