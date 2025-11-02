import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video_chat_demo/core/app_constants.dart';

class ApiClient {
  final String baseUrl;
  final http.Client _client;

  ApiClient({required this.baseUrl , http.Client? client})
      : _client = client ?? http.Client();

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    String url = '$baseUrl/$path' ;

    final res = await _client.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': AppConstants.REQ_RES_API_ID,
        },
        body: jsonEncode(body));

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('API error: ${res.statusCode} ${res.body}');
    }
  }

  Future<Map<String, dynamic>> get(String path) async {
    String url = '$baseUrl/$path' ;

    final res = await _client.get(Uri.parse(url),headers: {
      'Content-Type': 'application/json',
      'x-api-key': AppConstants.REQ_RES_API_ID,
    },);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('API error: ${res.statusCode} ${res.body}');
    }
  }
}
