import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/service_sheet_model.dart';
import '../services/providers/service_sheet_provider.dart';

class ServiceSheetController extends GetxController {
  final ServiceSheetProvider _provider = Get.find<ServiceSheetProvider>();

  // Observables principales
  final serviceSheets = <ServiceSheet>[].obs;
  final filteredServiceSheets = <ServiceSheet>[].obs;
  final isLoading = false.obs;

  // Controladores de búsqueda y filtros
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedStatus = ''.obs;
  final showHighPriority = false.obs;
  final hasActiveFilters = false.obs;

  // Lista de todos los posibles estados (puedes ajustar según tu API)
  final List<String> availableStatuses = [
    'pending',
    'in_progress',
    'completed',
    'cancelled'
  ];

  @override
  void onInit() {
    super.onInit();
    getServiceSheets();

    // Listener para la búsqueda en tiempo real
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      _filterServiceSheets();
    });

    // Listeners para filtros
    ever(selectedStatus, (_) {
      _updateActiveFilters();
      _filterServiceSheets();
    });

    ever(showHighPriority, (_) {
      _updateActiveFilters();
      _filterServiceSheets();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// Obtiene las service sheets del servidor
  Future<void> getServiceSheets() async {
    try {
      isLoading.value = true;
      final response = await _provider.getServiceSheetsUser();

      if (response.status.isOk) {
        final apiResponse = response.body;
        serviceSheets.value = (apiResponse['data'] as List)
            .map((item) => ServiceSheet.fromJson(item))
            .toList();

        _filterServiceSheets();
        _showSuccessMessage('Service sheets actualizadas');
      } else {
        throw 'Error del servidor: ${response.statusText}';
      }
    } catch (e) {
      _showErrorMessage('Error al cargar service sheets: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresca los datos con pull-to-refresh
  Future<void> refreshServiceSheets() async {
    await getServiceSheets();
  }

  /// Maneja cambios en la búsqueda
  void onSearchChanged(String query) {
    searchQuery.value = query;
    _filterServiceSheets();
  }

  /// Limpia la búsqueda
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    _filterServiceSheets();
  }

  /// Establece filtro por estado
  void setStatusFilter(String status) {
    selectedStatus.value = status;
  }

  /// Toggle para mostrar solo alta prioridad
  void toggleHighPriority() {
    showHighPriority.value = !showHighPriority.value;
  }

  /// Filtra las service sheets según los criterios actuales
  void _filterServiceSheets() {
    List<ServiceSheet> filtered = List.from(serviceSheets);

    // Filtro por búsqueda
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((sheet) {
        final folio = sheet.folio?.toLowerCase() ?? '';
        final workOrderFolio = sheet.workOrder?.folio?.toLowerCase() ?? '';
        final executorName =
            sheet.executionResponsible?.fullName?.toLowerCase() ?? '';
        final approverName =
            sheet.approvalResponsible?.fullName?.toLowerCase() ?? '';
        final statusName = sheet.status?.name?.toLowerCase() ?? '';

        return folio.contains(query) ||
            workOrderFolio.contains(query) ||
            executorName.contains(query) ||
            approverName.contains(query) ||
            statusName.contains(query);
      }).toList();
    }

    // Filtro por estado
    if (selectedStatus.value.isNotEmpty) {
      filtered = filtered.where((sheet) {
        final status = sheet.status?.name?.toLowerCase() ?? '';
        return _matchesStatusFilter(status, selectedStatus.value);
      }).toList();
    }

    // Filtro por alta prioridad
    if (showHighPriority.value) {
      filtered = filtered.where((sheet) => sheet.priority == 1).toList();
    }

    filteredServiceSheets.value = filtered;
  }

  /// Verifica si un estado coincide con el filtro seleccionado
  bool _matchesStatusFilter(String status, String filter) {
    switch (filter) {
      case 'pending':
        return status.contains('pending') || status.contains('pendiente');
      case 'in_progress':
        return status.contains('progress') || status.contains('proceso');
      case 'completed':
        return status.contains('completed') || status.contains('completada');
      case 'cancelled':
        return status.contains('cancelled') || status.contains('cancelada');
      default:
        return true;
    }
  }

  /// Actualiza el estado de filtros activos
  void _updateActiveFilters() {
    hasActiveFilters.value = selectedStatus.value.isNotEmpty ||
        showHighPriority.value ||
        searchQuery.value.isNotEmpty;
  }

  /// Limpia todos los filtros
  void clearAllFilters() {
    searchController.clear();
    searchQuery.value = '';
    selectedStatus.value = '';
    showHighPriority.value = false;
    _filterServiceSheets();
  }

  /// Obtiene service sheets por estado específico
  Future<void> getServiceSheetsByStatus(String status) async {
    setStatusFilter(status);
  }

  /// Cuenta service sheets por estado
  int getCountByStatus(String status) {
    return serviceSheets.where((sheet) {
      final sheetStatus = sheet.status?.name?.toLowerCase() ?? '';
      return _matchesStatusFilter(sheetStatus, status);
    }).length;
  }

  /// Obtiene service sheets de alta prioridad
  List<ServiceSheet> getHighPrioritySheets() {
    return serviceSheets.where((sheet) => sheet.priority == 1).toList();
  }

  /// Calcula estadísticas básicas
  Map<String, int> getStatistics() {
    return {
      'total': serviceSheets.length,
      'pending': getCountByStatus('pending'),
      'in_progress': getCountByStatus('in_progress'),
      'completed': getCountByStatus('completed'),
      'high_priority': getHighPrioritySheets().length,
    };
  }

  /// Exporta a PDF (implementación futura)
  Future<void> exportToPDF() async {
    try {
      _showInfoMessage('Preparando exportación a PDF...');
      // Implementación futura
      await Future.delayed(const Duration(seconds: 2));
      _showSuccessMessage('Exportación completada');
    } catch (e) {
      _showErrorMessage('Error al exportar: $e');
    }
  }

  /// Exporta a Excel (implementación futura)
  Future<void> exportToExcel() async {
    try {
      _showInfoMessage('Preparando exportación a Excel...');
      // Implementación futura
      await Future.delayed(const Duration(seconds: 2));
      _showSuccessMessage('Exportación completada');
    } catch (e) {
      _showErrorMessage('Error al exportar: $e');
    }
  }

  /// Busca service sheets por texto
  Future<void> searchServiceSheets(String query) async {
    if (query.isEmpty) {
      _filterServiceSheets();
      return;
    }

    // Podría hacer búsqueda en servidor si es necesario
    onSearchChanged(query);
  }

  /// Ordena service sheets por diferentes criterios
  void sortServiceSheets(String criterion, {bool ascending = true}) {
    List<ServiceSheet> sorted = List.from(filteredServiceSheets);

    switch (criterion) {
      case 'folio':
        sorted.sort((a, b) => ascending
            ? (a.folio ?? '').compareTo(b.folio ?? '')
            : (b.folio ?? '').compareTo(a.folio ?? ''));
        break;
      case 'date':
        sorted.sort((a, b) => ascending
            ? (a.createdOn ?? DateTime.now())
                .compareTo(b.createdOn ?? DateTime.now())
            : (b.createdOn ?? DateTime.now())
                .compareTo(a.createdOn ?? DateTime.now()));
        break;
      case 'priority':
        sorted.sort((a, b) => ascending
            ? (a.priority ?? 3).compareTo(b.priority ?? 3)
            : (b.priority ?? 3).compareTo(a.priority ?? 3));
        break;
      case 'status':
        sorted.sort((a, b) => ascending
            ? (a.status?.name ?? '').compareTo(b.status?.name ?? '')
            : (b.status?.name ?? '').compareTo(a.status?.name ?? ''));
        break;
    }

    filteredServiceSheets.value = sorted;
  }

  /// Actualiza una service sheet específica
  Future<void> updateServiceSheet(ServiceSheet updatedSheet) async {
    try {
      // Actualizar en la lista local
      final index =
          serviceSheets.indexWhere((sheet) => sheet.id == updatedSheet.id);
      if (index != -1) {
        serviceSheets[index] = updatedSheet;
        _filterServiceSheets();
      }
    } catch (e) {
      _showErrorMessage('Error al actualizar: $e');
    }
  }

  /// Elimina una service sheet (soft delete)
  Future<void> deleteServiceSheet(int serviceSheetId) async {
    try {
      isLoading.value = true;

      // Aquí iría la llamada a la API para eliminar
      // await _provider.deleteServiceSheet(serviceSheetId);

      // Por ahora solo removemos de la lista local
      serviceSheets.removeWhere((sheet) => sheet.id == serviceSheetId);
      _filterServiceSheets();

      _showSuccessMessage('Service sheet eliminada');
    } catch (e) {
      _showErrorMessage('Error al eliminar: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Métodos de utilidad para mensajes
  void _showSuccessMessage(String message) {
    Get.snackbar(
      'Éxito',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: Icon(Icons.check_circle_outline, color: Colors.green.shade900),
      duration: const Duration(seconds: 3),
    );
  }

  void _showErrorMessage(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: Icon(Icons.error_outline, color: Colors.red.shade900),
      duration: const Duration(seconds: 4),
    );
  }

  void _showInfoMessage(String message) {
    Get.snackbar(
      'Información',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor.withOpacity(0.1),
      colorText: Get.theme.primaryColor,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: Icon(Icons.info_outline, color: Get.theme.primaryColor),
      duration: const Duration(seconds: 3),
    );
  }
}
