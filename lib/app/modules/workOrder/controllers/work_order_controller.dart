import 'package:get/get.dart';
import '../models/work_order_model.dart';
import '../services/providers/work_order_provider_provider.dart';

class WorkOrderController extends GetxController {
  final WorkOrderProvider _workOrderProvider = Get.find<WorkOrderProvider>();
  final isLoading = false.obs;
  final workOrders = <WorkOrder>[].obs; // Especificamos el tipo
  final errorMessage = ''.obs;
  final isAdmin = true.obs;

  @override
  void onInit() {
    super.onInit();
    getWorkOrdersUser();
  }

  Future<void> getWorkOrdersUser() async {
    try {
      isLoading.value = true;
      final response = await _workOrderProvider.getWorkOrdersUser();

      if (response.status.isOk) {
        final apiResponse = response.body;
        workOrders.value = (apiResponse['data'] as List)
            .map((item) => WorkOrder.fromJson(item))
            .toList();
      } else {
        errorMessage.value =
            response.statusText ?? 'Error al obtener órdenes de trabajo';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshWorkOrders() async {
    await getWorkOrdersUser();
  }

  void deleteWorkOrder(int id) async {
    try {
      // await workOrderService.delete(id);
      await this.refreshWorkOrders();
      Get.snackbar('Éxito', 'Orden eliminada correctamente');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo eliminar la orden');
    }
  }

  void markAsDone(int id) async {
    try {
      await this.refreshWorkOrders();
      Get.snackbar('Éxito', 'Orden completada correctamente');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo aprobar la orden');
    }
  }
}
