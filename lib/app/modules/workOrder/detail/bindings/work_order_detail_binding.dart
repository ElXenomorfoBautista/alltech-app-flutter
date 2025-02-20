import 'package:get/get.dart';

import '../controllers/work_order_detail_controller.dart';

class WorkOrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkOrderDetailController>(
      () => WorkOrderDetailController(),
    );
  }
}
