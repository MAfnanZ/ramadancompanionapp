/*

HTTP Client

*/

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ramadancompanionapp/tools/typedefs.dart';

class HttpClientService {
  final String baseUrl = 'https://api.aladhan.com/v1/';
  final http.Client httpClient = http.Client();

  HttpClientService();

  // helpers
  Uri _uri(String url) => Uri.parse('$baseUrl$url');

  JsonMap _decodeMap(String body) {
    if (body.trim().isEmpty) return <String, dynamic>{};
    final decoded = json.decode(body);
    final decodedData = decoded['data'];
    if (decodedData is JsonMap) {
      return decodedData;
    }
    throw FormatException(
        'Expected JSON object but got ${decoded.runtimeType}');
  }

  List<JsonMap> _decodeList(String body) {
    if (body.trim().isEmpty) return <JsonMap>[];
    final decoded = json.decode(body);

    //ensure decoded is JsonMap
    if (decoded is! Map<String, dynamic>) {
      throw FormatException(
        'Expected root JSON to be a Map but got ${decoded.runtimeType}',
      );
    }

    final decodedData = decoded['data'];
    if (decodedData is List) {
      return decodedData
          .where((item) => item is JsonMap)
          .map((item) => item as JsonMap)
          .toList();
    }
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

  // get return list
  Future<List<JsonMap>> getList(String url) async {
    try {
      final res = await httpClient.get(_uri(url));

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return _decodeList(res.body);
      } else {
        throw Exception(
            "GET LIST failed: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("GET LIST error: $e");
    }
  }

  Future<T> getRaw<T>(String url) async {
    try {
      final res = await httpClient.get(_uri(url));

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return json.decode(res.body) as T;
      } else {
        throw Exception(
            "GET RAW failed: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("GET RAW error: $e");
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
