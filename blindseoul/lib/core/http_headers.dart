// lib/core/http_headers.dart
import 'dart:io';
import 'token_storage.dart';

class HttpHeadersHelper {
  static Future<Map<String, String>> authJson() async {
    final token = await TokenStorage.read();
    return {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.contentTypeHeader: 'application/json',
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
    };
  }

  static Map<String, String> json() => {
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.contentTypeHeader: 'application/json',
  };
}
