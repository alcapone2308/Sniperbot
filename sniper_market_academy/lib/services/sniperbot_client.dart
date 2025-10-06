import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class SniperBotClient {
  static Future<Map<String, dynamic>> sendFileImage(File imageFile) async {
    final uri = Uri.parse('http://37.60.229.117:8000/upload');

    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path))
      ..fields['texte_ocr'] = 'Gold 2343.91'; // 🔥 à remplacer par un vrai OCR plus tard

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur ${response.statusCode} : ${response.reasonPhrase}');
    }
  }
}
