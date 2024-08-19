class PostWithUser {
  final String postId;
  final String content;
  final String image;
  final DateTime createdAt;
  final String userId;
  final String name;
  final bool isLiked;

  PostWithUser({
    required this.postId,
    required this.content,
    required this.image,
    required this.createdAt,
    required this.userId,
    required this.name,
    this.isLiked = false,
  });

  factory PostWithUser.fromJson(Map<String, dynamic> json) {
    return PostWithUser(
      postId: json['postId'],
      content: json['content'],
      image: json['image'],
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['userId'],
      name: json['name'],
      isLiked: json['isLiked'],
    );
  }
}
