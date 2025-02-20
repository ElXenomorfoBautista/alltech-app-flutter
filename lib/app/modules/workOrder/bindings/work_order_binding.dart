import 'package:alltech_app/app/modules/workOrder/services/providers/work_order_provider_provider.dart';
import 'package:get/get.dart';

import '../controllers/work_order_controller.dart';

class WorkOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkOrderProvider>(() => WorkOrderProvider());

    Get.lazyPut<WorkOrderController>(
      () => WorkOrderController(),
    );
  }
}
