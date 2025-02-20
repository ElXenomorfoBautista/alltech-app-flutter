import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../users/models/uuser_model.dart';
import '../../models/work_order_item_model.dart';
import '../controllers/work_order_detail_controller.dart';

class WorkOrderDetailView extends GetView<WorkOrderDetailController> {
  const WorkOrderDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Obx(() => Text('Orden ${controller.workOrder.value?.folio ?? ""}')),
      ),
      body: Obx(() {
        final workOrder = controller.workOrder.value;
        if (workOrder == null) {
          return const Center(child: Text('No se encontró la orden'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(
                context,
                'Información General',
                [
                  _infoRow('Folio:', workOrder.folio ?? ''),
                  _infoRow('Orden de Compra:', workOrder.purchaseOrderId ?? ''),
                  _infoRow('Estado:', workOrder.status?.name ?? ''),
                  _infoRow('Tipo:', workOrder.type?.name ?? ''),
                  _infoRow(
                      'Fecha:',
                      workOrder.createdOn?.toLocal().toString().split('.')[0] ??
                          ''),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                'Responsables',
                [
                  _buildResponsibleInfo(
                      'Ejecutor', workOrder.executionResponsible),
                  const Divider(),
                  _buildResponsibleInfo(
                      'Aprobador', workOrder.approvalResponsible),
                ],
              ),
              const SizedBox(height: 16),
              _buildItemsCard(context, workOrder.workOrderItems ?? []),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildResponsibleInfo(String title, User? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _infoRow('Nombre:', user?.fullName ?? 'N/A'),
        _infoRow('Email:', user?.email ?? 'N/A'),
        _infoRow('Teléfono:', user?.phone ?? 'N/A'),
      ],
    );
  }

  Widget _buildItemsCard(BuildContext context, List<WorkOrderItem> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Items', style: Theme.of(context).textTheme.titleLarge),
                Text(
                  'Total: \$${controller.calculateTotal().toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            ...items.map((item) => _buildItemTile(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildItemTile(WorkOrderItem item) {
    final total = (item.price ?? 0) * item.quantity;
    return ListTile(
      title: Text(item.description),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cantidad: ${item.quantity}'),
          Text('Precio: \$${item.price}'),
          Text('Total: \$${total.toStringAsFixed(2)}'),
        ],
      ),
      trailing: Chip(
        label: Text(item.itemType.name ?? ''),
        backgroundColor:
            item.itemType.id == 1 ? Colors.blue[100] : Colors.green[100],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
