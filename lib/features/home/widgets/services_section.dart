import 'dart:ui';
import 'package:mythica/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:mythica/features/home/widgets/home_services.dart';

class ServicesSection extends StatelessWidget {
  final String title;
  final List<HomeService> services;
  final int? crossAxisCount;

  const ServicesSection({
    Key? key,
    required this.title,
    required this.services,
    this.crossAxisCount,
  }) : super(key: key);

  int _getResponsiveGridColumns(BuildContext context) {
    // Use provided count if given, otherwise determine responsively
    if (crossAxisCount != null) return crossAxisCount!;

    if (context.isMobile) {
      return 4; // 2x2 grid for mobile (showing 4 items)
    } else if (context.isTablet) {
      return 5; // 5 items per row for tablet
    } else {
      return 6; // 6 items per row for desktop
    }
  }

  @override
  Widget build(BuildContext context) {
    final gridColumns = _getResponsiveGridColumns(context);
    final isMobile = context.isMobile;

    // Responsive padding
    final horizontalPadding = isMobile ? 16.0 : 24.0;
    final verticalPadding = isMobile ? 12.0 : 16.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(isMobile ? 14 : 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: const Color(0xFF2F2B4D),
              border: Border.all(
                color: const Color(0xFF3A3A5A),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 15 : 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE2E2E5),
                  ),
                ),

                SizedBox(height: isMobile ? 12 : 16),

                // Services Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: services.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridColumns,
                    mainAxisSpacing: isMobile ? 14 : 18,
                    crossAxisSpacing: isMobile ? 14 : 18,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) {
                    final service = services[index];

                    return _ServiceTile(
                      service: service,
                      isMobile: isMobile,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final HomeService service;
  final bool isMobile;

  const _ServiceTile({
    required this.service,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = isMobile ? 24.0 : 28.0;
    final circleSize = isMobile ? 48.0 : 56.0;
    final innerCircleSize = isMobile ? 38.0 : 44.0;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.pushNamed(context, service.route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Circle
          Container(
            height: circleSize,
            width: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFFFD600),
                width: 2,
              ),
            ),
            child: Center(
              child: Container(
                height: innerCircleSize,
                width: innerCircleSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2B3250),
                ),
                child: Icon(
                  service.icon,
                  size: iconSize,
                  color: const Color(0xFFFFD600),
                ),
              ),
            ),
          ),

          SizedBox(height: isMobile ? 6 : 8),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 6),
            child: Text(
              service.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isMobile ? 10 : 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFE2E2E5),
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}