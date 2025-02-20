import 'package:alltech_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

import '../../../../core/base_provider.dart';
import '../../../../services/storage_service.dart';
import '../../models/auth_response.dart';

class ErrorResponse {
  final int statusCode;
  final String name;
  final dynamic message;

  ErrorResponse({
    required this.statusCode,
    required this.name,
    required this.message,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    final error = json['error'];
    return ErrorResponse(
      statusCode: error['statusCode'],
      name: error['name'],
      message: error['message'],
    );
  }

  String get errorMessage {
    if (message is Map) {
      return message['message'] ?? 'Error desconocido';
    }
    return message?.toString() ?? 'Error desconocido';
  }
}

class AuthServiceProvider extends BaseProvider {
  Future<Response> login({
    required String username,
    required String password,
    required String clientId,
    required String clientSecret,
    bool rememberSession = false,
  }) async {
    try {
      final response = await post(
        '/auth/login/user',
        {
          'client_id': clientId,
          'client_secret': clientSecret,
          'username': username,
          'password': password,
        },
      );

      if (response.status.isOk) {
        await Get.find<StorageService>().saveTokens(
          accessToken: response.body['token']['accessToken'],
          refreshToken: response.body['token']['refreshToken'],
          userId: response.body['user']['id'],
          rememberSession: rememberSession,
        );
        return Response(
          statusCode: response.statusCode,
          statusText: response.statusText,
          body: AuthResponse.fromJson(response.body),
        );
      } else {
        final errorResponse = ErrorResponse.fromJson(response.body);
        return Response(
          statusCode: response.statusCode,
          statusText: errorResponse.errorMessage,
          body: response.body,
        );
      }
    } catch (e) {
      return handleError(e);
    }
  }

  Future<Response> logout() async {
    try {
      final response = await post('/logout', null);

      if (response.status.isOk) {
        await Get.find<StorageService>().clearTokens();
        Get.offAllNamed(Routes.AUTH_LOGIN);
        return Response(
          statusCode: response.statusCode,
          statusText: response.statusText,
        );
      } else {
        final errorResponse = ErrorResponse.fromJson(response.body);
        return Response(
          statusCode: response.statusCode,
          statusText: errorResponse.errorMessage,
          body: response.body,
        );
      }
    } catch (e) {
      return handleError(e);
    }
  }
}
