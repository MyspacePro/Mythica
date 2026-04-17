import 'package:flutter/foundation.dart';

/// 🔥 TRANSACTION TYPE ENUM
enum TransactionType {
  earn,
  convert,
  withdraw,
}

/// 🔥 COIN TRANSACTION MODEL (PRODUCTION READY)
@immutable
class CoinTransaction {
  final TransactionType type;
  final int coins;        // used for earn / convert
  final double cash;      // used for convert / withdraw
  final DateTime date;

  const CoinTransaction({
    required this.type,
    this.coins = 0,
    this.cash = 0.0,
    required this.date,
  });

  /// 🔁 FACTORY: EARN COINS
  factory CoinTransaction.earn({
    required int coins,
  }) {
    return CoinTransaction(
      type: TransactionType.earn,
      coins: coins,
      date: DateTime.now(),
    );
  }

  /// 🔁 FACTORY: CONVERT COINS → CASH
  factory CoinTransaction.convert({
    required int coins,
    required double cash,
  }) {
    return CoinTransaction(
      type: TransactionType.convert,
      coins: coins,
      cash: cash,
      date: DateTime.now(),
    );
  }

  /// 🔁 FACTORY: WITHDRAW CASH
  factory CoinTransaction.withdraw({
    required double cash,
  }) {
    return CoinTransaction(
      type: TransactionType.withdraw,
      cash: cash,
      date: DateTime.now(),
    );
  }

  /// 🔁 COPY WITH
  CoinTransaction copyWith({
    TransactionType? type,
    int? coins,
    double? cash,
    DateTime? date,
  }) {
    return CoinTransaction(
      type: type ?? this.type,
      coins: coins ?? this.coins,
      cash: cash ?? this.cash,
      date: date ?? this.date,
    );
  }

  /// 🔁 TO JSON (for Firestore / storage)
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'coins': coins,
      'cash': cash,
      'date': date.toIso8601String(),
    };
  }

  /// 🔁 FROM JSON
  factory CoinTransaction.fromJson(Map<String, dynamic> json) {
    return CoinTransaction(
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.earn,
      ),
      coins: (json['coins'] ?? 0) as int,
      cash: (json['cash'] ?? 0).toDouble(),
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
    );
  }
}