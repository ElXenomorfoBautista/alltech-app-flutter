import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/work_order_controller.dart';

class WorkOrderView extends GetView<WorkOrderController> {
  const WorkOrderView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Órdenes de Trabajo'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => {
              Get.toNamed(
                Routes.WORK_ORDER_CREATE,
              )
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshWorkOrders,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.workOrders.isEmpty) {
          return const Center(
              child: Text('No hay órdenes de trabajo disponibles'));
        }
        return ListView.builder(
          itemCount: controller.workOrders.length,
          itemBuilder: (context, index) {
            final workOrder = controller.workOrders[index];

            Widget cardWidget = Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(
                  'Folio: ${workOrder.folio}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('Tipo: ${workOrder.type?.name ?? 'N/A'}'),
                    Text(
                        'Responsable: ${workOrder.executionResponsible?.fullName ?? 'N/A'}'),
                    Text(
                        'Fecha: ${workOrder.createdOn?.toLocal().toString().split('.')[0] ?? 'N/A'}'),
                    Text('Estado: ${workOrder.status?.name ?? 'N/A'}'),
                  ],
                ),
                isThreeLine: true,
                onTap: () => Get.toNamed(
                  Routes.WORK_ORDER_DETAIL,
                  arguments: {'workOrder': workOrder},
                ),
              ),
            );

            return Obx(() => controller.isAdmin.value
                ? Dismissible(
                    key: Key(workOrder.id.toString()),
                    background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:
                          const Icon(Icons.check_circle, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        // Eliminar
                        return await Get.dialog<bool>(
                          AlertDialog(
                            title: const Text('Confirmar Eliminación'),
                            content: const Text(
                                '¿Estás seguro de eliminar esta orden?'),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(result: false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Get.back(result: true),
                                child: const Text('Eliminar'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Aprobar
                        return await Get.dialog<bool>(
                          AlertDialog(
                            title: const Text('Confirmar Aprobación'),
                            content: const Text(
                                '¿Estás seguro de aprobar esta orden?'),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(result: false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Get.back(result: true),
                                child: const Text('Aprobar'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        controller.deleteWorkOrder(workOrder.id!);
                      } else {
                        controller.markAsDone(workOrder.id!);
                      }
                    },
                    child: cardWidget,
                  )
                : cardWidget);
          },
        );
      }),
    );
  }
}
