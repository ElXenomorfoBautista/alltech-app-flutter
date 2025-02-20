import 'package:get/get.dart';

import '../../../../core/base_provider.dart';

class WorkOrderTypeProvider extends BaseProvider {
  Future<Response> getWorkOrderTypes() async {
    try {
      return await get('/work-orders-types');
    } catch (e) {
      return handleError(e);
    }
  }
}
