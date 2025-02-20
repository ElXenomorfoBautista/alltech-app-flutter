import 'package:get/get.dart';

import '../../models/work_order_model.dart';

class WorkOrderDetailController extends GetxController {
  final workOrder = Rxn<WorkOrder>();

  @override
  void onInit() {
    super.onInit();
    workOrder.value = Get.arguments['workOrder'];
  }

  double calculateTotal() {
    return workOrder.value?.workOrderItems?.fold(0.0, (sum, item) {
          return sum! + (item.price ?? 0) * item.quantity;
        }) ??
        0.0;
  }
}
