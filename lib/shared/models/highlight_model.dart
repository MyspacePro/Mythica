class HighlightModel {

  final String id;
  final String bookId;
  final String text;
  final int page;
  final int startOffset;
  final int endOffset;
  final String color;
  final DateTime createdAt;

  const HighlightModel({
    required this.id,
    required this.bookId,
    required this.text,
    required this.page,
    required this.startOffset,
    required this.endOffset,
    required this.color,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "bookId": bookId,
      "text": text,
      "page": page,
      "startOffset": startOffset,
      "endOffset": endOffset,
      "color": color,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  factory HighlightModel.fromJson(Map<String, dynamic> json) {
    return HighlightModel(
      id: json["id"],
      bookId: json["bookId"],
      text: json["text"],
      page: json["page"],
      startOffset: json["startOffset"],
      endOffset: json["endOffset"],
      color: json["color"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}