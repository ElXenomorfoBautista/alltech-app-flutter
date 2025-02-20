import 'package:get/get.dart';

import '../../../../core/base_provider.dart';

class ItemTypeProvider extends BaseProvider {
  Future<Response> getItemTypes() async {
    try {
      return await get('/items-types');
    } catch (e) {
      return handleError(e);
    }
  }
}
