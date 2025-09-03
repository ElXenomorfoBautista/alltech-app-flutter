import 'package:alltech_app/app/core/theme/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';
import 'app/services/storage_service.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar GetStorage
  await GetStorage.init();

  // Inicializar servicios
  final storage = await Get.putAsync(() => StorageService().init());
  final themeService = await Get.putAsync(() => ThemeService().init());

  // Determinar ruta inicial
  final initialRoute =
      storage.hasValidSession() ? Routes.HOME : Routes.AUTH_LOGIN;

  runApp(AllTechApp(initialRoute: initialRoute));
}

class AllTechApp extends StatelessWidget {
  final String initialRoute;

  const AllTechApp({
    Key? key,
    required this.initialRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetMaterialApp(
          title: "AllTech App",
          debugShowCheckedModeBanner: false,

          // Configuración de temas
          theme: AppTheme.lightTheme(themeController.currentVariant),
          darkTheme: AppTheme.darkTheme(themeController.currentVariant),
          themeMode: themeController.themeMode,

          // Rutas
          initialRoute: initialRoute,
          getPages: AppPages.routes,

          // Configuraciones adicionales
          defaultTransition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),

          // Localización (opcional)
          locale: const Locale('es', 'MX'),
          fallbackLocale: const Locale('en', 'US'),
        );
      },
    );
  }
}
