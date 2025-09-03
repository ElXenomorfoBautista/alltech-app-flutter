import 'dart:convert';
import 'package:flutter/material.dart';
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

  // Form key para validación
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  // Estados de carga
  final isLoadingTypes = false.obs;
  final isLoadingUsers = false.obs;
  final isLoadingItemTypes = false.obs;
  final isSubmitting = false.obs;

  // Cálculos
  final total = 0.0.obs;

  // UI States
  final generatedFolio = ''.obs;
  final canSubmit = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
    _setupValidationWatchers();
    _generateFolio();
  }

  void _setupValidationWatchers() {
    // Escuchar cambios en los campos requeridos para habilitar/deshabilitar el botón de envío
    ever(typeId, (_) => _validateForm());
    ever(executionResponsibleId, (_) => _validateForm());
    ever(items, (_) => {_validateForm(), _calculateTotal()});
  }

  void _validateForm() {
    canSubmit.value = typeId.value != null &&
        executionResponsibleId.value != null &&
        !isSubmitting.value;
  }

  void _calculateTotal() {
    double newTotal = 0.0;
    for (var item in items) {
      newTotal += item.subtotal; // Usar el getter subtotal del modelo
    }
    total.value = newTotal;
  }

  void _generateFolio() {
    // Simular generación de folio
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    generatedFolio.value = 'WO${timestamp.toString().substring(7)}';
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
        _showErrorSnackbar('Error', 'Error al cargar tipos de órdenes');
      }
    } catch (e) {
      _showErrorSnackbar('Error', 'Error de conexión al cargar tipos');
    } finally {
      isLoadingTypes.value = false;
    }
  }

  Future<void> loadItemTypes() async {
    try {
      isLoadingItemTypes.value = true;
      final response = await _itemTypeProvider.getItemTypes();

      if (response.status.isOk) {
        final apiResponse = response.body;
        itemTypes.value = (apiResponse["data"] as List)
            .map((item) => ItemType.fromJson(item))
            .toList();
      } else {
        _showErrorSnackbar('Error', 'Error al cargar tipos de items');
      }
    } catch (e) {
      _showErrorSnackbar('Error', 'Error de conexión al cargar tipos de items');
    } finally {
      isLoadingItemTypes.value = false;
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
        _showErrorSnackbar('Error', 'Error al cargar usuarios');
      }
    } catch (e) {
      _showErrorSnackbar('Error', 'Error de conexión al cargar usuarios');
    } finally {
      isLoadingUsers.value = false;
    }
  }

  // Métodos para manejar items
  void addItem(int itemTypeId, String description, int quantity, double price) {
    final itemType =
        itemTypes.firstWhereOrNull((type) => type.id == itemTypeId);

    final newItem = WorkOrderItem(
        id: 0,
        itemTypeId: itemTypeId,
        description: description,
        quantity: quantity,
        price: price,
        itemType: itemType,
        workOrderId: 0);

    items.add(newItem);
    _showSuccessSnackbar('Item agregado', 'Se agregó el item correctamente');
  }

  void removeItem(int index) {
    if (index >= 0 && index < items.length) {
      final removedItem = items[index];
      items.removeAt(index);

      _showInfoSnackbar(
          'Item eliminado', 'Se eliminó "${removedItem.description}"');
    }
  }

  void updateItem(int index, WorkOrderItem updatedItem) {
    if (index >= 0 && index < items.length) {
      items[index] = updatedItem;
    }
  }

  // Métodos de progreso del formulario
  double getFormProgress() {
    int completedFields = 0;
    int totalFields = getTotalFields();

    // Campos básicos
    if (purchaseOrderId.value.isNotEmpty) completedFields++;
    if (typeId.value != null) completedFields++;

    // Responsables
    if (executionResponsibleId.value != null) completedFields++;
    if (approvalResponsibleId.value != null) completedFields++;

    // Items
    if (items.isNotEmpty) completedFields++;

    return completedFields / totalFields;
  }

  int getCompletedFields() {
    int completedFields = 0;

    if (purchaseOrderId.value.isNotEmpty) completedFields++;
    if (typeId.value != null) completedFields++;
    if (executionResponsibleId.value != null) completedFields++;
    if (approvalResponsibleId.value != null) completedFields++;
    if (items.isNotEmpty) completedFields++;

    return completedFields;
  }

  int getTotalFields() {
    return 5; // Total de campos en el formulario
  }

  // Validaciones específicas
  String? validatePurchaseOrder(String? value) {
    // La orden de compra es opcional, pero si se ingresa debe tener formato válido
    if (value != null && value.isNotEmpty) {
      if (value.length < 3) {
        return 'La orden de compra debe tener al menos 3 caracteres';
      }
    }
    return null;
  }

  String? validateType(int? value) {
    if (value == null) {
      return 'Debe seleccionar un tipo de orden';
    }
    return null;
  }

  String? validateExecutionResponsible(int? value) {
    if (value == null) {
      return 'Debe seleccionar un responsable de ejecución';
    }
    return null;
  }

  // Método principal para crear la orden
  Future<void> createWorkOrder() async {
    if (!formKey.currentState!.validate()) {
      _showErrorSnackbar('Formulario incompleto',
          'Por favor complete todos los campos requeridos');
      return;
    }

    if (!canSubmit.value) {
      _showErrorSnackbar('No se puede enviar',
          'Verifique que todos los campos estén completos');
      return;
    }

    try {
      isSubmitting.value = true;
      canSubmit.value = false;
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
        final createdOrder = WorkOrder.fromJson(response.body);

        _showSuccessSnackbar(
          'Orden creada exitosamente',
          'Folio: ${createdOrder.folio ?? generatedFolio.value}',
        );

        // Actualizar la lista de órdenes en el controlador principal
        try {
          final workOrderController = Get.find<WorkOrderController>();
          await workOrderController.refreshWorkOrders();
        } catch (e) {
          // Si no existe el controlador, no hay problema
        }

        // Navegar de vuelta con un pequeño delay para mostrar el snackbar
        await Future.delayed(const Duration(milliseconds: 1500));
        Get.back(result: createdOrder);
      } else {
        final errorMessage = _getErrorMessage(response);
        _showErrorSnackbar('Error al crear orden', errorMessage);
      }
    } catch (e) {
      _showErrorSnackbar(
          'Error de conexión', 'No se pudo conectar con el servidor');
    } finally {
      isSubmitting.value = false;
      _validateForm(); // Recalcular canSubmit
    }
  }

  String _getErrorMessage(dynamic response) {
    try {
      if (response.body != null && response.body['message'] != null) {
        return response.body['message'];
      }
      if (response.statusText != null) {
        return response.statusText!;
      }
    } catch (e) {
      // Si hay error parseando la respuesta
    }
    return 'Error desconocido al crear la orden';
  }

  // Métodos de utilidad para mostrar mensajes
  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: Icon(
        Icons.error_outline,
        color: Colors.red.shade900,
      ),
      duration: const Duration(seconds: 4),
    );
  }

  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: Icon(
        Icons.check_circle_outline,
        color: Colors.green.shade900,
      ),
      duration: const Duration(seconds: 3),
    );
  }

  void _showInfoSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor.withOpacity(0.1),
      colorText: Get.theme.primaryColor,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: Icon(
        Icons.info_outline,
        color: Get.theme.primaryColor,
      ),
      duration: const Duration(seconds: 2),
    );
  }

  // Métodos adicionales para mejorar la UX
  void clearForm() {
    purchaseOrderId.value = '';
    typeId.value = null;
    executionResponsibleId.value = null;
    approvalResponsibleId.value = null;
    items.clear();
    _generateFolio();
  }

  bool hasUnsavedChanges() {
    return purchaseOrderId.value.isNotEmpty ||
        typeId.value != null ||
        executionResponsibleId.value != null ||
        approvalResponsibleId.value != null ||
        items.isNotEmpty;
  }

  void showExitConfirmation() {
    if (!hasUnsavedChanges()) {
      Get.back();
      return;
    }

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_outlined,
              color: Colors.orange[600],
            ),
            const SizedBox(width: 8),
            const Text('Confirmar salida'),
          ],
        ),
        content: const Text(
          '¿Está seguro de que desea salir? Los cambios no guardados se perderán.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Cerrar dialog
              Get.back(); // Salir de la pantalla
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Salir sin guardar'),
          ),
        ],
      ),
    );
  }

  // Método para vista previa de la orden antes de crearla
  void showOrderPreview() {
    final selectedType =
        workOrderTypes.firstWhereOrNull((type) => type.id == typeId.value);
    final selectedExecutor = users
        .firstWhereOrNull((user) => user.id == executionResponsibleId.value);
    final selectedApprover = users
        .firstWhereOrNull((user) => user.id == approvalResponsibleId.value);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.preview,
              color: Get.theme.primaryColor,
            ),
            const SizedBox(width: 8),
            const Text('Vista Previa'),
          ],
        ),
        content: SizedBox(
          width: Get.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPreviewRow('Folio:', generatedFolio.value),
              _buildPreviewRow('Tipo:', selectedType?.name ?? 'N/A'),
              _buildPreviewRow(
                  'Orden de Compra:',
                  purchaseOrderId.value.isEmpty
                      ? 'N/A'
                      : purchaseOrderId.value),
              _buildPreviewRow(
                  'Ejecutor:', selectedExecutor?.fullName ?? 'N/A'),
              _buildPreviewRow(
                  'Aprobador:', selectedApprover?.fullName ?? 'N/A'),
              _buildPreviewRow('Items:', '${items.length}'),
              _buildPreviewRow('Total:', '\$${total.value.toStringAsFixed(2)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Revisar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Cerrar dialog
              createWorkOrder(); // Crear orden
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirmar y Crear'),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    // Limpiar recursos si es necesario
    super.onClose();
  }
}
