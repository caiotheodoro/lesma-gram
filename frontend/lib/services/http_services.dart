import 'dart:convert';

import 'package:frontend/models/post_model.dart';
import 'package:http/http.dart' as http;

class HttpServices {
  Future<List<PostModel>> getAllPosts() async {
    var response = await http.get(Uri.parse("http://127.0.0.1:3025/posts"));
    var postsBody = jsonDecode(response.body);
    List<PostModel> posts = [];
    for (var t in postsBody) {
      print(t);
      PostModel post = await PostModel(
          id: int.parse(t['id'].toString()),
          content: t['content'],
          image: t['image'],
          userId: int.parse(t['userid'].toString())
      );
      print(post);
      posts.add(post);
    }
    return posts;
  }

  void createPost(PostModel post) async {
    var response = await http.post(Uri.parse("http://127.0.0.1:3025/posts"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"content": post.content, "image": post.image, "userId": 1}));
    print(response.statusCode);
  }

  void updatePost(PostModel post) async {
    var response = await http.put(Uri.parse("http://127.0.0.1:3025/posts/${post.id}"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"content": post.content, "image": post.image, "userId": 1}));
    print(response.statusCode);
  }

  void deletePost(PostModel post) async {
    var response = await http.delete(Uri.parse("http://127.0.0.1:3025/posts/${post.id}"));
    print(response.statusCode);
  }
}