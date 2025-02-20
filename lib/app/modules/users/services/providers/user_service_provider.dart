import 'package:get/get.dart';

import '../../../../core/base_provider.dart';
import '../../../../core/models/api_response.dart';
import '../../models/uuser_model.dart';

class UserProvider extends BaseProvider {
  Future<Response> getUsers() async {
    try {
      return await get('/users');
    } catch (e) {
      return handleError(e);
    }
  }

  Future<Response> getUserProfile(int userId) async {
    try {
      final response = await get('/users/$userId');

      if (response.status.isOk) {
        final apiResponse = ApiResponse<User>(
          statusCode: response.body['statusCode'],
          message: response.body['message'],
          data: User.fromJson(response.body['data']),
        );

        return Response(
          statusCode: response.statusCode,
          statusText: response.statusText,
          body: apiResponse,
        );
      } else {
        final apiResponse = ApiResponse<User>(
          statusCode: response.statusCode ?? 500,
          message: response.body['message'] ?? 'Error',
          error: response.body['error'],
        );

        return Response(
          statusCode: response.statusCode ?? 500,
          statusText: response.body['message'] ?? 'Error',
          body: apiResponse,
        );
      }
    } catch (e) {
      return handleError(e);
    }
  }
}
