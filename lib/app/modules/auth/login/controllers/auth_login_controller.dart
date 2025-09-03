import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/providers/auth_service_provider.dart';

class AuthLoginController extends GetxController {
  final AuthServiceProvider _authService = Get.find<AuthServiceProvider>();

  final username = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;
  final rememberSession = false.obs;
  final obscurePassword =
      true.obs; // Nuevo observable para mostrar/ocultar contraseña

  // Ver alguna configuracion chidita para el .env
  final clientId = 'PHS';
  final clientSecret = 'phs!@2023';

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void login() async {
    if (username.value.isEmpty || password.value.isEmpty) {
      _showErrorSnackbar('Error', 'Por favor complete todos los campos');
      return;
    }

    try {
      isLoading.value = true;
      final response = await _authService.login(
          username: username.value,
          password: password.value,
          clientId: clientId,
          clientSecret: clientSecret,
          rememberSession: rememberSession.value);

      if (response.status.isOk) {
        _showSuccessSnackbar('¡Bienvenido!', 'Sesión iniciada correctamente');
        Get.offAllNamed('/home');
      } else {
        _showErrorSnackbar(
          'Error de Autenticación',
          response.statusText ?? 'Credenciales incorrectas',
        );
      }
    } catch (e) {
      _showErrorSnackbar(
        'Error de Conexión',
        'Verifica tu conexión a internet e intenta nuevamente',
      );
    } finally {
      isLoading.value = false;
    }
  }

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

  @override
  void onClose() {
    // Limpiar datos sensibles al cerrar
    username.value = '';
    password.value = '';
    super.onClose();
  }
}
