import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/blindwalk_dto.dart';
import '../model/api_response.dart';
import '../model/error_response.dart';

class BlindwalkApi {
  //final String _baseUrl = 'http://192.168.0.15:8080';
  final String _baseUrl = 'http://172.30.1.37:8080';
  Future<List<BlindwalkDto>> fetchNearbyBlindwalkLocations({
    required double userLat,
    required double userLon,
    double radiusKm = 0.5,
  }) async {
    final uri = Uri.parse('$_baseUrl/blindwalk/nearby').replace(queryParameters: {
      'lat': userLat.toString(),
      'lon': userLon.toString(),
      'radius': radiusKm.toString(),
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final apiResponse = ApiResponse<List<BlindwalkDto>>.fromJson(
        json,
        (data) => (data as List)
            .map((e) => BlindwalkDto.fromJson(e))
            .toList(),
      );

      return apiResponse.data;
    } else {
      // 실패 응답 처리
      final json = jsonDecode(response.body);
      final error = ErrorResponse.fromJson(json);
      throw Exception('유도블록 조회 실패: ${error.message}');
    }
  }
}
