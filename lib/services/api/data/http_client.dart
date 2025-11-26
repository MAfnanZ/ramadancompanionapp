/*

HTTP Client

*/

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ramadancompanionapp/typedefs.dart';

class HttpClientService {
  final String baseUrl = 'https://api.aladhan.com/v1/';
  final http.Client httpClient = http.Client();

  HttpClientService();

  // helpers
  Uri _uri(String url) => Uri.parse('$baseUrl$url');

  JsonMap _decodeMap(String body) {
    if (body.trim().isEmpty) return <String, dynamic>{};
    final decoded = json.decode(body);
    if (decoded is Map<String, dynamic>) return decoded;
    throw FormatException(
        'Expected JSON object but got ${decoded.runtimeType}');
  }

  // get return map
  Future<JsonMap> getMap(String url) async {
    try {
      final res = await httpClient.get(_uri(url));

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return _decodeMap(res.body);
      } else {
        throw Exception(
            "GET MAP failed: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("GET MAP error: $e");
    }
  }

  void dispose() => httpClient.close();
}

// clear error
class HttpException implements Exception {
  final String message;
  final Uri? uri;
  HttpException(this.message, {this.uri});

  @override
  String toString() =>
      'HttpException: $message${uri != null ? ' (uri: $uri)' : ''}';
}
