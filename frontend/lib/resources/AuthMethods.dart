import 'dart:convert';
import 'package:frontend/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  // Método para obter detalhes do usuário
  Future<User> getUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/users/profile/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(await jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user details');
    }
  }

  Future<String> getIdUserAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/users/profile/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final String id = responseData['id'];
      return id;
    } else {
      throw Exception('Failed to load user details');
    }
  }

// Método de registro de usuário
  Future<String> signUpUser(
      {required String email,
      required String password,
      required String name}) async {
    try {
      print(name);
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        final Map<String, dynamic> body = {
          'email': email,
          'password': password,
          'name': name,
        };

        // Fazer a requisição de registro na API
        final response = await http.post(
          Uri.parse('$apiUrl/users'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );

        if (response.statusCode == 201) {
          return "success";
        } else if (response.statusCode == 400) {
          return "Bad request";
        } else if (response.statusCode == 409) {
          return "Email already in use";
        } else {
          return "Failed to register";
        }
      }
    } catch (err) {
      return err.toString();
    }
    throw Exception('Failed to load user details');
  }

// Método de login do usuário
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Criar o corpo da requisição
        final Map<String, dynamic> body = {
          'email': email,
          'password': password,
        };

        // Fazer a requisição de login na API
        final response = await http.post(
          Uri.parse('$apiUrl/auth'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );

        if (response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          final token = responseData['access_token'];

          // Armazenar o token de autenticação
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', token);

          res = "success";
        } else if (response.statusCode == 401) {
          res = "Wrong password";
        } else if (response.statusCode == 404) {
          res = "No such user";
        } else {
          res = "Failed to login";
        }
      } else {
        res = "Por favor, preencha todos os campos!";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

// Método para fazer logout do usuário
  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }
}
