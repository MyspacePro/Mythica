import 'premium_remote_service.dart';

class PremiumRepository {
  final PremiumRemoteService remoteService;
  PremiumRepository(this.remoteService);

  Future<void> startTrial() => remoteService.startTrial();
}
