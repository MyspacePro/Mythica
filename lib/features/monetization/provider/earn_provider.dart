import 'package:flutter/material.dart';
import '../models/earn_model.dart';
import '../services/earn_service.dart';

class EarnProvider extends ChangeNotifier {
  final EarnService _service = EarnService();

  EarnModel _earn = const EarnModel(
    readerCoins: 0,
    readerCash: 0,
    writerEarnings: 0,
    totalReads: 0,
  );

  // Track per-action loading
  bool _loadingReader = false;
  bool _loadingWriter = false;

  String? _error;

  EarnModel get earn => _earn;
  bool get loadingReader => _loadingReader;
  bool get loadingWriter => _loadingWriter;
  String? get error => _error;

  Future<void> load() async {
    _error = null;
    try {
      _earn = await _service.fetchEarnings();
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  Future<void> addReaderCoins(int pagesRead) async {
    _loadingReader = true;
    _error = null;
    notifyListeners();

    try {
      _earn = await _service.addReaderCoins(_earn, pagesRead);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loadingReader = false;
      notifyListeners();
    }
  }

  Future<void> addWriterChapterReads(int chapters) async {
    _loadingWriter = true;
    _error = null;
    notifyListeners();

    try {
      _earn = await _service.addWriterChapterReads(_earn, chapters);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loadingWriter = false;
      notifyListeners();
    }
  }
}