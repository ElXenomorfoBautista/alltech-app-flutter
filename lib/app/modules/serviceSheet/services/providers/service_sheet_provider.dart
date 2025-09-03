import 'package:get/get.dart';

import '../../../../core/base_provider.dart';

class ServiceSheetProvider extends BaseProvider {
  Future<Response> getServiceSheetsUser() async {
    try {
      return await get('/service-sheets/user');
    } catch (e) {
      return handleError(e);
    }
  }

  Future<Response> create(Map<String, dynamic> data) async {
    try {
      return await post(
        '/service-sheets',
        data,
      );
    } catch (e) {
      return handleError(e);
    }
  }
}
