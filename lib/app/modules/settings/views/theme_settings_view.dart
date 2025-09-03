import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_controller.dart';

class ThemeSettingsView extends GetView<ThemeController> {
  const ThemeSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Temas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.resetToDefault,
            tooltip: 'Restaurar por defecto',
          ),
        ],
      ),
      body: Obx(() => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Información actual
              _buildCurrentThemeCard(),
              const SizedBox(height: 16),

              // Selector de modo
              _buildThemeModeSection(),
              const SizedBox(height: 16),

              // Selector de variantes de color
              _buildColorVariantSection(),
              const SizedBox(height: 16),

              // Vista previa
              _buildPreviewSection(),
            ],
          )),
    );
  }

  Widget _buildCurrentThemeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  controller.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Theme.of(Get.context!).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Tema Actual',
                  style: Theme.of(Get.context!).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(),
            _buildInfoRow('Modo:', controller.isDarkMode ? 'Oscuro' : 'Claro'),
            _buildInfoRow('Color:',
                controller.getVariantDisplayName(controller.currentVariant)),
            _buildInfoRow(
                'Usando sistema:', controller.isUsingSystemTheme ? 'Sí' : 'No'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildThemeModeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Modo de Tema',
              style: Theme.of(Get.context!).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            // Opciones de modo
            RadioListTile<int>(
              title: const Text('Claro'),
              subtitle: const Text('Siempre usar tema claro'),
              //   leading: const Icon(Icons.light_mode),
              value: 0,
              groupValue: controller.isUsingSystemTheme
                  ? 2
                  : (controller.isDarkMode ? 1 : 0),
              onChanged: (value) => controller.setThemeMode(false),
            ),

            RadioListTile<int>(
              title: const Text('Oscuro'),
              subtitle: const Text('Siempre usar tema oscuro'),
              // leading: const Icon(Icons.dark_mode),
              value: 1,
              groupValue: controller.isUsingSystemTheme
                  ? 2
                  : (controller.isDarkMode ? 1 : 0),
              onChanged: (value) => controller.setThemeMode(true),
            ),

            RadioListTile<int>(
              title: const Text('Sistema'),
              subtitle: const Text('Seguir configuración del dispositivo'),
              //leading: const Icon(Icons.settings_system_daydream),
              value: 2,
              groupValue: controller.isUsingSystemTheme
                  ? 2
                  : (controller.isDarkMode ? 1 : 0),
              onChanged: (value) => controller.useSystemTheme(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorVariantSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Esquema de Colores',
              style: Theme.of(Get.context!).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            // Grid de variantes de color
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 3.5,
              ),
              itemCount: controller.availableVariants.length,
              itemBuilder: (context, index) {
                final variant = controller.availableVariants[index];
                final isSelected = controller.currentVariant == variant;
                final colors = controller.currentColors;

                return InkWell(
                  onTap: () => controller.setColorVariant(variant),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isSelected ? colors.primary.withOpacity(0.1) : null,
                      border: Border.all(
                        color: isSelected
                            ? colors.primary
                            : Colors.grey.withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(
                            controller.getVariantIcon(variant),
                            color: isSelected ? colors.primary : null,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              controller.getVariantDisplayName(variant),
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected ? colors.primary : null,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: colors.primary,
                              size: 18,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vista Previa',
              style: Theme.of(Get.context!).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // Botones de ejemplo
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Elevated'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Outlined'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Text'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Campo de texto de ejemplo
            TextField(
              decoration: const InputDecoration(
                labelText: 'Campo de ejemplo',
                hintText: 'Escribe algo aquí...',
                prefixIcon: Icon(Icons.edit),
              ),
            ),

            const SizedBox(height: 16),

            // Chips y switches de ejemplo
            Row(
              children: [
                Chip(
                  label: const Text('Chip'),
                  avatar: const Icon(Icons.tag, size: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SwitchListTile(
                    title: const Text('Ejemplo Switch'),
                    value: true,
                    onChanged: (value) {},
                    dense: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Progress indicator
            LinearProgressIndicator(
              value: 0.7,
              backgroundColor: Colors.grey.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}
