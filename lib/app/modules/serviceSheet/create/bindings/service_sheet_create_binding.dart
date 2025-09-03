import 'package:alltech_app/app/modules/users/services/providers/user_service_provider.dart';
import 'package:get/get.dart';

import '../../../workOrder/services/providers/work_order_provider_provider.dart';
import '../../services/providers/service_sheet_provider.dart';
import '../controllers/service_sheet_create_controller.dart';

class ServiceSheetCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServiceSheetProvider());
    Get.lazyPut(() => WorkOrderProvider());
    Get.lazyPut(() => UserProvider());

    Get.lazyPut<ServiceSheetCreateController>(
      () => ServiceSheetCreateController(),
    );
  }
}
