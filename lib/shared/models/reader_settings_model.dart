class ReaderSettingsModel {

  /// ===============================
  /// FONT SETTINGS
  /// ===============================

  final double fontSize;
  final double lineHeight;
  final String fontFamily;

  /// ===============================
  /// THEME SETTINGS
  /// ===============================

  final bool darkMode;
  final bool sepiaMode;

  /// ===============================
  /// PAGE SETTINGS
  /// ===============================

  final bool pageSnap;
  final bool showPageNumber;

  /// ===============================
  /// CONSTRUCTOR
  /// ===============================

  const ReaderSettingsModel({
    this.fontSize = 18,
    this.lineHeight = 1.6,
    this.fontFamily = "Default",
    this.darkMode = true,
    this.sepiaMode = false,
    this.pageSnap = false,
    this.showPageNumber = true,
  });

  /// ===============================
  /// COPY WITH
  /// ===============================

  ReaderSettingsModel copyWith({
    double? fontSize,
    double? lineHeight,
    String? fontFamily,
    bool? darkMode,
    bool? sepiaMode,
    bool? pageSnap,
    bool? showPageNumber,
  }) {
    return ReaderSettingsModel(
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      fontFamily: fontFamily ?? this.fontFamily,
      darkMode: darkMode ?? this.darkMode,
      sepiaMode: sepiaMode ?? this.sepiaMode,
      pageSnap: pageSnap ?? this.pageSnap,
      showPageNumber: showPageNumber ?? this.showPageNumber,
    );
  }

  /// ===============================
  /// SERIALIZATION
  /// ===============================

  Map<String, dynamic> toJson() {
    return {
      'fontSize': fontSize,
      'lineHeight': lineHeight,
      'fontFamily': fontFamily,
      'darkMode': darkMode,
      'sepiaMode': sepiaMode,
      'pageSnap': pageSnap,
      'showPageNumber': showPageNumber,
    };
  }

  factory ReaderSettingsModel.fromJson(Map<String, dynamic> json) {
    return ReaderSettingsModel(
      fontSize: (json['fontSize'] ?? 18).toDouble(),
      lineHeight: (json['lineHeight'] ?? 1.6).toDouble(),
      fontFamily: json['fontFamily'] ?? "Default",
      darkMode: json['darkMode'] ?? true,
      sepiaMode: json['sepiaMode'] ?? false,
      pageSnap: json['pageSnap'] ?? false,
      showPageNumber: json['showPageNumber'] ?? true,
    );
  }

  /// ===============================
  /// DEFAULT SETTINGS
  /// ===============================

  factory ReaderSettingsModel.defaultSettings() {
    return const ReaderSettingsModel();
  }

  /// ===============================
  /// DEBUG
  /// ===============================

  @override
  String toString() {
    return '''
ReaderSettingsModel(
  fontSize: $fontSize
  lineHeight: $lineHeight
  darkMode: $darkMode
  sepiaMode: $sepiaMode
)
''';
  }
}