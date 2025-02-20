import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/work_order_create_controller.dart';

class WorkOrderCreateView extends GetView<WorkOrderCreateController> {
  const WorkOrderCreateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Orden de Trabajo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Orden de Compra
                    TextField(
                      onChanged: (val) =>
                          controller.purchaseOrderId.value = val,
                      decoration: const InputDecoration(
                        labelText: 'Orden de Compra',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tipo de Orden
                    Obx(() => DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Tipo de Orden',
                            border: OutlineInputBorder(),
                          ),
                          value: controller.typeId.value,
                          items: controller.workOrderTypes
                              .map((type) => DropdownMenuItem(
                                    value: type.id,
                                    child: Text(type.name),
                                  ))
                              .toList(),
                          onChanged: (val) => controller.typeId.value = val,
                        )),
                    const SizedBox(height: 16),

                    // Responsable de Ejecución
                    Obx(() => DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Responsable de Ejecución',
                            border: OutlineInputBorder(),
                          ),
                          value: controller.executionResponsibleId.value,
                          items: controller.users
                              .map((user) => DropdownMenuItem(
                                    value: user.id,
                                    child: Text(user.fullName),
                                  ))
                              .toList(),
                          onChanged: (val) =>
                              controller.executionResponsibleId.value = val,
                        )),
                    const SizedBox(height: 16),

                    // Responsable de Aprobación
                    Obx(() => DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Responsable de Aprobación',
                            border: OutlineInputBorder(),
                          ),
                          value: controller.approvalResponsibleId.value,
                          items: controller.users
                              .map((user) => DropdownMenuItem(
                                    value: user.id,
                                    child: Text(user.fullName),
                                  ))
                              .toList(),
                          onChanged: (val) =>
                              controller.approvalResponsibleId.value = val,
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Sección de Items
            const Text(
              'Partidas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: controller.addItem,
              icon: const Icon(Icons.add),
              label: const Text('Agregar Partida'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 16),

            // Lista de Items
            Obx(() => Column(
                  children: controller.items
                      .map((item) => Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  TextField(
                                    onChanged: (val) => item.description = val,
                                    decoration: const InputDecoration(
                                      labelText: 'Descripción',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Tipo de Item
                                  DropdownButtonFormField<int>(
                                    decoration: const InputDecoration(
                                      labelText: 'Tipo de Item',
                                      border: OutlineInputBorder(),
                                    ),
                                    value: item.itemTypeId,
                                    items: [
                                      ...controller.itemTypes
                                          .where((type) =>
                                              type.id != null) // Filtrar nulos
                                          .map((type) => DropdownMenuItem(
                                                value: type.id,
                                                child: Text(type.name ?? ''),
                                              ))
                                    ],
                                    onChanged: (val) {
                                      if (val != null) {
                                        item.itemTypeId = val;
                                        // También actualizar el itemType completo
                                        item.itemType = controller.itemTypes
                                            .firstWhere(
                                                (type) => type.id == val,
                                                orElse: () =>
                                                    controller.itemTypes.first);
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: TextEditingController(
                                            text: item.quantity.toString(),
                                          ),
                                          onChanged: (val) => controller
                                              .updateQuantity(item, val),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            labelText: 'Cantidad',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          controller: TextEditingController(
                                            text: item.price.toString(),
                                          ),
                                          onChanged: (val) =>
                                              controller.updatePrice(item, val),
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          decoration: const InputDecoration(
                                            labelText: 'Precio Unitario',
                                            prefixText: '\$',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () =>
                                          controller.removeItem(item),
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.red),
                                      child: const Text('Eliminar'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                )),
            Obx(() => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                          Text(
                            '\$${controller.total.value.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancelar'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.submit,
                  child: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
