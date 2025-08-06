class ErrorResponse {
  final int status;
  final String error;
  final String message;
  final DateTime timestamp;

  ErrorResponse({
    required this.status,
    required this.error,
    required this.message,
    required this.timestamp,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      status: json['status'],
      error: json['error'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
