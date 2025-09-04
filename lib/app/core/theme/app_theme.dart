import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales configurables
  static const Color primaryColor = Color(0xFFFF3D32); // Tu color rojo
  static const Color primaryVariant = Color(0xFFE8342A); // Variante más oscura
  static const Color secondaryColor = Color(0xFF03DAC6); // Complementario

  // Colores para diferentes combinaciones
  static const Map<String, ThemeColors> themeVariants = {
    'red': ThemeColors(
      primary: Color(0xFFFF3D32),
      primaryVariant: Color(0xFFE8342A),
      secondary: Color(0xFF03DAC6),
    ),
    'blue': ThemeColors(
      primary: Color(0xFF2196F3),
      primaryVariant: Color(0xFF1976D2),
      secondary: Color(0xFFFF9800),
    ),
    'purple': ThemeColors(
      primary: Color(0xFF9C27B0),
      primaryVariant: Color(0xFF7B1FA2),
      secondary: Color(0xFF4CAF50),
    ),
    'green': ThemeColors(
      primary: Color(0xFF4CAF50),
      primaryVariant: Color(0xFF388E3C),
      secondary: Color(0xFFF44336),
    ),
  };

  // Tema claro
  static ThemeData lightTheme([String variant = 'red']) {
    final colors = themeVariants[variant] ?? themeVariants['red']!;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Esquema de colores
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.primary,
        brightness: Brightness.light,
        primary: colors.primary,
        secondary: colors.secondary,
      ),

      // AppBar personalizada
      appBarTheme: AppBarTheme(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Botones elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Botones de texto
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // Botones de contorno
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Campos de texto
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.all(16),
        floatingLabelStyle: TextStyle(color: colors.primary),
      ),

      // Cards
      cardTheme: CardThemeData(
        elevation: 2,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: colors.primary.withOpacity(0.1),
        labelStyle: TextStyle(color: colors.primary),
        side: BorderSide(color: colors.primary.withOpacity(0.3)),
      ),

      // FloatingActionButton
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
      ),

      // CheckBox y Switch
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return null;
        }),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary.withOpacity(0.5);
          }
          return null;
        }),
      ),

      // ProgressIndicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.primaryVariant,
        contentTextStyle: const TextStyle(color: Colors.white),
        actionTextColor: Colors.white,
      ),
    );
  }

  // Tema oscuro
  static ThemeData darkTheme([String variant = 'red']) {
    final colors = themeVariants[variant] ?? themeVariants['red']!;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Esquema de colores oscuro
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.primary,
        brightness: Brightness.dark,
        primary: colors.primary,
        secondary: colors.secondary,
      ),

      // AppBar oscura
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Botones elevados oscuros
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Botones de texto oscuros
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // Botones de contorno oscuros
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Campos de texto oscuros
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.all(16),
        floatingLabelStyle: TextStyle(color: colors.primary),
        fillColor: const Color(0xFF2E2E2E),
        filled: true,
      ),

      // Cards oscuras
      cardTheme: CardThemeData(
        elevation: 2,
        margin: const EdgeInsets.all(8),
        color: const Color(0xFF2E2E2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Chips oscuros
      chipTheme: ChipThemeData(
        backgroundColor: colors.primary.withOpacity(0.2),
        labelStyle: TextStyle(color: colors.primary),
        side: BorderSide(color: colors.primary.withOpacity(0.5)),
      ),

      // FloatingActionButton oscuro
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
      ),

      // CheckBox y Switch oscuros
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return null;
        }),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary.withOpacity(0.5);
          }
          return null;
        }),
      ),

      // ProgressIndicator oscuro
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
      ),

      // Snackbar oscuro
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.primaryVariant,
        contentTextStyle: const TextStyle(color: Colors.white),
        actionTextColor: Colors.white,
      ),
    );
  }
}

// Clase para definir colores de tema
class ThemeColors {
  final Color primary;
  final Color primaryVariant;
  final Color secondary;

  const ThemeColors({
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
  });
}
