import '../../users/models/uuser_model.dart';

class AuthResponse {
  final Token token;
  final User user;

  AuthResponse({
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        token: Token.fromJson(json['token']),
        user: User.fromJson(json['user']),
      );
}

class Token {
  final String accessToken;
  final String refreshToken;

  Token({
    required this.accessToken,
    required this.refreshToken,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        accessToken: json['accessToken'] ?? '',
        refreshToken: json['refreshToken'] ?? '',
      );
}

class Tenant {
  final int id;
  final String name;
  final String type;
  final String status;

  Tenant({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) => Tenant(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        type: json['type'] ?? '',
        status: json['status'] ?? '',
      );
}
