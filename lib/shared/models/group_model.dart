class GroupModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int membersCount;
  final bool isPrivate;
  final String lastMessage;
  final DateTime lastMessageTime;

  GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.membersCount,
    required this.isPrivate,
    required this.lastMessage,
    required this.lastMessageTime,
  });
}