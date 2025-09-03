import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/work_order_create_controller.dart';

class WorkOrderCreateView extends GetView<WorkOrderCreateController> {
  const WorkOrderCreateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Nueva Orden de Trabajo',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Botón de ayuda/info
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
            tooltip: 'Ayuda',
          ),
        ],
      ),
      body: Form(
        key: controller.formKey,
        child: Column(
          children: [
            // Progress indicator
            _buildProgressIndicator(context),

            // Formulario scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header con resumen
                    _buildHeaderCard(context),

                    const SizedBox(height: 16),

                    // Información básica
                    _buildBasicInfoCard(context),

                    const SizedBox(height: 16),

                    // Responsables
                    _buildResponsiblesCard(context),

                    const SizedBox(height: 16),

                    // Items/Equipos
                    _buildItemsCard(context),

                    const SizedBox(height: 16),

                    // Resumen de costos
                    _buildCostSummaryCard(context),

                    const SizedBox(height: 100), // Espacio para FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        final progress = controller.getFormProgress();
        return Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.assignment,
                  color: Colors.white.withOpacity(0.9),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Progreso del formulario: ${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  '${controller.getCompletedFields()}/${controller.getTotalFields()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 3,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Theme.of(context).primaryColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.work_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Crear Nueva Orden',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Complete la información requerida',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Folio: ${controller.generatedFolio.value.isEmpty ? "Se generará automáticamente" : controller.generatedFolio.value}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Información Básica',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Orden de Compra
            _buildAnimatedTextField(
              label: 'Orden de Compra',
              hintText: 'Ingrese el número de OC (opcional)',
              prefixIcon: Icons.receipt_long,
              onChanged: (val) => controller.purchaseOrderId.value = val,
              validator: null, // Campo opcional
            ),

            const SizedBox(height: 20),

            // Tipo de Orden
            Obx(() => _buildAnimatedDropdown<int>(
                  label: 'Tipo de Orden *',
                  hintText: 'Seleccione el tipo',
                  prefixIcon: Icons.category,
                  value: controller.typeId.value,
                  items: controller.workOrderTypes
                      .map((type) => DropdownMenuItem<int>(
                            value: type.id,
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _getTypeColor(type.code ?? ''),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        type.name ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (type.description?.isNotEmpty == true)
                                        Text(
                                          type.description!,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) => controller.typeId.value = value,
                  isLoading: controller.isLoadingTypes.value,
                  validator: (value) =>
                      value == null ? 'Seleccione un tipo' : null,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiblesCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.people_outline,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Responsables',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Ejecutor
            Obx(() => _buildResponsibleDropdown(
                  label: 'Responsable de Ejecución *',
                  hintText: 'Seleccione el ejecutor',
                  prefixIcon: Icons.build,
                  iconColor: Colors.blue,
                  value: controller.executionResponsibleId.value,
                  onChanged: (value) =>
                      controller.executionResponsibleId.value = value,
                  validator: (value) =>
                      value == null ? 'Seleccione un ejecutor' : null,
                )),

            const SizedBox(height: 20),

            // Aprobador
            Obx(() => _buildResponsibleDropdown(
                  label: 'Responsable de Aprobación',
                  hintText: 'Seleccione el aprobador (opcional)',
                  prefixIcon: Icons.verified,
                  iconColor: Colors.green,
                  value: controller.approvalResponsibleId.value,
                  onChanged: (value) =>
                      controller.approvalResponsibleId.value = value,
                  validator: null, // Campo opcional
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Items y Equipos',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Obx(() => Chip(
                      label: Text(
                        '${controller.items.length} items',
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Lista de items
            Obx(() => controller.items.isEmpty
                ? _buildEmptyItemsState(context)
                : _buildItemsList(context)),

            const SizedBox(height: 16),

            // Botón para agregar item
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showAddItemDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Agregar Item'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostSummaryCard(BuildContext context) {
    return Obx(() => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: controller.items.isNotEmpty
              ? Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.withOpacity(0.1),
                          Colors.green.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calculate_outlined,
                              color: Colors.green[700],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Resumen de Costos',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[700],
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.green.withOpacity(0.3)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total de Items:',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    '${controller.items.length}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Divider(),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total General:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    '\$${controller.total.value.toStringAsFixed(2)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[700],
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ));
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Obx(() => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: FloatingActionButton.extended(
              onPressed: controller.canSubmit.value
                  ? () => controller.createWorkOrder()
                  : null,
              backgroundColor: controller.canSubmit.value
                  ? Theme.of(context).primaryColor
                  : Colors.grey[400],
              foregroundColor: Colors.white,
              icon: controller.isSubmitting.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(
                controller.isSubmitting.value
                    ? 'Creando...'
                    : 'Crear Orden de Trabajo',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              elevation: controller.canSubmit.value ? 6 : 2,
            ),
          ),
        ));
  }

  // Widgets auxiliares
  Widget _buildAnimatedTextField({
    required String label,
    required String hintText,
    required IconData prefixIcon,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool isRequired = false,
  }) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Theme.of(Get.context!).primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildAnimatedDropdown<T>({
    required String label,
    required String hintText,
    required IconData prefixIcon,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
    String? Function(T?)? validator,
    bool isLoading = false,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: isLoading ? null : onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Theme.of(Get.context!).primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.all(16),
      ),
      hint: Text(hintText),
      isExpanded: true,
    );
  }

  Widget _buildResponsibleDropdown({
    required String label,
    required String hintText,
    required IconData prefixIcon,
    required Color iconColor,
    required int? value,
    required Function(int?) onChanged,
    String? Function(int?)? validator,
  }) {
    return _buildAnimatedDropdown<int>(
      label: label,
      hintText: hintText,
      prefixIcon: prefixIcon,
      value: value,
      items: controller.users
          .map((user) => DropdownMenuItem<int>(
                value: user.id,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: iconColor.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        size: 16,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user.fullName ?? 'Sin nombre',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          if (user.email?.isNotEmpty == true)
                            Text(
                              user.email!,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
      onChanged: onChanged,
      isLoading: controller.isLoadingUsers.value,
      validator: validator,
    );
  }

  Widget _buildEmptyItemsState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'No hay items agregados',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Agregue equipos o servicios a la orden',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = controller.items[index];
        return _buildItemCard(context, item, index);
      },
    );
  }

  Widget _buildItemCard(BuildContext context, dynamic item, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.inventory_2,
                  size: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.description ?? 'Sin descripción',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red[400],
                  size: 20,
                ),
                onPressed: () => controller.removeItem(index),
                tooltip: 'Eliminar item',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Cantidad: ${item.quantity ?? 1}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Text(
                '\$${(item.price ?? 0.0).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Métodos auxiliares
  Color _getTypeColor(String code) {
    switch (code.toUpperCase()) {
      case 'PREV':
        return Colors.blue;
      case 'CORR':
        return Colors.orange;
      case 'EMRG':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showHelpDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.help_outline,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            const Text('Ayuda'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Complete todos los campos marcados con *'),
            SizedBox(height: 8),
            Text('• El ejecutor es responsable de realizar el trabajo'),
            SizedBox(height: 8),
            Text('• El aprobador debe validar la orden antes de ejecutar'),
            SizedBox(height: 8),
            Text('• Agregue todos los items necesarios para el trabajo'),
            SizedBox(height: 8),
            Text('• El folio se genera automáticamente al crear la orden'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    final descriptionController = TextEditingController();
    final quantityController = TextEditingController(text: '1');
    final priceController = TextEditingController(text: '0.00');
    final selectedItemType = Rxn<int>();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.add_box,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            const Text('Agregar Item'),
          ],
        ),
        content: SizedBox(
          width: Get.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tipo de Item
              Obx(() => DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Tipo de Item *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.category),
                    ),
                    value: selectedItemType.value,
                    items: controller.itemTypes
                        .map((type) => DropdownMenuItem<int>(
                              value: type.id,
                              child: Text(type.name ?? ''),
                            ))
                        .toList(),
                    onChanged: (value) => selectedItemType.value = value,
                    validator: (value) =>
                        value == null ? 'Seleccione un tipo' : null,
                  )),

              const SizedBox(height: 16),

              // Descripción
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 2,
                validator: (value) =>
                    value?.isEmpty == true ? 'Ingrese una descripción' : null,
              ),

              const SizedBox(height: 16),

              // Cantidad y Precio
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: quantityController,
                      decoration: InputDecoration(
                        labelText: 'Cantidad',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty == true) return 'Requerido';
                        final qty = int.tryParse(value!);
                        if (qty == null || qty <= 0) return 'Cantidad inválida';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: 'Precio Unitario',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.attach_money),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value?.isEmpty == true) return 'Requerido';
                        final price = double.tryParse(value!);
                        if (price == null || price < 0)
                          return 'Precio inválido';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedItemType.value != null &&
                  descriptionController.text.isNotEmpty &&
                  quantityController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                final quantity = int.tryParse(quantityController.text) ?? 1;
                final price = double.tryParse(priceController.text) ?? 0.0;

                controller.addItem(
                  selectedItemType.value!,
                  descriptionController.text,
                  quantity,
                  price,
                );

                Get.back();
              } else {
                Get.snackbar(
                  'Error',
                  'Complete todos los campos requeridos',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red.shade100,
                  colorText: Colors.red.shade900,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
