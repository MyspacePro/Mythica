import 'dart:async';
import 'package:mythica/features/reader/widgets/reader_bottom_bar.dart' show ReaderBottomBar;
import 'package:mythica/features/reader/widgets/reader_top_bar.dart' show ReaderTopBar;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/reader_provider.dart';

class ReaderControlsOverlay extends StatefulWidget {
  final Widget child;

  const ReaderControlsOverlay({super.key, required this.child});

  @override
  State<ReaderControlsOverlay> createState() => _ReaderControlsOverlayState();
}

class _ReaderControlsOverlayState extends State<ReaderControlsOverlay> {
  Timer? _hideTimer;

  void _startHideTimer(ReaderProvider provider) {
    _hideTimer?.cancel();

    _hideTimer = Timer(const Duration(seconds: 3), () {
      provider.toggleControls();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReaderProvider>(
      builder: (context, provider, _) {
        return GestureDetector(
          onTap: () {
            provider.toggleControls();

            if (provider.showControls) {
              _startHideTimer(provider);
            }
          },
          child: Stack(
            children: [
              widget.child,

              if (provider.showControls) ...[
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ReaderTopBar(),
                ),
                const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ReaderBottomBar(),
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}