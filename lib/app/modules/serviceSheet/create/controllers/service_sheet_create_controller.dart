import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../users/models/uuser_model.dart';
import '../../../users/services/providers/user_service_provider.dart';
import '../../../workOrder/models/work_order_item_model.dart';
import '../../../workOrder/models/work_order_model.dart';
import '../../../workOrder/services/providers/work_order_provider_provider.dart';
import '../../services/providers/service_sheet_provider.dart';

class ServiceSheetCreateController extends GetxController {
  // Providers
  final WorkOrderProvider _workOrderProvider = Get.find<WorkOrderProvider>();
  final UserProvider _userProvider = Get.find<UserProvider>();
  final ServiceSheetProvider _serviceSheetProvider =
      Get.find<ServiceSheetProvider>();

  final workOrderId = Rxn<int>();
  final tenantId = 1.obs;
  final priority = Rxn<int>();
  final executionResponsibleId = Rxn<int>();
  final approvalResponsibleId = Rxn<int>();

  final workOrders = <WorkOrder>[].obs;
  final users = <User>[].obs;
  final availableItems = <WorkOrderItem>[].obs;
  final selectedItemIds = <int>{}.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        loadWorkOrders(),
        loadUsers(),
      ]);
    } catch (e) {
      errorMessage.value = 'Error al cargar datos iniciales: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadWorkOrders() async {
    try {
      final response = await _workOrderProvider.getWorkOrdersUser();
      if (response.status.isOk) {
        final apiResponse = response.body;
        workOrders.value = (apiResponse['data'] as List)
            .map((item) => WorkOrder.fromJson(item))
            .toList();
      } else {
        throw 'Error al obtener órdenes de trabajo';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> loadUsers() async {
    try {
      final response = await _userProvider.getUsers();
      if (response.status.isOk) {
        users.value =
            (response.body as List).map((item) => User.fromJson(item)).toList();
      } else {
        throw 'Error al obtener usuarios';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onWorkOrderSelected(int id) async {
    try {
      isLoading.value = true;
      workOrderId.value = id;
      final response = await _workOrderProvider.getWorkOrderById(id);

      if (response.status.isOk) {
        final workOrder = WorkOrder.fromJson(response.body['data']);
        availableItems.value = workOrder.workOrderItems ?? [];
        selectedItemIds.clear();
      } else {
        throw 'Error al obtener detalles de la orden';
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

  void toggleItem(WorkOrderItem item) {
    if (item.id == null) return;

    if (selectedItemIds.contains(item.id)) {
      selectedItemIds.remove(item.id);
    } else {
      selectedItemIds.add(item.id!);
    }
  }

  bool validateForm() {
    if (workOrderId.value == null) {
      Get.snackbar('Error', 'Seleccione una orden de trabajo');
      return false;
    }
    if (priority.value == null) {
      Get.snackbar('Error', 'Seleccione una prioridad');
      return false;
    }
    if (executionResponsibleId.value == null) {
      Get.snackbar('Error', 'Seleccione un responsable de ejecución');
      return false;
    }
    if (approvalResponsibleId.value == null) {
      Get.snackbar('Error', 'Seleccione un responsable de aprobación');
      return false;
    }
    if (selectedItemIds.isEmpty) {
      Get.snackbar('Error', 'Seleccione al menos un item');
      return false;
    }
    return true;
  }

  Future<void> submit() async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;

      final serviceSheet = {
        'workOrderId': workOrderId.value,
        'tenantId': tenantId.value,
        'statusId': 1,
        'priority': priority.value,
        'executionResponsibleId': executionResponsibleId.value,
        'approvalResponsibleId': approvalResponsibleId.value,
        'serviceSheetItems':
            selectedItemIds.map((id) => {'workOrderItemId': id}).toList(),
      };

      final response = await _serviceSheetProvider.create(serviceSheet);

      if (response.status.isOk) {
        Get.back();
        Get.snackbar(
          'Éxito',
          'Hoja de servicio creada exitosamente',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw response.body['message'] ?? 'Error al crear hoja de servicio';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      Get.snackbar('Error', errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
