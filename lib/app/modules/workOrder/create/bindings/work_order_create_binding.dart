import 'package:get/get.dart';

import '../../../users/services/providers/user_service_provider.dart';
import '../../services/providers/item_type_provider_provider.dart';
import '../../services/providers/work_order_provider_provider.dart';
import '../../services/providers/work_order_type_provider_provider.dart';
import '../controllers/work_order_create_controller.dart';

class WorkOrderCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkOrderProvider>(() => WorkOrderProvider());

    Get.lazyPut<WorkOrderTypeProvider>(() => WorkOrderTypeProvider());
    Get.lazyPut<ItemTypeProvider>(() => ItemTypeProvider());
    Get.lazyPut<UserProvider>(() => UserProvider());

    Get.lazyPut<WorkOrderCreateController>(
      () => WorkOrderCreateController(),
    );
  }
}
