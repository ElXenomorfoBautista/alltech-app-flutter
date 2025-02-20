import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/providers/auth_service_provider.dart';

class AuthLoginController extends GetxController {
  final AuthServiceProvider _authService = Get.find<AuthServiceProvider>();

  final username = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;
  final rememberSession = false.obs;

// Ver alguna configuracion chidita para el .env
  final clientId = 'PHS';
  final clientSecret = 'phs!@2023';

  void login() async {
    if (username.value.isEmpty || password.value.isEmpty) {
      Get.snackbar('Error', 'Por favor complete todos los campos');
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
        //final authResponse = response.body;
        Get.offAllNamed('/home');
      } else {
        Get.snackbar(
          'Error de Autenticación',
          response.statusText ?? 'Error desconocido',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }
}
