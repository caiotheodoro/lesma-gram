class UserSettings {
  final String id;
  final String userId;
  final bool isAnonymous;
  final bool showPicture;
  final bool storyPosts;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserSettings({
    required this.id,
    required this.userId,
    this.isAnonymous = false,
    this.showPicture = true,
    this.storyPosts = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // Converter de JSON para UserSettings
  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      id: json['id'],
      userId: json['userId'],
      isAnonymous: json['isAnonymous'],
      showPicture: json['showPicture'],
      storyPosts: json['storyPosts'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Converter de UserSettings para JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'isAnonymous': isAnonymous,
    'showPicture': showPicture,
    'storyPosts': storyPosts,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
