import 'package:flutter/widgets.dart';
import 'package:mythica/core/monetization/access_rules.dart';
import 'package:mythica/models/user_model.dart';

class PremiumGuard extends StatelessWidget {
  final AppUser? user;
  final bool isGuest;
  final ContentType contentType;
  final Widget child;
  final Widget? lockedView;

  const PremiumGuard({super.key, this.user, required this.isGuest, required this.contentType, required this.child, this.lockedView});

  @override
  Widget build(BuildContext context) {
    final isPremium = user?.isPremium == true;
    final canAccess = contentType == ContentType.free || (!isGuest && isPremium);
    if (canAccess) return child;
    return lockedView ?? const SizedBox.shrink();
  }
}
