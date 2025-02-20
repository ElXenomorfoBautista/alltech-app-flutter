import 'dart:convert';

import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../users/models/uuser_model.dart';
import '../../../users/services/providers/user_service_provider.dart';
import '../../controllers/work_order_controller.dart';
import '../../models/item_type_model.dart';
import '../../models/work_order_item_model.dart';
import '../../models/work_order_model.dart';
import '../../models/work_order_type_model.dart';
import '../../services/providers/item_type_provider_provider.dart';
import '../../services/providers/work_order_provider_provider.dart';
import '../../services/providers/work_order_type_provider_provider.dart';

class WorkOrderCreateController extends GetxController {
  final WorkOrderProvider _workOrderProvider = Get.find<WorkOrderProvider>();

  final WorkOrderTypeProvider _workOrderTypeProvider =
      Get.find<WorkOrderTypeProvider>();
  final ItemTypeProvider _itemTypeProvider = Get.find<ItemTypeProvider>();
  final UserProvider _userProvider = Get.find<UserProvider>();

  // Campos del formulario
  final purchaseOrderId = ''.obs;
  final typeId = Rxn<int>();
  final executionResponsibleId = Rxn<int>();
  final approvalResponsibleId = Rxn<int>();

  // Listas para los selects
  final workOrderTypes = <WorkOrderType>[].obs;
  final itemTypes = <ItemType>[].obs;
  final users = <User>[].obs;

  // Items de la orden
  final items = <WorkOrderItem>[].obs;

  // Loading states
  final isLoadingTypes = false.obs;
  final isLoadingUsers = false.obs;

  final total = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await Future.wait([
      loadUsers(),
      loadWorkOrderTypes(),
      loadItemTypes(),
    ]);
  }

  Future<void> loadWorkOrderTypes() async {
    try {
      isLoadingTypes.value = true;
      final response = await _workOrderTypeProvider.getWorkOrderTypes();

      if (response.status.isOk) {
        final apiResponse = response.body;
        workOrderTypes.value = (apiResponse as List)
            .map((item) => WorkOrderType.fromJson(item))
            .toList();
      } else {
        Get.snackbar(
          'Error',
          'Error al cargar tipos de órdenes',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoadingTypes.value = false;
    }
  }

  Future<void> loadItemTypes() async {
    try {
      final response = await _itemTypeProvider.getItemTypes();

      if (response.status.isOk) {
        final apiResponse = response.body;
        itemTypes.value = (apiResponse["data"] as List)
            .map((item) => ItemType.fromJson(item))
            .toList();
      } else {
        Get.snackbar(
          'Error',
          'Error al cargar tipos de items',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadUsers() async {
    try {
      isLoadingUsers.value = true;
      final response = await _userProvider.getUsers();

      if (response.status.isOk) {
        final apiResponse = response.body;
        users.value =
            (apiResponse as List).map((item) => User.fromJson(item)).toList();
      } else {
        Get.snackbar(
          'Error',
          'Error al cargar usuarios',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoadingUsers.value = false;
    }
  }

  void addItem() {
    if (itemTypes.isEmpty) {
      Get.snackbar(
        'Error',
        'No hay tipos de items disponibles',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final firstType = itemTypes.first;

    items.add(WorkOrderItem(
      id: 0,
      description: '',
      quantity: 1,
      price: 0.00,
      itemTypeId: firstType.id ?? 1,
      workOrderId: 0,
      itemType: firstType,
    ));
    calculateTotal();
  }

  void updateQuantity(WorkOrderItem item, String value) {
    final index = items.indexOf(item);
    if (index != -1) {
      items[index].quantity = int.tryParse(value) ?? 1;
      calculateTotal();
    }
  }

  void updatePrice(WorkOrderItem item, String value) {
    final index = items.indexOf(item);
    if (index != -1) {
      items[index].price = double.tryParse(value) ?? 0.0;
      calculateTotal();
    }
  }

  void removeItem(WorkOrderItem item) {
    items.remove(item);
  }

  Future<void> submit() async {
    if (!validateForm()) return;

    try {
      final newWorkOrder = WorkOrder.createNew(
        purchaseOrderId: purchaseOrderId.value,
        typeId: typeId.value!,
        executionResponsibleId: executionResponsibleId.value!,
        approvalResponsibleId: approvalResponsibleId.value!,
        items: items,
      );
      final response =
          await _workOrderProvider.createWorkOrder(newWorkOrder.toJson());

      if (response.status.isOk) {
        final workOrderController = Get.find<WorkOrderController>();
        await workOrderController.refreshWorkOrders();
        Get.toNamed(
          Routes.WORK_ORDER,
        );
        Get.snackbar('Éxito', 'Orden creada correctamente');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error al guardar la orden');
    }
  }

  bool validateForm() {
    if (purchaseOrderId.value.isEmpty) {
      Get.snackbar('Error', 'Ingrese orden de compra');
      return false;
    }
    if (typeId.value == null) {
      Get.snackbar('Error', 'Seleccione tipo de orden');
      return false;
    }
    if (executionResponsibleId.value == null) {
      Get.snackbar('Error', 'Seleccione responsable de ejecución');
      return false;
    }
    if (approvalResponsibleId.value == null) {
      Get.snackbar('Error', 'Seleccione responsable de aprobación');
      return false;
    }
    if (items.isEmpty) {
      Get.snackbar('Error', 'Agregue al menos un item');
      return false;
    }
    return true;
  }

  void calculateTotal() {
    total.value = items.fold(0.0, (sum, item) {
      final price = double.tryParse(item.price.toString()) ?? 0.0;
      return sum + (price * item.quantity);
    });
  }
}
