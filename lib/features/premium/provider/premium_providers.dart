import 'package:provider/provider.dart';

import 'package:mythica/features/home/mainicon/premium_icon/services/premium_controller.dart';
import 'package:mythica/features/home/mainicon/premium_icon/services/premium_remote_service.dart';
import 'package:mythica/features/home/mainicon/premium_icon/services/premium_repository.dart';

/// 🔹 Remote Service Provider
final premiumRemoteServiceProvider =
    Provider<PremiumRemoteService>(
  create: (_) => PremiumRemoteService(),
);

/// 🔹 Repository Provider
final premiumRepositoryProvider =
    ProxyProvider<PremiumRemoteService, PremiumRepository>(
  update: (_, remoteService, __) => PremiumRepository(remoteService),
);

/// 🔹 Controller Provider
final premiumControllerProvider =
    ChangeNotifierProxyProvider<PremiumRepository, PremiumController>(
  create: (context) =>
      PremiumController(context.read<PremiumRepository>()),
  update: (_, repository, controller) =>
      controller ?? PremiumController(repository),
);