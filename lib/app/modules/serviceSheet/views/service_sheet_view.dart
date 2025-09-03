import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/service_sheet_controller.dart';

// service_sheet_view.dart
class ServiceSheetView extends GetView<ServiceSheetController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hojas de Servicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => {
              Get.toNamed(
                Routes.SERVICE_SHEET_CREATE,
              )
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: controller.getServiceSheets,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.serviceSheets.length,
          itemBuilder: (context, index) {
            final sheet = controller.serviceSheets[index];
            return Card(
              child: ListTile(
                title: Text('Folio: ${sheet.folio}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Prioridad: ${_getPriorityText(sheet.priority)}'),
                    Text('Estado: ${sheet.status?.name ?? "N/A"}'),
                    Text(
                        'Ejecutor: ${sheet.executionResponsible?.firstName ?? "N/A"}'),
                  ],
                ),
                onTap: () =>
                    Get.toNamed(Routes.SERVICE_SHEET_DETAIL, arguments: sheet),
              ),
            );
          },
        );
      }),
    );
  }

  String _getPriorityText(int? priority) {
    switch (priority) {
      case 1:
        return 'Alta';
      case 2:
        return 'Media';
      case 3:
        return 'Baja';
      default:
        return 'N/A';
    }
  }
}
