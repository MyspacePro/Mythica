class UserModel {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final bool isOnline;
  final DateTime lastSeen;
  final String bio;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.isOnline,
    required this.lastSeen,
    required this.bio,
  });
}