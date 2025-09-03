import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../widgets/theme_toggle_widget.dart';
import '../../../users/models/uuser_model.dart';
import '../../models/work_order_item_model.dart';
import '../controllers/work_order_detail_controller.dart';

class WorkOrderDetailView extends GetView<WorkOrderDetailController> {
  const WorkOrderDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final workOrder = controller.workOrder.value;
        if (workOrder == null) {
          return _buildNotFoundState(context);
        }

        return CustomScrollView(
          slivers: [
            _buildSliverAppBar(context, workOrder),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Estado y acciones rápidas
                    _buildStatusAndActions(context, workOrder),

                    const SizedBox(height: 16),

                    // Información general
                    _buildGeneralInfoCard(context, workOrder),

                    const SizedBox(height: 16),

                    // Responsables
                    _buildResponsiblesCard(context, workOrder),

                    const SizedBox(height: 16),

                    // Items de la orden
                    _buildItemsCard(context, workOrder.workOrderItems ?? []),

                    const SizedBox(height: 16),

                    // Estadísticas y progreso
                    _buildStatsCard(context, workOrder),

                    const SizedBox(height: 100), // Espacio para FABs
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: _buildFloatingActions(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, dynamic workOrder) {
    final statusColor = _getStatusColor(workOrder.status?.name ?? '');

    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      actions: [
        ThemeToggleWidget(
          showLabel: false,
          showSettingsButton: false,
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _editWorkOrder(workOrder);
                break;
              case 'share':
                _shareWorkOrder(workOrder);
                break;
              case 'print':
                _printWorkOrder(workOrder);
                break;
              case 'duplicate':
                _duplicateWorkOrder(workOrder);
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  const Text('Editar'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'share',
              child: Row(
                children: [
                  Icon(Icons.share, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  const Text('Compartir'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'print',
              child: Row(
                children: [
                  Icon(Icons.print, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  const Text('Imprimir'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'duplicate',
              child: Row(
                children: [
                  Icon(Icons.copy, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  const Text('Duplicar'),
                ],
              ),
            ),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.work_outline,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Orden ${workOrder.folio ?? "Sin folio"}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              workOrder.type?.name ?? 'Tipo no definido',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotFoundState(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orden no encontrada'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 24),
              Text(
                'Orden no encontrada',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'No se pudo encontrar la orden de trabajo solicitada.',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Regresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusAndActions(BuildContext context, dynamic workOrder) {
    final statusColor = _getStatusColor(workOrder.status?.name ?? '');

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: statusColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getStatusIcon(workOrder.status?.name ?? ''),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estado actual',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      Text(
                        workOrder.status?.name ?? 'Sin estado',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Acciones rápidas
        Column(
          children: [
            _buildQuickActionButton(
              context,
              Icons.edit,
              'Editar',
              () => _editWorkOrder(workOrder),
            ),
            const SizedBox(height: 8),
            _buildQuickActionButton(
              context,
              Icons.share,
              'Compartir',
              () => _shareWorkOrder(workOrder),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    IconData icon,
    String tooltip,
    VoidCallback onPressed,
  ) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        tooltip: tooltip,
      ),
    );
  }

  Widget _buildGeneralInfoCard(BuildContext context, dynamic workOrder) {
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
                ),
                const SizedBox(width: 8),
                Text(
                  'Información General',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            _buildInfoRow('Folio:', workOrder.folio ?? 'N/A', Icons.tag),
            _buildInfoRow(
              'Orden de Compra:',
              workOrder.purchaseOrderId ?? 'N/A',
              Icons.receipt_long,
            ),
            _buildInfoRow(
              'Tipo:',
              workOrder.type?.name ?? 'N/A',
              Icons.category,
            ),
            _buildInfoRow(
              'Fecha de Creación:',
              _formatDetailedDate(workOrder.createdOn),
              Icons.calendar_today,
            ),
            _buildInfoRow(
              'Estado:',
              workOrder.status?.name ?? 'N/A',
              Icons.flag,
              _getStatusColor(workOrder.status?.name ?? ''),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, [
    IconData? icon,
    Color? valueColor,
  ]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiblesCard(BuildContext context, dynamic workOrder) {
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
                ),
                const SizedBox(width: 8),
                Text(
                  'Responsables',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            _buildResponsibleSection(
              'Ejecutor',
              workOrder.executionResponsible,
              Icons.build,
              Colors.blue,
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            _buildResponsibleSection(
              'Aprobador',
              workOrder.approvalResponsible,
              Icons.verified,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsibleSection(
    String title,
    User? user,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 16,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (user != null) ...[
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color.withOpacity(0.1),
                child: user.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          user.imageUrl!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.person,
                            color: color,
                          ),
                        ),
                      )
                    : Icon(Icons.person, color: color),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    if (user.email != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        user.email!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                    if (user.phone != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        user.phone!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Botones de contacto
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (user.phone != null)
                    IconButton(
                      onPressed: () => _callUser(user.phone!),
                      icon: Icon(Icons.phone, color: Colors.green[600]),
                      tooltip: 'Llamar',
                    ),
                  if (user.email != null)
                    IconButton(
                      onPressed: () => _emailUser(user.email!),
                      icon: Icon(Icons.email, color: Colors.blue[600]),
                      tooltip: 'Email',
                    ),
                ],
              ),
            ],
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.person_off, color: Colors.grey[500]),
                const SizedBox(width: 8),
                Text(
                  'No asignado',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildItemsCard(BuildContext context, List<WorkOrderItem> items) {
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
                ),
                const SizedBox(width: 8),
                Text(
                  'Items de la Orden',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${items.length} item${items.length != 1 ? 's' : ''}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            if (items.isEmpty) ...[
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No hay items en esta orden',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 16),

              // Lista de items
              ...items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Column(
                  children: [
                    _buildItemTile(item, index + 1),
                    if (index < items.length - 1) const Divider(height: 24),
                  ],
                );
              }),

              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Total
              Row(
                children: [
                  const Spacer(),
                  Text(
                    'Total: ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    '\$${controller.calculateTotal().toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItemTile(WorkOrderItem item, int index) {
    final total = (item.price ?? 0) * item.quantity;
    final typeColor = item.itemType?.id == 1 ? Colors.blue : Colors.green;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Número del item
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Theme.of(Get.context!).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '$index',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(Get.context!).primaryColor,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Información del item
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.description,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.itemType?.name ?? 'Sin tipo',
                      style: TextStyle(
                        color: typeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cantidad: ${item.quantity}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Precio unitario: \$${(item.price ?? 0).toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Subtotal: \$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(BuildContext context, dynamic workOrder) {
    final items = workOrder.workOrderItems ?? <WorkOrderItem>[];
    final totalItems = items.length;
    final totalAmount = controller.calculateTotal();

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
                  Icons.analytics_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Estadísticas',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Items',
                    '$totalItems',
                    Icons.inventory_2,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Valor Total',
                    '\$${totalAmount.toStringAsFixed(2)}',
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Fecha Creación',
                    _formatShortDate(workOrder.createdOn),
                    Icons.calendar_today,
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Estado',
                    workOrder.status?.name ?? 'N/A',
                    Icons.flag,
                    _getStatusColor(workOrder.status?.name ?? ''),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActions(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "edit",
          onPressed: () => _editWorkOrder(controller.workOrder.value),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.edit),
        ),
        const SizedBox(height: 16),
        FloatingActionButton.extended(
          heroTag: "service_sheet",
          onPressed: () => _createServiceSheet(controller.workOrder.value),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.description),
          label: const Text('Crear Servicio'),
        ),
      ],
    );
  }

  // Métodos de utilidad
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completado':
      case 'finalizado':
        return Colors.green;
      case 'en proceso':
      case 'activo':
        return Colors.blue;
      case 'pendiente':
        return Colors.orange;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completado':
      case 'finalizado':
        return Icons.check_circle;
      case 'en proceso':
      case 'activo':
        return Icons.play_circle;
      case 'pendiente':
        return Icons.schedule;
      case 'cancelado':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String _formatDetailedDate(DateTime? date) {
    if (date == null) return 'Sin fecha';

    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];

    final localDate = date.toLocal();
    return '${localDate.day} de ${months[localDate.month - 1]} de ${localDate.year}';
  }

  String _formatShortDate(DateTime? date) {
    if (date == null) return 'N/A';
    final localDate = date.toLocal();
    return '${localDate.day}/${localDate.month}/${localDate.year}';
  }

  // Acciones
  void _editWorkOrder(dynamic workOrder) {
    Get.snackbar(
      'Próximamente',
      'La edición de órdenes estará disponible pronto',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor.withOpacity(0.1),
      colorText: Get.theme.primaryColor,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: Icon(
        Icons.info_outline,
        color: Get.theme.primaryColor,
      ),
    );
  }

  void _shareWorkOrder(dynamic workOrder) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Compartir Orden ${workOrder.folio}',
              style: Get.theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: Icon(Icons.email, color: Colors.blue),
              ),
              title: const Text('Enviar por Email'),
              subtitle: const Text('Compartir detalles por correo electrónico'),
              onTap: () {
                Get.back();
                _sendByEmail(workOrder);
              },
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green.withOpacity(0.1),
                child: Icon(Icons.message, color: Colors.green),
              ),
              title: const Text('Enviar por WhatsApp'),
              subtitle: const Text('Compartir resumen por WhatsApp'),
              onTap: () {
                Get.back();
                _sendByWhatsApp(workOrder);
              },
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange.withOpacity(0.1),
                child: Icon(Icons.copy, color: Colors.orange),
              ),
              title: const Text('Copiar enlace'),
              subtitle: const Text('Copiar enlace de la orden'),
              onTap: () {
                Get.back();
                _copyLink(workOrder);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _printWorkOrder(dynamic workOrder) {
    Get.snackbar(
      'Función de Impresión',
      'Generando documento PDF...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.1),
      colorText: Colors.blue,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.print, color: Colors.blue),
      duration: const Duration(seconds: 2),
    );
  }

  void _duplicateWorkOrder(dynamic workOrder) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.copy, color: Get.theme.primaryColor),
            const SizedBox(width: 8),
            const Text('Duplicar Orden'),
          ],
        ),
        content: Text(
          '¿Deseas crear una nueva orden basada en "${workOrder.folio}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _performDuplication(workOrder);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Duplicar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _performDuplication(dynamic workOrder) {
    Get.snackbar(
      'Duplicando...',
      'Creando nueva orden basada en ${workOrder.folio}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor.withOpacity(0.1),
      colorText: Get.theme.primaryColor,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: Icon(Icons.copy, color: Get.theme.primaryColor),
      duration: const Duration(seconds: 3),
    );
  }

  void _createServiceSheet(dynamic workOrder) {
    Get.toNamed('/service-sheet/create', arguments: {
      'workOrderId': workOrder.id,
      'workOrder': workOrder,
    });
  }

  void _callUser(String phone) {
    // Implementar llamada telefónica
    Get.snackbar(
      'Llamar',
      'Iniciando llamada a $phone...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.phone, color: Colors.green),
    );
  }

  void _emailUser(String email) {
    // Implementar envío de email
    Get.snackbar(
      'Email',
      'Abriendo cliente de email para $email...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.1),
      colorText: Colors.blue,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.email, color: Colors.blue),
    );
  }

  void _sendByEmail(dynamic workOrder) {
    Get.snackbar(
      'Enviando por Email',
      'Preparando detalles de la orden ${workOrder.folio}...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.1),
      colorText: Colors.blue,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.email, color: Colors.blue),
    );
  }

  void _sendByWhatsApp(dynamic workOrder) {
    Get.snackbar(
      'Enviando por WhatsApp',
      'Compartiendo orden ${workOrder.folio}...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.message, color: Colors.green),
    );
  }

  void _copyLink(dynamic workOrder) {
    final link = 'https://alltech.app/work-orders/${workOrder.id}';

    // Copiar al clipboard
    Clipboard.setData(ClipboardData(text: link));

    Get.snackbar(
      'Enlace Copiado',
      'El enlace de la orden ha sido copiado al portapapeles',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.withOpacity(0.1),
      colorText: Colors.orange,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.copy, color: Colors.orange),
      duration: const Duration(seconds: 2),
    );
  }
}
