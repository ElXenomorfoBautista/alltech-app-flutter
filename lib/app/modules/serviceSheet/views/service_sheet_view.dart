import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/theme_toggle_widget.dart';
import '../controllers/service_sheet_controller.dart';

class ServiceSheetView extends GetView<ServiceSheetController> {
  const ServiceSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: controller.refreshServiceSheets,
        child: Column(
          children: [
            // Filtros y búsqueda
            _buildSearchAndFilters(context),

            // Lista de service sheets
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildLoadingState();
                }

                if (controller.serviceSheets.isEmpty) {
                  return _buildEmptyState(context);
                }

                return _buildServiceSheetsList(context);
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Hojas de Servicio'),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: Theme.of(context).primaryColor,
      actions: [
        // Filtros
        IconButton(
          icon: Badge(
            isLabelVisible: controller.hasActiveFilters.value,
            child: const Icon(Icons.filter_list),
          ),
          onPressed: () => _showFiltersBottomSheet(context),
          tooltip: 'Filtros',
        ),

        // Toggle de tema
        ThemeToggleWidget(
          showLabel: false,
          showSettingsButton: false,
        ),

        // Menú más opciones
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) {
            switch (value) {
              case 'refresh':
                controller.refreshServiceSheets();
                break;
              case 'export':
                _showExportOptions(context);
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'refresh',
              child: Row(
                children: [
                  Icon(Icons.refresh, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  const Text('Actualizar'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  Icon(Icons.download, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  const Text('Exportar'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          // Barra de búsqueda
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Buscar por folio, prioridad...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Obx(() {
                  if (controller.searchQuery.value.isEmpty) ;
                  return IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: controller.clearSearch,
                  );
                }),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Chips de filtros rápidos
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  'Todas',
                  controller.selectedStatus.value.isEmpty,
                  () => controller.setStatusFilter(''),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'Pendientes',
                  controller.selectedStatus.value == 'pending',
                  () => controller.setStatusFilter('pending'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'En Proceso',
                  controller.selectedStatus.value == 'in_progress',
                  () => controller.setStatusFilter('in_progress'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'Completadas',
                  controller.selectedStatus.value == 'completed',
                  () => controller.setStatusFilter('completed'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'Alta Prioridad',
                  controller.showHighPriority.value,
                  () => controller.toggleHighPriority(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: Get.theme.primaryColor.withOpacity(0.2),
      checkmarkColor: Get.theme.primaryColor,
      labelStyle: TextStyle(
        color: selected ? Get.theme.primaryColor : Colors.grey[600],
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildServiceSheetsList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.filteredServiceSheets.length,
      itemBuilder: (context, index) {
        final serviceSheet = controller.filteredServiceSheets[index];
        return _buildServiceSheetCard(context, serviceSheet, index);
      },
    );
  }

  Widget _buildServiceSheetCard(
      BuildContext context, dynamic serviceSheet, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.toNamed(
            Routes.SERVICE_SHEET_DETAIL,
            arguments: serviceSheet,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con folio y prioridad
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serviceSheet.folio ?? 'Sin folio',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Orden: ${serviceSheet.workOrder?.folio ?? "N/A"}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ),
                    _buildPriorityChip(serviceSheet.priority),
                  ],
                ),

                const SizedBox(height: 16),

                // Estado y fecha
                Row(
                  children: [
                    _buildStatusChip(serviceSheet.status?.name ?? 'Sin estado'),
                    const Spacer(),
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(serviceSheet.createdOn),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Información de responsables
                _buildResponsibleInfo(context, serviceSheet),

                const SizedBox(height: 12),

                // Items info
                if (serviceSheet.serviceSheetItems?.isNotEmpty ?? false)
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${serviceSheet.serviceSheetItems?.length ?? 0} items',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '\$${_calculateTotal(serviceSheet).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(int? priority) {
    final priorityData = _getPriorityData(priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: priorityData['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: priorityData['color']),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            priorityData['icon'],
            size: 14,
            color: priorityData['color'],
          ),
          const SizedBox(width: 4),
          Text(
            priorityData['text'],
            style: TextStyle(
              color: priorityData['color'],
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final statusColor = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildResponsibleInfo(BuildContext context, dynamic serviceSheet) {
    return Row(
      children: [
        // Ejecutor
        Expanded(
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue.shade100,
                child: Icon(
                  Icons.build,
                  size: 16,
                  color: Colors.blue.shade600,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ejecutor',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      serviceSheet.executionResponsible?.firstName ??
                          'No asignado',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Separador
        Container(
          height: 24,
          width: 1,
          color: Colors.grey.shade300,
        ),

        // Aprobador
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.green.shade100,
                  child: Icon(
                    Icons.verified,
                    size: 16,
                    color: Colors.green.shade600,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aprobador',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        serviceSheet.approvalResponsible?.firstName ??
                            'No asignado',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Cargando hojas de servicio...'),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
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
            'No hay hojas de servicio',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea tu primera hoja de servicio tocando el botón +',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed(Routes.SERVICE_SHEET_CREATE),
            icon: const Icon(Icons.add),
            label: const Text('Crear Hoja de Servicio'),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Get.toNamed(Routes.SERVICE_SHEET_CREATE),
      tooltip: 'Crear Hoja de Servicio',
      child: const Icon(Icons.add),
    );
  }

  void _showFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
              'Filtros',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            // Aquí irían los filtros adicionales
            const Text('Filtros avanzados próximamente...'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const Text('Aplicar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Opciones de Exportación',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Exportar como PDF'),
              onTap: () {
                Get.back();
                // controller.exportToPDF();
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Exportar como Excel'),
              onTap: () {
                Get.back();
                // controller.exportToExcel();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Métodos de utilidad
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

  double _calculateTotal(dynamic serviceSheet) {
    double total = 0.0;
    final items = serviceSheet.serviceSheetItems;
    if (items != null) {
      for (var item in items) {
        final workOrderItem = item.workOrderItem;
        if (workOrderItem != null) {
          final price = workOrderItem.price ?? 0.0;
          final quantity = workOrderItem.quantity ?? 0;
          total += price * quantity;
        }
      }
    }
    return total;
  }
}
