import 'package:dio/dio.dart';
import '../model/blindwalk_dto.dart';

class BlindwalkApi {
  final Dio _dio = Dio();

  // Future<List<BlindwalkDto>> fetchBlindwalkLocations() async {
  //   final response = await _dio.get('http://192.168.0.31:8080/blindwalk/all');

  //   List<dynamic> body = response.data;
  //   return body.map((e) => BlindwalkDto.fromJson(e)).toList();
  // }

  Future<List<BlindwalkDto>> fetchNearbyBlindwalkLocations({
    required double userLat,
    required double userLon,
    double radiusKm = 0.5,
  }) async {
    final response = await _dio.get(
      'http://192.168.0.15:8080/blindwalk/nearby',
      queryParameters: {
        'lat': userLat,
        'lon': userLon,
        'radius': radiusKm,
      },
    );

    List<dynamic> body = response.data;
    return body.map((e) => BlindwalkDto.fromJson(e)).toList();
  }

}
