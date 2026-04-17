class ContentModel {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime createdAt;
  final bool isDraft;

  ContentModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    required this.isDraft,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "category": category,
      "createdAt": createdAt.toIso8601String(),
      "isDraft": isDraft,
    };
  }

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json["id"],
      title: json["title"],
      content: json["content"],
      category: json["category"],
      createdAt: DateTime.parse(json["createdAt"]),
      isDraft: json["isDraft"],
    );
  }
}