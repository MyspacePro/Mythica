

class EarnModel {
  final int readerCoins;
  final double readerCash;
  final double writerEarnings;
  final int totalReads;

  const EarnModel({
    required this.readerCoins,
    required this.readerCash,
    required this.writerEarnings,
    required this.totalReads,
  })  : assert(readerCoins >= 0, 'readerCoins cannot be negative'),
        assert(readerCash >= 0, 'readerCash cannot be negative'),
        assert(writerEarnings >= 0, 'writerEarnings cannot be negative'),
        assert(totalReads >= 0, 'totalReads cannot be negative');

  EarnModel copyWith({
    int? readerCoins,
    double? readerCash,
    double? writerEarnings,
    int? totalReads,
  }) {
    return EarnModel(
      readerCoins: readerCoins ?? this.readerCoins,
      readerCash: readerCash ?? this.readerCash,
      writerEarnings: writerEarnings ?? this.writerEarnings,
      totalReads: totalReads ?? this.totalReads,
    );
  }

  /// Serialization for API / Firestore
  factory EarnModel.fromJson(Map<String, dynamic> json) {
    return EarnModel(
      readerCoins: json['readerCoins'] ?? 0,
      readerCash: (json['readerCash'] ?? 0).toDouble(),
      writerEarnings: (json['writerEarnings'] ?? 0).toDouble(),
      totalReads: json['totalReads'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'readerCoins': readerCoins,
      'readerCash': readerCash,
      'writerEarnings': writerEarnings,
      'totalReads': totalReads,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EarnModel &&
          runtimeType == other.runtimeType &&
          readerCoins == other.readerCoins &&
          readerCash == other.readerCash &&
          writerEarnings == other.writerEarnings &&
          totalReads == other.totalReads;

  @override
  int get hashCode =>
      readerCoins.hashCode ^
      readerCash.hashCode ^
      writerEarnings.hashCode ^
      totalReads.hashCode;
}