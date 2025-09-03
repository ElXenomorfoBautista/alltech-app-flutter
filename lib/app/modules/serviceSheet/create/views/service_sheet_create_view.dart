import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/service_sheet_create_controller.dart';

class ServiceSheetCreateView extends GetView<ServiceSheetCreateController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nueva Hoja de Servicio')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Orden de Trabajo',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Obx(() => DropdownButtonFormField<int>(
                          value: controller.workOrderId.value,
                          items: controller.workOrders
                              .map((wo) => DropdownMenuItem(
                                    value: wo.id,
                                    child:
                                        Text('${wo.folio} - ${wo.type?.name}'),
                                  ))
                              .toList(),
                          onChanged: (id) {
                            if (id != null) {
                              controller.onWorkOrderSelected(id);
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Seleccionar Orden',
                          ),
                        )),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Prioridad',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Obx(() => DropdownButtonFormField<int>(
                          value: controller.priority.value,
                          items: [
                            DropdownMenuItem(value: 1, child: Text('Alta')),
                            DropdownMenuItem(value: 2, child: Text('Media')),
                            DropdownMenuItem(value: 3, child: Text('Baja')),
                          ],
                          onChanged: (value) =>
                              controller.priority.value = value,
                          decoration: InputDecoration(
                            labelText: 'Seleccionar Prioridad',
                            hintText: 'Seleccione la prioridad',
                          ),
                        )),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Responsables',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Obx(() => DropdownButtonFormField<int>(
                          value: controller.executionResponsibleId.value,
                          items: controller.users
                              .map((user) => DropdownMenuItem(
                                    value: user.id,
                                    child: Text(user.fullName),
                                  ))
                              .toList(),
                          onChanged: (id) =>
                              controller.executionResponsibleId.value = id,
                          decoration: InputDecoration(
                            labelText: 'Responsable de Ejecución',
                          ),
                        )),
                    SizedBox(height: 16),
                    Obx(() => DropdownButtonFormField<int>(
                          value: controller.approvalResponsibleId.value,
                          items: controller.users
                              .map((user) => DropdownMenuItem(
                                    value: user.id,
                                    child: Text(user.fullName),
                                  ))
                              .toList(),
                          onChanged: (id) =>
                              controller.approvalResponsibleId.value = id,
                          decoration: InputDecoration(
                            labelText: 'Responsable de Aprobación',
                          ),
                        )),
                  ],
                ),
              ),
            ),

            // Sección de Items
            // Reemplazar la sección de Items existente
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Items de la Orden',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Divider(),
                    Obx(() => ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.availableItems.length,
                          itemBuilder: (context, index) {
                            final item = controller.availableItems[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: Obx(() => CheckboxListTile(
                                    // Añadimos Obx aquí
                                    title: Text(item.description ?? ''),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Cantidad: ${item.quantity}'),
                                        Text(
                                            'Precio: \$${item.price?.toStringAsFixed(2)}'),
                                        Text(
                                            'Tipo: ${item.itemType?.name ?? 'N/A'}'),
                                      ],
                                    ),
                                    value: controller.selectedItemIds.contains(
                                        item.id), // Cambiamos la verificación
                                    onChanged: (_) =>
                                        controller.toggleItem(item),
                                    secondary: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: item.itemType?.id == 1
                                            ? Colors.blue[100]
                                            : Colors.green[100],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(item.itemType?.name ?? 'N/A'),
                                    ),
                                  )),
                            );
                          },
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Cancelar'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.submit,
                  child: Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
