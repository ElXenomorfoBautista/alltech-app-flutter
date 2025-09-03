import 'package:alltech_app/app/core/theme/theme_controller.dart';
import 'package:get/get.dart';

class ThemeService extends GetxService {
  static ThemeService get to => Get.find();

  Future<ThemeService> init() async {
    // Inicializar el controlador de temas
    Get.put(ThemeController(), permanent: true);
    return this;
  }

  // Métodos de acceso rápido
  ThemeController get themeController => Get.find<ThemeController>();

  // Métodos de conveniencia
  bool get isDarkMode => themeController.isDarkMode;
  String get currentVariant => themeController.currentVariant;

  void toggleTheme() => themeController.toggleThemeMode();
  void setColorVariant(String variant) =>
      themeController.setColorVariant(variant);
}
