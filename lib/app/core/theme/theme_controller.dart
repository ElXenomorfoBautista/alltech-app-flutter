import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app_theme.dart';

class ThemeController extends GetxController {
  static const String _themeKey = 'theme_mode';
  static const String _colorVariantKey = 'color_variant';

  final _storage = GetStorage();

  // Observables
  final _isDarkMode = false.obs;
  final _currentVariant = 'red'.obs;

  // Getters
  bool get isDarkMode => _isDarkMode.value;
  String get currentVariant => _currentVariant.value;
  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  // Cargar tema guardado
  void _loadThemeFromStorage() {
    final savedThemeMode = _storage.read(_themeKey);
    final savedVariant = _storage.read(_colorVariantKey) ?? 'red';

    if (savedThemeMode != null) {
      _isDarkMode.value = savedThemeMode == 'dark';
    } else {
      final brightness = Get.context != null
          ? MediaQuery.of(Get.context!).platformBrightness
          : Brightness.light;
      _isDarkMode.value = brightness == Brightness.dark;
    }

    _currentVariant.value = savedVariant;
    _updateAppTheme();
  }

  // Cambiar entre modo claro y oscuro
  void toggleThemeMode() {
    _isDarkMode.value = !_isDarkMode.value;
    _saveThemeToStorage();
    _updateAppTheme();
  }

  // Establecer modo específico
  void setThemeMode(bool isDark) {
    _isDarkMode.value = isDark;
    _saveThemeToStorage();
    _updateAppTheme();
  }

  // Cambiar variante de color
  void setColorVariant(String variant) {
    if (AppTheme.themeVariants.containsKey(variant)) {
      _currentVariant.value = variant;
      _saveThemeToStorage();
      _updateAppTheme();
    }
  }

  // Obtener lista de variantes disponibles
  List<String> get availableVariants => AppTheme.themeVariants.keys.toList();

  // Obtener colores de la variante actual
  ThemeColors get currentColors =>
      AppTheme.themeVariants[_currentVariant.value] ??
      AppTheme.themeVariants['red']!;

  // Aplicar tema automático según el sistema
  void useSystemTheme() {
    final brightness = Get.context != null
        ? MediaQuery.of(Get.context!).platformBrightness
        : Brightness.light;
    _isDarkMode.value = brightness == Brightness.dark;
    _removeThemeFromStorage(); // Remover configuración manual para usar la del sistema
    _updateAppTheme();
  }

  // Verificar si está usando el tema del sistema
  bool get isUsingSystemTheme => !_storage.hasData(_themeKey);

  // Guardar tema en storage
  void _saveThemeToStorage() {
    _storage.write(_themeKey, _isDarkMode.value ? 'dark' : 'light');
    _storage.write(_colorVariantKey, _currentVariant.value);
  }

  // Remover tema del storage (para usar el del sistema)
  void _removeThemeFromStorage() {
    _storage.remove(_themeKey);
  }

  // Actualizar el tema de la aplicación
  void _updateAppTheme() {
    Get.changeTheme(_isDarkMode.value
        ? AppTheme.darkTheme(_currentVariant.value)
        : AppTheme.lightTheme(_currentVariant.value));
  }

  // Obtener información del tema actual
  Map<String, dynamic> get themeInfo => {
        'isDarkMode': _isDarkMode.value,
        'variant': _currentVariant.value,
        'isSystemTheme': isUsingSystemTheme,
        'primaryColor': currentColors.primary.value.toRadixString(16),
      };

  // Métodos de conveniencia para variantes específicas
  void setRedTheme() => setColorVariant('red');
  void setBlueTheme() => setColorVariant('blue');
  void setPurpleTheme() => setColorVariant('purple');
  void setGreenTheme() => setColorVariant('green');

  // Obtener nombre legible de la variante
  String getVariantDisplayName(String variant) {
    switch (variant) {
      case 'red':
        return 'Rojo';
      case 'blue':
        return 'Azul';
      case 'purple':
        return 'Morado';
      case 'green':
        return 'Verde';
      default:
        return variant.toUpperCase();
    }
  }

  // Obtener icono para la variante
  IconData getVariantIcon(String variant) {
    switch (variant) {
      case 'red':
        return Icons.favorite;
      case 'blue':
        return Icons.water_drop;
      case 'purple':
        return Icons.auto_awesome;
      case 'green':
        return Icons.eco;
      default:
        return Icons.palette;
    }
  }

  // Resetear a configuración por defecto
  void resetToDefault() {
    _currentVariant.value = 'red';
    _isDarkMode.value = false;
    _saveThemeToStorage();
    _updateAppTheme();
  }
}
