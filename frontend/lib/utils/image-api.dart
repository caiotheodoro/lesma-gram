import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:frontend/utils/api.dart';

class UploadImageCall {
  static Future<Map<String, dynamic>?> call({
    String? key = '6d207e02198a847aa98d0a2a901485a5',
    Uint8List? source,
    String? action = 'upload',
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('https://freeimage.host/api/1/upload'));
      request.fields['key'] = key ?? '';
      request.fields['action'] = action ?? '';
      if (source != null) {
        request.files.add(http.MultipartFile.fromBytes('source', source, filename: 'image.jpg'));
      }

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      if (response.statusCode == 200) {
        return json.decode(responseString);
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  static String? imageUrl(Map<String, dynamic>? response) {
    return response?['image']?['url'] as String?;
  }

  static int? success(Map<String, dynamic>? response) {
    return response?['status_code'] as int?;
  }
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list);
  } catch (_) {
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar);
  } catch (_) {
    return isList ? '[]' : '{}';
  }
}
