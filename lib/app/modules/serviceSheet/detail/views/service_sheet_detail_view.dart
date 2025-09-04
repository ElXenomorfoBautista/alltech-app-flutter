import 'package:alltech_app/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

import '../../../../widgets/theme_toggle_widget.dart';
import '../../../users/models/uuser_model.dart';
import '../../models/service_sheet_item_model.dart';
import '../../models/service_sheet_model.dart';
import '../controllers/service_sheet_detail_controller.dart';

class ServiceSheetDetailView extends GetView<ServiceSheetDetailController> {
  const ServiceSheetDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final serviceSheet = controller.serviceSheet.value;
        if (serviceSheet == null) {
          return _buildNotFoundState(context);
        }

        if (controller.isLoading.value) {
          return _buildLoadingState(context);
        }

        return CustomScrollView(
          slivers: [
            _buildSliverAppBar(context, serviceSheet),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildStatusAndActions(context, serviceSheet),

                    const SizedBox(height: 16),

                    // Información general
                    _buildGeneralInfoCard(context, serviceSheet),

                    const SizedBox(height: 16),

                    // Responsables
                    _buildResponsiblesCard(context, serviceSheet),
                    const SizedBox(height: 16),

                    // Items de la hoja de servicio
                    _buildItemsCard(
                        context, serviceSheet.serviceSheetItems ?? []),

                    const SizedBox(height: 16),

                    // Evidencias y documentos
                    _buildEvidencesCard(context),
                    const SizedBox(height: 16),

                    // Estadísticas y progreso
                    _buildStatsCard(serviceSheet),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: _buildFloatingActions(),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ServiceSheet serviceSheet) {
    final statusColor = _getStatusColor(serviceSheet.status?.name ?? '');
    final priorityData = _getPriorityData(serviceSheet.priority);

    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: statusColor,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          serviceSheet.folio ?? 'Sin folio',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 3,
                color: Colors.black26,
              ),
            ],
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                statusColor,
                statusColor.withOpacity(0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60), // Espacio para el título
                  Text(
                    'Orden: ${serviceSheet.workOrder?.folio ?? "N/A"}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              priorityData['icon'],
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              priorityData['text'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(serviceSheet.createdOn),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
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
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) {
            switch (value) {
              case 'share':
                _shareServiceSheet(serviceSheet);
                break;
              case 'print':
                _printServiceSheet(serviceSheet);
                break;
              case 'copy':
                _copyToClipboard(serviceSheet);
                break;
              case 'refresh':
                // controller.refreshServiceSheet();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'share',
              child: Row(
                children: [
                  Icon(Icons.share, size: 20),
                  SizedBox(width: 12),
                  Text('Compartir'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'print',
              child: Row(
                children: [
                  Icon(Icons.print, size: 20),
                  SizedBox(width: 12),
                  Text('Imprimir'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'copy',
              child: Row(
                children: [
                  Icon(Icons.copy, size: 20),
                  SizedBox(width: 12),
                  Text('Copiar enlace'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'refresh',
              child: Row(
                children: [
                  Icon(Icons.refresh, size: 20),
                  SizedBox(width: 12),
                  Text('Actualizar'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Cargando hoja de servicio...'),
        ],
      ),
    );
  }

  Widget _buildNotFoundState(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hoja de Servicio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Hoja de servicio no encontrada',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'La hoja de servicio que buscas no existe o fue eliminada',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }

  // Métodos de utilidad básicos
  Map<String, dynamic> _getPriorityData(int? priority) {
    switch (priority) {
      case 1:
        return {
          'text': 'Alta',
          'color': Colors.red,
          'icon': Icons.priority_high,
        };
      case 2:
        return {
          'text': 'Media',
          'color': Colors.orange,
          'icon': Icons.remove,
        };
      case 3:
        return {
          'text': 'Baja',
          'color': Colors.green,
          'icon': Icons.keyboard_arrow_down,
        };
      default:
        return {
          'text': 'N/A',
          'color': Colors.grey,
          'icon': Icons.help_outline,
        };
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'pendiente':
        return Colors.orange;
      case 'in_progress':
      case 'en proceso':
        return Colors.blue;
      case 'completed':
      case 'completada':
        return Colors.green;
      case 'cancelled':
      case 'cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Sin fecha';
    final now = DateTime.now();
    final localDate = date.toLocal();
    final difference = now.difference(localDate);

    if (difference.inDays > 0) {
      return '${localDate.day}/${localDate.month}/${localDate.year}';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours}h';
    } else {
      return 'Hace ${difference.inMinutes}m';
    }
  }

  // Métodos de acción (básicos por ahora)
  void _shareServiceSheet(ServiceSheet serviceSheet) {
    Clipboard.setData(ClipboardData(text: serviceSheet.shareSummary));
    Get.snackbar(
      'Copiado',
      'Resumen copiado al portapapeles',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
    );
  }

  void _printServiceSheet(ServiceSheet serviceSheet) {
    Get.snackbar(
      'Función en desarrollo',
      'La función de impresión estará disponible pronto',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _copyToClipboard(ServiceSheet serviceSheet) {
    final url = 'https://alltech.app/service-sheets/${serviceSheet.id}';
    Clipboard.setData(ClipboardData(text: url));
    Get.snackbar(
      'Copiado',
      'Enlace copiado al portapapeles',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
    );
  }

  Widget _buildStatusAndActions(
      BuildContext context, ServiceSheet serviceSheet) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Estado actual
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estado Actual',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(serviceSheet.statusName)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getStatusColor(serviceSheet.statusName),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      serviceSheet.statusName,
                      style: TextStyle(
                        color: _getStatusColor(serviceSheet.statusName),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Botones de acción
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Botón ejecutar (solo si es ejecutor y está pendiente)
                  if (controller.isExecutor.value &&
                      serviceSheet.isPending) ...[
                    ElevatedButton.icon(
                      onPressed: () => _showExecuteDialog(serviceSheet),
                      icon: const Icon(Icons.play_arrow, size: 16),
                      label: const Text('Ejecutar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],

                  // Botón aprobar (solo si es aprobador y no está pendiente)
                  if (controller.isApproval.value &&
                      !serviceSheet.isPending) ...[
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _showApprovalDialog(serviceSheet),
                      icon: const Icon(Icons.check_circle, size: 16),
                      label: const Text('Aprobar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],

                  // Botón editar (siempre visible para el owner)
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => _navigateToEdit(serviceSheet),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Icon(Icons.edit, size: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralInfoCard(
      BuildContext context, ServiceSheet serviceSheet) {
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
            _buildInfoRow(
              'Folio:',
              serviceSheet.folio ?? 'Sin folio',
              Icons.confirmation_number,
            ),
            _buildInfoRow(
              'Orden de Trabajo:',
              serviceSheet.workOrder?.folio ?? 'N/A',
              Icons.work_outline,
            ),
            _buildInfoRow(
              'Tipo de Orden:',
              serviceSheet.workOrder?.type?.name ?? 'N/A',
              Icons.category,
            ),
            _buildInfoRow(
              'Prioridad:',
              serviceSheet.priorityText,
              Icons.priority_high,
              _getPriorityColor(serviceSheet.priority),
            ),
            _buildInfoRow(
              'Fecha de Creación:',
              _formatDetailedDate(serviceSheet.createdOn),
              Icons.calendar_today,
            ),
            _buildInfoRow(
              'Estado:',
              serviceSheet.statusName,
              Icons.flag,
              _getStatusColor(serviceSheet.statusName),
            ),
            if (serviceSheet.workOrder?.purchaseOrderId != null) ...[
              _buildInfoRow(
                'Orden de Compra:',
                serviceSheet.workOrder?.purchaseOrderId ?? 'N/A',
                Icons.shopping_cart,
              ),
            ],
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

  Widget _buildResponsiblesCard(
      BuildContext context, ServiceSheet serviceSheet) {
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
              serviceSheet.executionResponsible,
              Icons.build,
              Colors.blue,
              controller.isExecutor.value,
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            _buildResponsibleSection(
              'Aprobador',
              serviceSheet.approvalResponsible,
              Icons.verified,
              Colors.green,
              controller.isApproval.value,
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
    bool isCurrentUser,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentUser ? color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border:
            isCurrentUser ? Border.all(color: color.withOpacity(0.3)) : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'TÚ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  user?.fullName ?? 'No asignado',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                if (user?.email != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    user!.email!,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
                if (user?.phone != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user!.phone!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (user?.phone != null)
            IconButton(
              icon: Icon(
                Icons.phone,
                color: color,
              ),
              onPressed: () => _callUser(user!.phone!),
              tooltip: 'Llamar',
            ),
        ],
      ),
    );
  }

  // Métodos de utilidad adicionales
  Color _getPriorityColor(int? priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDetailedDate(DateTime? date) {
    if (date == null) return 'Sin fecha';
    final localDate = date.toLocal();
    final months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    return '${localDate.day} ${months[localDate.month - 1]} ${localDate.year} - ${localDate.hour.toString().padLeft(2, '0')}:${localDate.minute.toString().padLeft(2, '0')}';
  }

  // Métodos de acción (básicos)
  void _callUser(String phone) {
    Get.snackbar(
      'Llamar',
      'Funcionalidad de llamada: $phone',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _navigateToEdit(ServiceSheet serviceSheet) {
    Get.toNamed('/service-sheet/edit', arguments: serviceSheet);
  }

  void _showExecuteDialog(ServiceSheet serviceSheet) {
    Get.dialog(
      AlertDialog(
        title: const Text('Ejecutar Hoja de Servicio'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                '¿Confirmas que quieres marcar esta hoja de servicio como ejecutada?'),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Comentarios (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.markAsExecuted();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child:
                const Text('Ejecutar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showApprovalDialog(ServiceSheet serviceSheet) {
    Get.dialog(
      AlertDialog(
        title: const Text('Aprobar Hoja de Servicio'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('¿Confirmas que quieres aprobar esta hoja de servicio?'),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Comentarios de aprobación (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // controller.markAsApproved();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Aprobar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsCard(BuildContext context, List<ServiceSheetItem> items) {
    final total = controller.calculateTotal();

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Items de Servicio',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
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
                    'Total: \$${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            if (items.isEmpty)
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
                      'No hay items en esta hoja de servicio',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              )
            else
              ...items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Column(
                  children: [
                    _buildItemTile(item, index),
                    if (index < items.length - 1) const Divider(height: 24),
                  ],
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildItemTile(ServiceSheetItem item, int index) {
    final workOrderItem = item.workOrderItem;
    if (workOrderItem == null) {
      return const ListTile(
        title: Text('Item no disponible'),
        subtitle: Text('Información del item no encontrada'),
      );
    }

    final subtotal = workOrderItem.subtotal;
    final itemType = workOrderItem.itemType;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Número del item
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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
                      workOrderItem.description,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (itemType != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getItemTypeColor(itemType.name ?? '')
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          itemType.name ?? 'Sin tipo',
                          style: TextStyle(
                            color: _getItemTypeColor(itemType.name ?? ''),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Precios
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${workOrderItem.quantity} × \$${workOrderItem.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEvidencesCard(BuildContext context) {
    return Obx(() {
      final evidences = controller.evidences;

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Evidencias',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  if (controller.isExecutor.value ||
                      controller.isApproval.value)
                    TextButton.icon(
                      onPressed: () => _showAddEvidenceDialog(),
                      icon: const Icon(Icons.add_a_photo, size: 16),
                      label: const Text('Agregar'),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              if (evidences.isEmpty)
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No hay evidencias agregadas',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (controller.isExecutor.value ||
                          controller.isApproval.value)
                        TextButton(
                          onPressed: () => _showAddEvidenceDialog(),
                          child: const Text('Agregar primera evidencia'),
                        ),
                    ],
                  ),
                )
              else
                Column(
                  children: [
                    // Contador de evidencias
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${evidences.length} evidencia${evidences.length != 1 ? 's' : ''}',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Grid de evidencias
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: evidences.length,
                      itemBuilder: (context, index) {
                        final evidence = evidences[index];
                        return _buildEvidenceTile(evidence, index);
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildEvidenceTile(dynamic evidence, int index) {
    final bool isImage = evidence.file?.fileType?.contains('image') ?? false;

    return GestureDetector(
      onTap: () => _viewEvidence(evidence),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Placeholder para imagen/documento
              Container(
                color: Colors.grey.shade100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isImage
                        ? Expanded(
                            child: Image.network(
                              evidence.file?.accessUrl ?? '',
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          )
                        : Icon(
                            _getEvidenceIcon(evidence),
                            color: Colors.grey.shade400,
                            size: 32,
                          ),
                    const SizedBox(height: 4),
                    Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Tipo de archivo
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getFileTypeLabel(evidence),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (controller.isExecutor.value || controller.isApproval.value)
                Positioned(
                  top: 4,
                  left: 4,
                  child: GestureDetector(
                    onTap: () => _showDeleteEvidenceDialog(evidence),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Métodos de utilidad para evidencias
  IconData _getEvidenceIcon(dynamic evidence) {
    // Basado en el tipo de archivo o extensión
    final type = evidence.file.fileType?.toLowerCase() ?? '';
    if (type.contains('image') ||
        type.contains('jpg') ||
        type.contains('png')) {
      return Icons.image;
    } else if (type.contains('pdf')) {
      return Icons.picture_as_pdf;
    } else if (type.contains('video')) {
      return Icons.videocam;
    } else {
      return Icons.insert_drive_file;
    }
  }

  String _getFileTypeLabel(dynamic evidence) {
    final type = evidence.file.fileType?.toLowerCase() ?? '';
    if (type.contains('image') ||
        type.contains('jpg') ||
        type.contains('png')) {
      return 'IMG';
    } else if (type.contains('pdf')) {
      return 'PDF';
    } else if (type.contains('video')) {
      return 'VID';
    } else {
      return 'DOC';
    }
  }

  Color _getItemTypeColor(String itemType) {
    switch (itemType.toLowerCase()) {
      case 'equipo':
      case 'equipment':
        return Colors.blue;
      case 'servicio':
      case 'service':
        return Colors.green;
      case 'repuesto':
      case 'spare':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Métodos de acción para evidencias
  void _showAddEvidenceDialog() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Agregar Evidencia',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      controller.takePhoto();
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Cámara'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      controller.pickImage();
                    },
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galería'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Get.back();
                //controller.pickDocument();
              },
              icon: const Icon(Icons.attach_file),
              label: const Text('Documento'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _viewEvidence(dynamic evidence) {
    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Evidencia',
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*  Icon(
                        _getEvidenceIcon(evidence),
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8), */
                      Expanded(
                        child: Image.network(
                          evidence.file?.accessUrl ?? '',
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteEvidenceDialog(dynamic evidence) {
    Get.dialog(
      AlertDialog(
        title: const Text('Eliminar Evidencia'),
        content:
            const Text('¿Estás seguro de que quieres eliminar esta evidencia?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              //controller.deleteEvidence(evidence.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child:
                const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(ServiceSheet serviceSheet) {
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
                  color: Get.theme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Resumen',
                  style: Get.textTheme.titleLarge?.copyWith(
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
                _buildStatItem(
                  'Items',
                  '${serviceSheet.itemsCount}',
                  Icons.inventory_2_outlined,
                  Colors.blue,
                ),
                const SizedBox(width: 12),
                _buildStatItem(
                  'Total',
                  '\$${serviceSheet.totalAmount.toStringAsFixed(2)}',
                  Icons.attach_money,
                  Colors.green,
                ),
                const SizedBox(width: 12),
                _buildStatItem(
                  'Días',
                  _getDaysFromCreation(serviceSheet.createdOn),
                  Icons.schedule,
                  serviceSheet.isOverdue() ? Colors.red : Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Barra de progreso
            _buildProgressSection(serviceSheet),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
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
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(ServiceSheet serviceSheet) {
    final progress = _calculateProgress(serviceSheet);
    final progressColor = progress >= 1.0
        ? Colors.green
        : progress >= 0.5
            ? Colors.orange
            : Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progreso General',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: progressColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey.shade200,
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  colors: [
                    progressColor.withOpacity(0.8),
                    progressColor,
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _getProgressMessage(serviceSheet, progress),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActions() {
    return Obx(() {
      final serviceSheet = controller.serviceSheet.value;
      if (serviceSheet == null) return const SizedBox();

      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Progreso de upload (si hay archivos subiendo)
          if (controller.isUploading.value)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Subiendo evidencias...',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: controller.uploadProgress.value,
                    backgroundColor: Colors.grey.shade200,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Get.theme.primaryColor),
                  ),
                ],
              ),
            ),

          // Botón de evidencias
          if (controller.isExecutor.value || controller.isApproval.value)
            FloatingActionButton(
              heroTag: 'evidence',
              onPressed: () => _showAddEvidenceDialog(),
              backgroundColor: Colors.purple,
              child: const Icon(Icons.camera_alt, color: Colors.white),
              tooltip: 'Agregar evidencia',
            ),

          const SizedBox(height: 16),

          // Botón principal según el estado y rol
          if (controller.isExecutor.value && serviceSheet.isPending)
            FloatingActionButton.extended(
              heroTag: 'execute',
              onPressed: () => _showExecuteDialog(serviceSheet),
              backgroundColor: Colors.blue,
              icon: const Icon(Icons.play_arrow, color: Colors.white),
              label: const Text(
                'Ejecutar',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            )
          else if (controller.isApproval.value &&
              !serviceSheet.isPending &&
              !serviceSheet.isCompleted)
            FloatingActionButton.extended(
              heroTag: 'approve',
              onPressed: () => _showApprovalDialog(serviceSheet),
              backgroundColor: Colors.green,
              icon: const Icon(Icons.check_circle, color: Colors.white),
              label: const Text(
                'Aprobar',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            )
          else if (serviceSheet.isCompleted)
            FloatingActionButton.extended(
              heroTag: 'completed',
              onPressed: null,
              backgroundColor: Colors.green.shade300,
              icon: const Icon(Icons.done_all, color: Colors.white),
              label: const Text(
                'Completado',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      );
    });
  }

  // Métodos de utilidad adicionales
  double _calculateProgress(ServiceSheet serviceSheet) {
    double progress = 0.0;

    // Puntos por tener responsables asignados
    if (serviceSheet.executionResponsibleId != null) progress += 0.2;
    if (serviceSheet.approvalResponsibleId != null) progress += 0.2;

    // Puntos por tener items
    if (serviceSheet.itemsCount > 0) progress += 0.3;

    // Puntos por estado
    if (serviceSheet.isInProgress) progress += 0.2;
    if (serviceSheet.isCompleted) progress = 1.0;

    // Puntos por evidencias
    if (controller.evidences.isNotEmpty) progress += 0.1;

    return progress.clamp(0.0, 1.0);
  }

  String _getProgressMessage(ServiceSheet serviceSheet, double progress) {
    if (progress >= 1.0) {
      return '¡Hoja de servicio completada exitosamente!';
    } else if (progress >= 0.8) {
      return 'Casi terminado, solo faltan algunos detalles';
    } else if (progress >= 0.6) {
      return 'Buen progreso, continúa con la ejecución';
    } else if (progress >= 0.4) {
      return 'En progreso, agrega evidencias y completa items';
    } else if (progress >= 0.2) {
      return 'Inicio registrado, asigna responsables y items';
    } else {
      return 'Hoja de servicio recién creada, configura los detalles';
    }
  }

  String _getDaysFromCreation(DateTime? createdOn) {
    if (createdOn == null) return '0';
    final now = DateTime.now();
    final difference = now.difference(createdOn);
    return difference.inDays.toString();
  }

  // Método adicional para mostrar información detallada
  void _showDetailedStats() {
    final serviceSheet = controller.serviceSheet.value;
    if (serviceSheet == null) return;

    final progress = _calculateProgress(serviceSheet);

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Estadísticas Detalladas',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailedStatRow('Folio:', serviceSheet.folio ?? 'N/A'),
            _buildDetailedStatRow('Estado:', serviceSheet.statusName),
            _buildDetailedStatRow('Prioridad:', serviceSheet.priorityText),
            _buildDetailedStatRow('Items:', '${serviceSheet.itemsCount}'),
            _buildDetailedStatRow(
                'Total:', '\$${serviceSheet.totalAmount.toStringAsFixed(2)}'),
            _buildDetailedStatRow(
                'Evidencias:', '${controller.evidences.length}'),
            _buildDetailedStatRow('Progreso:', '${(progress * 100).round()}%'),
            _buildDetailedStatRow(
                'Días activa:', _getDaysFromCreation(serviceSheet.createdOn)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
