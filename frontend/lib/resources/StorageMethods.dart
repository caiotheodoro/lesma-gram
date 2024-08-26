import 'dart:typed_data';
import 'package:frontend/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class StorageMethods {
  // Método para fazer upload de imagem para o storage
  Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {
    try {
      String userId = 'your_user_id'; // Substitua com o ID do usuário, pode ser passado como parâmetro se necessário.

      String fileName = childName;
      if (isPost) {
        String id = const Uuid().v1();
        fileName = '$fileName/$id';
      }

      // Constrói o request de multipart
      var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/upload'));
      request.fields['userId'] = userId;
      request.fields['fileName'] = fileName;
      request.files.add(http.MultipartFile.fromBytes('file', file, filename: fileName));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        return responseData; // Espera que a API retorne a URL do arquivo
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Método para obter a URL da imagem
  Future<String> getImageUrl(String imageId) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/image/$imageId'));

      if (response.statusCode == 200) {
        return response.body; // Espera que a API retorne a URL da imagem
      } else {
        throw Exception('Failed to get image URL');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Método para obter a URL do post
  Future<String> postUrl(String postId) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/post/$postId'));

      if (response.statusCode == 200) {
        return response.body; // Espera que a API retorne a URL do post
      } else {
        throw Exception('Failed to get post URL');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
