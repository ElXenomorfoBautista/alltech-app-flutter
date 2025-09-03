import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/work_order_model.dart';
import '../../services/providers/work_order_provider_provider.dart';

class WorkOrderDetailController extends GetxController {
  final WorkOrderProvider _workOrderProvider = Get.find<WorkOrderProvider>();

  final workOrder = Rxn<WorkOrder>();
  final isLoading = false.obs;
  final isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadWorkOrderData();
  }

  // Cargar datos de la orden
  void loadWorkOrderData() {
    final arguments = Get.arguments;

    if (arguments != null && arguments['workOrder'] != null) {
      workOrder.value = arguments['workOrder'];
    } else if (arguments != null && arguments['workOrderId'] != null) {
      // Si solo tenemos el ID, cargar desde la API
      loadWorkOrderById(arguments['workOrderId']);
    }
  }

  // Cargar orden por ID desde la API
  Future<void> loadWorkOrderById(int id) async {
    try {
      isLoading.value = true;

      final response = await _workOrderProvider.getWorkOrderById(id);

      if (response.status.isOk && response.body != null) {
        workOrder.value = WorkOrder.fromJson(response.body['data']);
      } else {
        _showErrorSnackbar('Error', 'No se pudo cargar la orden de trabajo');
      }
    } catch (e) {
      _showErrorSnackbar(
          'Error de Conexión', 'Verifica tu conexión a internet');
    } finally {
      isLoading.value = false;
    }
  }

  // Refrescar datos de la orden
  Future<void> refreshWorkOrder() async {
    if (workOrder.value?.id == null) return;

    try {
      isRefreshing.value = true;

      final response =
          await _workOrderProvider.getWorkOrderById(workOrder.value!.id!);

      if (response.status.isOk && response.body != null) {
        workOrder.value = WorkOrder.fromJson(response.body['data']);
        _showSuccessSnackbar('Actualizado', 'Datos actualizados correctamente');
      } else {
        _showErrorSnackbar('Error', 'No se pudieron actualizar los datos');
      }
    } catch (e) {
      _showErrorSnackbar(
          'Error de Conexión', 'Verifica tu conexión a internet');
    } finally {
      isRefreshing.value = false;
    }
  }

  // Calcular total de items
  double calculateTotal() {
    return workOrder.value?.workOrderItems?.fold(0.0, (sum, item) {
          return sum! + (item.price ?? 0) * item.quantity;
        }) ??
        0.0;
  }

  // Obtener estadísticas de la orden
  Map<String, dynamic> getOrderStats() {
    final items = workOrder.value?.workOrderItems ?? [];
    final total = calculateTotal();

    return {
      'totalItems': items.length,
      'totalAmount': total,
      'averageItemPrice': items.isEmpty ? 0.0 : total / items.length,
      'maxItemPrice': items.isEmpty
          ? 0.0
          : items.map((e) => e.price ?? 0).reduce((a, b) => a > b ? a : b),
      'minItemPrice': items.isEmpty
          ? 0.0
          : items.map((e) => e.price ?? 0).reduce((a, b) => a < b ? a : b),
    };
  }

  // Obtener items por tipo
  Map<String, List<dynamic>> getItemsByType() {
    final items = workOrder.value?.workOrderItems ?? [];
    final Map<String, List<dynamic>> itemsByType = {};

    for (final item in items) {
      final typeName = item.itemType?.name ?? 'Sin tipo';
      if (!itemsByType.containsKey(typeName)) {
        itemsByType[typeName] = [];
      }
      itemsByType[typeName]!.add(item);
    }

    return itemsByType;
  }

  // Verificar si se puede editar la orden
  bool canEditOrder() {
    final status = workOrder.value?.status?.name?.toLowerCase();
    return status != 'completado' &&
        status != 'finalizado' &&
        status != 'cancelado';
  }

  // Verificar si se puede crear hoja de servicio
  bool canCreateServiceSheet() {
    final status = workOrder.value?.status?.name?.toLowerCase();
    return status == 'activo' || status == 'en proceso';
  }

  // Obtener progreso de la orden (simulado)
  double getOrderProgress() {
    final status = workOrder.value?.status?.name?.toLowerCase();
    switch (status) {
      case 'pendiente':
        return 0.0;
      case 'activo':
      case 'en proceso':
        return 0.5;
      case 'completado':
      case 'finalizado':
        return 1.0;
      case 'cancelado':
        return 0.0;
      default:
        return 0.0;
    }
  }

  // Obtener tiempo transcurrido desde la creación
  String getTimeElapsed() {
    final createdOn = workOrder.value?.createdOn;
    if (createdOn == null) return 'Tiempo desconocido';

    final now = DateTime.now();
    final difference = now.difference(createdOn);

    if (difference.inDays > 0) {
      return '${difference.inDays} día${difference.inDays != 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours != 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes != 1 ? 's' : ''}';
    } else {
      return 'Hace un momento';
    }
  }

  // Cambiar estado de la orden
  Future<void> changeOrderStatus(String newStatus) async {
    if (workOrder.value?.id == null) return;

    try {
      isLoading.value = true;

      // Aquí iría la llamada a la API para cambiar el estado
      // final response = await _workOrderProvider.updateOrderStatus(workOrder.value!.id!, newStatus);

      // Simulamos el cambio por ahora
      await Future.delayed(const Duration(seconds: 1));

      _showSuccessSnackbar(
          'Estado Actualizado', 'El estado de la orden ha sido actualizado');

      // Recargar los datos
      await refreshWorkOrder();
    } catch (e) {
      _showErrorSnackbar('Error', 'No se pudo actualizar el estado');
    } finally {
      isLoading.value = false;
    }
  }

  // Asignar responsable
  Future<void> assignResponsible(String responsibleId, String type) async {
    if (workOrder.value?.id == null) return;

    try {
      isLoading.value = true;

      // Aquí iría la llamada a la API para asignar responsable
      // final response = await _workOrderProvider.assignResponsible(workOrder.value!.id!, responsibleId, type);

      // Simulamos la asignación por ahora
      await Future.delayed(const Duration(seconds: 1));

      _showSuccessSnackbar('Responsable Asignado',
          'El responsable ha sido asignado correctamente');

      // Recargar los datos
      await refreshWorkOrder();
    } catch (e) {
      _showErrorSnackbar('Error', 'No se pudo asignar el responsable');
    } finally {
      isLoading.value = false;
    }
  }

  // Generar resumen para compartir
  String generateShareSummary() {
    final order = workOrder.value;
    if (order == null) return '';

    final total = calculateTotal();
    final itemCount = order.workOrderItems?.length ?? 0;

    return '''
📋 *Orden de Trabajo: ${order.folio}*

🏢 *Tipo:* ${order.type?.name ?? 'N/A'}
📅 *Fecha:* ${_formatDate(order.createdOn)}
⭕ *Estado:* ${order.status?.name ?? 'N/A'}

👤 *Ejecutor:* ${order.executionResponsible?.fullName ?? 'No asignado'}
✅ *Aprobador:* ${order.approvalResponsible?.fullName ?? 'No asignado'}

📦 *Items:* $itemCount
💰 *Total:* \$${total.toStringAsFixed(2)}

🔗 Ver detalles completos: https://alltech.app/work-orders/${order.id}
''';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Sin fecha';
    final localDate = date.toLocal();
    return '${localDate.day}/${localDate.month}/${localDate.year}';
  }

  // Navegación
  void goToEdit() {
    if (workOrder.value != null) {
      Get.toNamed('/work-order/edit',
          arguments: {'workOrder': workOrder.value});
    }
  }

  void goToServiceSheetCreate() {
    if (workOrder.value != null) {
      Get.toNamed('/service-sheet/create', arguments: {
        'workOrderId': workOrder.value!.id,
        'workOrder': workOrder.value,
      });
    }
  }

  void goToUserProfile(String userId) {
    Get.toNamed('/profile', arguments: {'userId': userId});
  }

  // Métodos de utilidad para snackbars
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
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    // Limpiar recursos
    super.onClose();
  }
}
