import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/storage_service.dart';

class HomeController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  // Observables para datos del dashboard
  final isLoading = false.obs;
  final isRefreshing = false.obs;

  // Stats del dashboard
  final activeOrders = 12.obs;
  final pendingServices = 8.obs;
  final totalUsers = 24.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  // Cargar datos del dashboard
  void loadDashboardData() async {
    try {
      isLoading.value = true;

      // Simular carga de datos - aquí irían las llamadas reales a la API
      await Future.delayed(const Duration(seconds: 1));

      // Aquí harías las llamadas reales a tus servicios
      // activeOrders.value = await _workOrderService.getActiveCount();
      // pendingServices.value = await _serviceSheetService.getPendingCount();
      // totalUsers.value = await _userService.getTotalCount();
    } catch (e) {
      _showErrorSnackbar(
          'Error', 'No se pudieron cargar los datos del dashboard');
    } finally {
      isLoading.value = false;
    }
  }

  // Refrescar datos
  Future<void> refreshData() async {
    try {
      isRefreshing.value = true;

      // Simular refresh - aquí irían las llamadas reales a la API
      await Future.delayed(const Duration(seconds: 2));

      // Actualizar stats
      activeOrders.value += 1;
      pendingServices.value -= 1;
      totalUsers.value += 1;

      _showSuccessSnackbar('Actualizado', 'Datos actualizados correctamente');
    } catch (e) {
      _showErrorSnackbar('Error', 'No se pudieron actualizar los datos');
    } finally {
      isRefreshing.value = false;
    }
  }

  // Cerrar sesión
  void logout() async {
    try {
      // Mostrar dialog de confirmación ya está en la vista
      await _storageService.clearTokens();

      _showSuccessSnackbar('Sesión Cerrada', 'Hasta pronto!');

      // Navegar al login
      Get.offAllNamed('/auth/login');
    } catch (e) {
      _showErrorSnackbar('Error', 'No se pudo cerrar la sesión');
    }
  }

  // Obtener información del usuario actual
  String? getCurrentUserName() {
    //return _storageService.getCurrentUserName() ?? 'Usuario';
  }

  String? getCurrentUserId() {
    // return _storageService.getCurrentUserId();
  }

  // Verificar si hay sesión válida
  bool hasValidSession() {
    return _storageService.hasValidSession();
  }

  // Navegación rápida a módulos
  void navigateToWorkOrders() {
    Get.toNamed('/work-order');
  }

  void navigateToServiceSheets() {
    Get.toNamed('/service-sheet');
  }

  void navigateToUsers() {
    Get.toNamed('/users');
  }

  void navigateToProfile() {
    Get.toNamed('/profile', arguments: {'userId': getCurrentUserId()});
  }

  // Crear nueva orden de trabajo
  void createNewWorkOrder() {
    Get.toNamed('/work-order/create');
  }

  // Crear nueva hoja de servicio
  void createNewServiceSheet() {
    Get.toNamed('/service-sheet/create');
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
      duration: const Duration(seconds: 3),
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

  // Obtener saludo según la hora
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '¡Buenos días!';
    } else if (hour < 17) {
      return '¡Buenas tardes!';
    } else {
      return '¡Buenas noches!';
    }
  }

  // Obtener color según el estado
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'activo':
      case 'completado':
        return Colors.green;
      case 'pendiente':
      case 'en_proceso':
        return Colors.orange;
      case 'cancelado':
      case 'error':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  void onClose() {
    // Limpiar recursos si es necesario
    super.onClose();
  }
}
