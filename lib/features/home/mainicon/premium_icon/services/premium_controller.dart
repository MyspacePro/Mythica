import 'package:flutter/foundation.dart';
import 'premium_repository.dart';

enum PremiumStatus { idle, loading, success, error }

class PremiumController extends ChangeNotifier {
  final PremiumRepository _repository;
  PremiumController(this._repository);

  PremiumStatus _status = PremiumStatus.idle;
  String? _message;

  PremiumStatus get status => _status;
  String? get message => _message;
  bool get isProcessing => _status == PremiumStatus.loading;

  Future<void> startTrial() async {
    _status = PremiumStatus.loading;
    _message = null;
    notifyListeners();
    try {
      await _repository.startTrial();
      _status = PremiumStatus.success;
      _message = 'Trial started successfully';
    } catch (_) {
      _status = PremiumStatus.error;
      _message = 'Unable to start trial';
    }
    notifyListeners();
  }

  void clearMessage() {
    _message = null;
    notifyListeners();
  }
}
