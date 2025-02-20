import 'dart:developer';

import 'package:get/get.dart';
import '../routes/app_pages.dart';
import '../services/storage_service.dart';

abstract class BaseProvider extends GetConnect {
  final StorageService _storage = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = 'http://localhost:3000';
    setupInterceptors();
  }

  void setupInterceptors() {
    // Interceptor para headers
    httpClient.addRequestModifier<dynamic>((request) async {
      request.headers['Content-Type'] = 'application/json';
      request.headers['accept'] = '*/*';

      final token = _storage.getAccessToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    // Interceptor para refresh token
    httpClient.addResponseModifier((request, response) async {
      if (response.statusCode == 401 &&
          (!request.url.path.contains('/logout') ||
              !request.url.path.contains('/auth/token-refresh'))) {
        final refreshToken = _storage.getRefreshToken();
        if (refreshToken != null) {
          try {
            final refreshResponse = await this.refreshToken();
            if (refreshResponse.status.isOk) {
              final newResponse = await httpClient.request(
                request.url.path,
                request.method,
                headers: {
                  ...request.headers,
                  'Authorization': 'Bearer ${_storage.getAccessToken()}'
                },
              );
              return newResponse;
            }
          } catch (e) {
            log("Error en el intercetor");
            await _storage.clearTokens();
            Get.offAllNamed(Routes.AUTH_LOGIN);
          }
        } else {
          log("Logout desde el interceptor");
          await _storage.clearTokens();
          Get.offAllNamed(Routes.AUTH_LOGIN);
        }
      }
      return response;
    });
  }

  Future<Response> refreshToken() async {
    final currentRefreshToken = _storage.getRefreshToken();

    if (currentRefreshToken == null) {
      return Response(
        statusCode: 401,
        statusText: 'No hay refresh token disponible',
      );
    }

    try {
      final response = await post(
        '/auth/token-refresh',
        {'refreshToken': currentRefreshToken},
      );

      if (response.status.isOk) {
        final userId = await _storage.getCurrentUserId();
        await _storage.saveTokens(
            accessToken: response.body['accessToken'],
            refreshToken: response.body['refreshToken'],
            userId: userId!);
        return response;
      } else {
        await _storage.clearTokens();
        Get.offAllNamed(Routes.AUTH_LOGIN);
        return response;
      }
    } catch (e) {
      log(e.toString());
      return Response(
        statusCode: 500,
        statusText: 'Error al refrescar token: $e',
      );
    }
  }

  // Método helper para manejar errores
  Response handleError(dynamic e) {
    return Response(
      statusCode: 500,
      statusText: 'Error de conexión: $e',
    );
  }
}
