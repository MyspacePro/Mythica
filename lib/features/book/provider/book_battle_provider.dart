import 'dart:async';
import 'package:mythica/features/home/mainicon/book_battle_icon/models/battle_book_model.dart' show BattleBook;
import 'package:flutter/material.dart';
import '../services/book_battle_service.dart';

class BookBattleProvider extends ChangeNotifier {

  final BookBattleService _service = BookBattleService();

  BattleBook? leftBook;
  BattleBook? rightBook;

  double leftVotePercent = 0.5;
  double rightVotePercent = 0.5;

  int secondsLeft = 10;

  Timer? _timer;

  bool isLoading = true;

  Future<void> loadBattle() async {

    isLoading = true;
    notifyListeners();

    final books = await _service.fetchBattleBooks();

    leftBook = books[0];
    rightBook = books[1];

    startTimer();

    isLoading = false;
    notifyListeners();
  }

  void startTimer() {

    secondsLeft = 10;

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {

      if (secondsLeft == 0) {
        timer.cancel();
      } else {
        secondsLeft--;
        notifyListeners();
      }

    });
  }

  void voteLeft() {

    if (secondsLeft == 0) return;

    leftVotePercent += 0.02;
    rightVotePercent -= 0.02;

    notifyListeners();
  }

  void voteRight() {

    if (secondsLeft == 0) return;

    rightVotePercent += 0.02;
    leftVotePercent -= 0.02;

    notifyListeners();
  }

  void nextBattle() {

    leftVotePercent = 0.5;
    rightVotePercent = 0.5;

    loadBattle();
  }

  @override
  void dispose() {

    _timer?.cancel();

    super.dispose();
  }
}