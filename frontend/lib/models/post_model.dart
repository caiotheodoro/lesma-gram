import 'dart:convert';

List<PostModel> postModelFromJson(String str) => List<PostModel>.from(json.decode(str).map((x) => PostModel.fromJson(x)));

String postModelToJson(List<PostModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostModel {
  PostModel({
    required this.id,
    required this.content,
    required this.image,
    required this.userId,
  });

  int id;
  String content;
  String image;
  int userId;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json["id"],
    content: json["content"],
    image: json["image"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "todo_id": id,
    "content": content,
    "image": image,
    "userId": userId
  };
}