class Post {
  final String id;
  final String content;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userId;

  const Post({
    required this.id,
    required this.content,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      content: json['content'],
      image: json['image'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'image': image,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'userId': userId,
  };
}
