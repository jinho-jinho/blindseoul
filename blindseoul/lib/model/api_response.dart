class ApiResponse<T> {
  final bool success;
  final T data;
  final String message;

  ApiResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  /// 제네릭 데이터 파싱용 fromJson
  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic) fromData,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      data: fromData(json['data']),
      message: json['message'] ?? '',
    );
  }
}
