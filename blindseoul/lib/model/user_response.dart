class UserResponse {
  final int id;
  final String name;
  final String email;
  final DateTime createdAt;

  UserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
