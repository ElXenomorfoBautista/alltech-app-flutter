import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/work_order_model.dart';
import '../services/providers/work_order_provider_provider.dart';

class WorkOrderController extends GetxController {
  final WorkOrderProvider _workOrderProvider = Get.find<WorkOrderProvider>();

  // Observables
  final workOrders = <WorkOrder>[].obs;
  final filteredWorkOrders = <WorkOrder>[].obs;
  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final isAdmin = false.obs; // TODO: Obtener del usuario actual

  // Filtros y búsqueda
  final searchQuery = ''.obs;
  final selectedStatus = 'all'.obs;
  final hasActiveFilters = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadWorkOrders();

    // Escuchar cambios en la búsqueda
    debounce(searchQuery, (_) => _applyFilters(),
        time: const Duration(milliseconds: 500));
  }

  // Cargar órdenes de trabajo
  Future<void> loadWorkOrders() async {
    try {
      isLoading.value = true;

      final response = await _workOrderProvider.getWorkOrdersUser();

      if (response.status.isOk && response.body != null) {
        final List<dynamic> data = response.body['data'] ?? [];
        workOrders.value =
            data.map((json) => WorkOrder.fromJson(json)).toList();
        _applyFilters();

        _showSuccessSnackbar('Éxito', 'Órdenes cargadas correctamente');
      } else {
        _showErrorSnackbar(
            'Error', 'No se pudieron cargar las órdenes de trabajo');
      }
    } catch (e) {
      _showErrorSnackbar(
          'Error de Conexión', 'Verifica tu conexión a internet');
    } finally {
      isLoading.value = false;
    }
  }

  // Refrescar órdenes
  Future<void> refreshWorkOrders() async {
    try {
      isRefreshing.value = true;

      final response = await _workOrderProvider.getWorkOrders();

      if (response.status.isOk && response.body != null) {
        final List<dynamic> data = response.body['data'] ?? [];
        workOrders.value =
            data.map((json) => WorkOrder.fromJson(json)).toList();
        _applyFilters();

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

  // Buscar órdenes de trabajo
  void searchWorkOrders(String query) {
    searchQuery.value = query;
    _updateActiveFilters();
  }

  // Limpiar búsqueda
  void clearSearch() {
    searchQuery.value = '';
    _updateActiveFilters();
  }

  // Filtrar por estado
  void filterByStatus(String status) {
    selectedStatus.value = status;
    _applyFilters();
    _updateActiveFilters();
  }

  // Aplicar todos los filtros
  void _applyFilters() {
/*     List<WorkOrder> filtered = List.from(workOrders);

    // Filtro por búsqueda
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((order) {
        return (order.folio?.toLowerCase().contains(query) ?? false) ||
            (order.type?.name?.toLowerCase().contains(query) ?? false) ||
            (order.executionResponsible?.fullName
                    ?.toLowerCase()
                    .contains(query) ??
                false);
      }).toList();
    }

    // Filtro por estado
    if (selectedStatus.value != 'all') {
      switch (selectedStatus.value) {
        case 'active':
          filtered = filtered
              .where((order) =>
                  order.status?.name?.toLowerCase() == 'activo' ||
                  order.status?.name?.toLowerCase() == 'en proceso')
              .toList();
          break;
        case 'completed':
          filtered = filtered
              .where((order) =>
                  order.status?.name?.toLowerCase() == 'completado' ||
                  order.status?.name?.toLowerCase() == 'finalizado')
              .toList();
          break;
        case 'pending':
          filtered = filtered
              .where(
                  (order) => order.status?.name?.toLowerCase() == 'pendiente')
              .toList();
          break;
      }
    }

    filteredWorkOrders.value = filtered;

    // Usar la lista filtrada como la lista principal para la vista
    workOrders.value = filtered; */
  }

  // Actualizar estado de filtros activos
  void _updateActiveFilters() {
    hasActiveFilters.value =
        searchQuery.value.isNotEmpty || selectedStatus.value != 'all';
  }

  // Crear nueva orden de trabajo
  void createNewWorkOrder() {
    Get.toNamed('/work-order/create');
  }

  // Ver detalles de orden
  void viewWorkOrderDetails(WorkOrder workOrder) {
    Get.toNamed('/work-order/detail', arguments: {'workOrder': workOrder});
  }

  // Eliminar orden de trabajo
  Future<void> deleteWorkOrder(WorkOrder workOrder) async {
    try {
      // Mostrar dialog de confirmación
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
              '¿Estás seguro de que quieres eliminar la orden ${workOrder.folio}?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        ),
      );

      if (result == true) {
        /*    isLoading.value = true;
        
        final response = await _workOrderProvider.deleteWorkOrder(workOrder.id!);
        
        if (response.status.isOk) {
          allWorkOrders.removeWhere((order) => order.id == workOrder.id);
          _applyFilters();
          _showSuccessSnackbar('Eliminado', 'Orden eliminada correctamente');
        } else {
          _showErrorSnackbar('Error', 'No se pudo eliminar la orden');
        } */
      }
    } catch (e) {
      _showErrorSnackbar('Error', 'Error al eliminar la orden');
    } finally {
      isLoading.value = false;
    }
  }

  // Obtener estadísticas rápidas
  Map<String, int> getQuickStats() {
    return {
      'total': workOrders.length,
      'active': workOrders
          .where((order) =>
              order.status?.name?.toLowerCase() == 'activo' ||
              order.status?.name?.toLowerCase() == 'en proceso')
          .length,
      'completed': workOrders
          .where((order) =>
              order.status?.name?.toLowerCase() == 'completado' ||
              order.status?.name?.toLowerCase() == 'finalizado')
          .length,
      'pending': workOrders
          .where((order) => order.status?.name?.toLowerCase() == 'pendiente')
          .length,
    };
  }

  // Obtener órdenes por responsable
  List<WorkOrder> getOrdersByResponsible(String responsibleId) {
    return workOrders
        .where((order) => order.executionResponsible?.id == responsibleId)
        .toList();
  }

  // Obtener órdenes por tipo
  List<WorkOrder> getOrdersByType(String typeId) {
    return workOrders
        .where((order) => order.type?.id.toString() == typeId)
        .toList();
  }

  // Exportar órdenes (placeholder)
  void exportWorkOrders() {
    _showInfoSnackbar(
        'Próximamente', 'La exportación de datos estará disponible pronto');
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
