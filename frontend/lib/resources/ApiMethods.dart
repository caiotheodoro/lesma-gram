import 'package:frontend/models/PostWithUser.dart';
import 'package:frontend/models/User.dart';
import 'package:frontend/models/UserSetting.dart';
import 'package:frontend/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:frontend/models/Post.dart';

class ApiMethods {
  Future<String> createPost(String image, String content, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    try {
      var response = await http.post(
        Uri.parse('$apiUrl/posts/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(
          {
            'image': image,
            'content': content,
          },
        ),
      );

      if (response.statusCode == 201) {
        return "success";
      } else {
        return "Failed to create post";
      }
    } catch (err) {
      return err.toString();
    }
  }

  Future<List<PostWithUser>> getPosts(String userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');

      var response = await http.get(
        Uri.parse('$apiUrl/posts/listar/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        List<PostWithUser> posts =
            jsonData.map((data) => PostWithUser.fromJson(data)).toList();
        return posts;
      } else {
        throw Exception("Failed to get posts");
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<String> updatePost(String id, String content, String image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    try {
      var response = await http.put(
        Uri.parse('$apiUrl/posts/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(
          {
            'content': content,
            'image': image,
          },
        ),
      );

      if (response.statusCode == 200) {
        return "success";
      } else {
        return "Failed to update post";
      }
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> likePost(String postId, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    try {
      var response = await http.post(
        Uri.parse('$apiUrl/likes'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'postId': postId, 'userId': userId}),
      );

      if (response.statusCode == 200) {
        return "success";
      } else {
        return "Failed to update post";
      }
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> deleteLikePost(String postId, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    try {
      var response = await http.delete(
        Uri.parse('$apiUrl/likes/$postId/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'postId': postId, 'userId': userId}),
      );

      if (response.statusCode == 200) {
        return "success";
      } else {
        return "Failed to delete like";
      }
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> postComment(String postId, String text, String userId,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        var response = await http.post(
          Uri.parse('$apiUrl/comments'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'id': commentId,
            'postId': postId,
            'userId': userId,
            'text': text,
            'profilePic': profilePic,
            'name': name,
            'datePublished': DateTime.now().toIso8601String(),
          }),
        );

        if (response.statusCode == 201) {
          res = "success";
        } else {
          res = "Failed to post comment";
        }
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deletePost(String postId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    try {
      var response = await http.delete(
        Uri.parse('$apiUrl/posts/$postId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        return "success";
      } else {
        return "Failed to update post";
      }
    } catch (err) {
      return err.toString();
    }
  }

  Future<void> followUser(String userId, String followId) async {
    try {
      var response = await http.post(
        Uri.parse('$apiUrl/users/$userId/follow'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'followId': followId}),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to follow/unfollow user");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<User> getUsuarioDetails(String userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');

      var response = await http.get(
        Uri.parse('$apiUrl/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return User.fromJson(jsonResponse);
      } else {
        throw Exception("Failed to get user details");
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<List<User>> getUsersByName(String name) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');

      var response = await http.get(
        Uri.parse('$apiUrl/users/search/$name'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        List<User> users = jsonData.map((data) => User.fromJson(data)).toList();
        return users;
      } else {
        throw Exception("Failed to get users by name");
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<List<Post>> getPostsByUser(String userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');

      var response = await http.get(
        Uri.parse('$apiUrl/posts/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        List<Post> posts = jsonData.map((data) => Post.fromJson(data)).toList();
        return posts;
      } else {
        throw Exception("Failed to get posts by user");
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<List<PostWithUser>> getPostsByUserLiked(String userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');

      var response = await http.get(
        Uri.parse('$apiUrl/posts/liked/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        List<PostWithUser> posts =
            jsonData.map((data) => PostWithUser.fromJson(data)).toList();
        return posts;
      } else {
        throw Exception("Failed to get posts by user liked");
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<String> updateUser(
      String id, String name, String email, String password, bool isAnonymous) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    try {
      var response = await http.put(
        Uri.parse('$apiUrl/users/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(
          {
            'name': name,
            'email': email,
            'password': password,
            'isAnonymous': isAnonymous,
          },
        ),
      );

      if (response.statusCode == 200) {
        return "success";
      } else {
        return "Failed to update user";
      }
    } catch (err) {
      return err.toString();
    }
  }

  Future<UserSettings> getUserSettings(String userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');

      var response = await http.get(
        Uri.parse('$apiUrl/users/settings/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        return UserSettings.fromJson(jsonData);
      } else {
        throw Exception("Failed to get user settings");
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
