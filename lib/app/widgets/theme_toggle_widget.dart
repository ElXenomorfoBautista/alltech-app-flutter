import 'package:alltech_app/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/theme_controller.dart';
import '../modules/settings/views/theme_settings_view.dart';

class ThemeToggleWidget extends GetView<ThemeController> {
  final bool showLabel;
  final bool showSettingsButton;
  final EdgeInsetsGeometry? padding;

  const ThemeToggleWidget({
    Key? key,
    this.showLabel = true,
    this.showSettingsButton = true,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Toggle de modo oscuro/claro
              IconButton(
                icon: Icon(
                  controller.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: controller.toggleThemeMode,
                tooltip: controller.isDarkMode
                    ? 'Cambiar a modo claro'
                    : 'Cambiar a modo oscuro',
              ),

              if (showLabel) ...[
                const SizedBox(width: 4),
                Text(
                  controller.isDarkMode ? 'Oscuro' : 'Claro',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],

              if (showSettingsButton) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    Icons.palette,
                    color: controller.currentColors.primary,
                  ),
                  onPressed: () => _showThemeSettings(context),
                  tooltip: 'Configurar temas',
                ),
              ],
            ],
          ),
        ));
  }

  void _showThemeSettings(BuildContext context) {
    // Opción 1: Modal bottom sheet
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: const ThemeSettingsView(),
      ),
      isScrollControlled: true,
    );

    // Opción 2: Navegación a página completa (comentada)
    // Get.to(() => const ThemeSettingsView());
  }
}

// Widget compacto solo para toggle
class CompactThemeToggle extends GetView<ThemeController> {
  const CompactThemeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Switch(
          value: controller.isDarkMode,
          onChanged: (value) => controller.setThemeMode(value),
          activeColor: controller.currentColors.primary,
        ));
  }
}

// Widget para mostrar el color actual
class ColorVariantIndicator extends GetView<ThemeController> {
  final double size;
  final bool showLabel;

  const ColorVariantIndicator({
    Key? key,
    this.size = 24,
    this.showLabel = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: controller.currentColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                controller.getVariantIcon(controller.currentVariant),
                size: size * 0.6,
                color: Colors.white,
              ),
            ),
            if (showLabel) ...[
              const SizedBox(width: 8),
              Text(
                controller.getVariantDisplayName(controller.currentVariant),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ));
  }
}

// Widget para selector rápido de colores
class QuickColorSelector extends GetView<ThemeController> {
  final Axis direction;
  final double spacing;

  const QuickColorSelector({
    Key? key,
    this.direction = Axis.horizontal,
    this.spacing = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Wrap(
          direction: direction,
          spacing: spacing,
          children: controller.availableVariants.map((variant) {
            final colors = AppTheme.themeVariants[variant]!;
            final isSelected = controller.currentVariant == variant;

            return GestureDetector(
              onTap: () => controller.setColorVariant(variant),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: colors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ]
                      : null,
                ),
                child: Icon(
                  controller.getVariantIcon(variant),
                  size: 18,
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
        ));
  }
}
