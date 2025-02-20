import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../users/models/uuser_model.dart';
import '../../models/evidence_model.dart';
import '../../models/service_sheet_item_model.dart';
import '../../models/service_sheet_model.dart';
import '../controllers/service_sheet_detail_controller.dart';

class ServiceSheetDetailView extends GetView<ServiceSheetDetailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
            () => Text('Hoja ${controller.serviceSheet.value?.folio ?? ""}')),
      ),
      bottomNavigationBar: Obx(() {
        if (!controller.isApproval.value && !controller.isExecutor.value) {
          return SizedBox();
        }

        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (controller.isExecutor.value)
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(
                      Icons.engineering,
                      color: Colors.white,
                    ),
                    label: Text('Marcar como Ejecutado'),
                    onPressed: () => controller.markAsExecuted(),
                  ),
                ),
              SizedBox(width: 16),
              if (controller.isApproval.value)
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    label: Text('Aprobar'),
                    onPressed: () => controller.markAsApproved(),
                  ),
                ),
            ],
          ),
        );
      }),
      body: Obx(() {
        final sheet = controller.serviceSheet.value;
        if (sheet == null) {
          return Center(child: Text('No se encontró la hoja de servicio'));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(
                'Información General',
                [
                  _buildInfoRow('Folio:', sheet.folio ?? ''),
                  _buildInfoRow('Prioridad:', _getPriorityText(sheet.priority)),
                  _buildInfoRow('Estado:', sheet.status?.name ?? ''),
                  _buildInfoRow('Fecha:', _formatDate(sheet.createdOn)),
                ],
              ),
              SizedBox(height: 16),
              _buildResponsiblesCard(sheet),
              SizedBox(height: 16),
              _buildItemsCard(sheet.serviceSheetItems ?? []),
              SizedBox(height: 16),
              _buildEvidencesCard(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiblesCard(ServiceSheet sheet) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Responsables',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            _buildResponsibleInfo(
              'Ejecutor',
              sheet.executionResponsible,
            ),
            Divider(),
            _buildResponsibleInfo(
              'Aprobador',
              sheet.approvalResponsible,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsCard(List<ServiceSheetItem> items) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Total: \$${controller.calculateTotal().toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(),
            ...items.map((item) => _buildItemTile(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildItemTile(ServiceSheetItem item) {
    final workOrderItem = item.workOrderItem;
    if (workOrderItem == null) return SizedBox();

    final total = (workOrderItem.price ?? 0) * (workOrderItem.quantity ?? 0);

    return ListTile(
      title: Text(workOrderItem.description ?? ''),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cantidad: ${workOrderItem.quantity}'),
          Text('Precio: \$${workOrderItem.price?.toStringAsFixed(2)}'),
          Text('Total: \$${total.toStringAsFixed(2)}'),
        ],
      ),
      trailing: Chip(
        label: Text(workOrderItem.itemType?.name ?? ''),
        backgroundColor: workOrderItem.itemType?.id == 1
            ? Colors.blue[100]
            : Colors.green[100],
      ),
    );
  }

  Widget _buildResponsibleInfo(String title, User? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        _buildInfoRow('Nombre:', user?.fullName ?? 'N/A'),
        _buildInfoRow('Email:', user?.email ?? 'N/A'),
        _buildInfoRow('Teléfono:', user?.phone ?? 'N/A'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
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

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  Widget _buildEvidencesCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Evidencias',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add_a_photo),
                  onPressed: () {
                    // TODO: Implementar carga de evidencias
                  },
                ),
              ],
            ),
            Divider(),
            Obx(() {
              if (controller.evidences.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No hay evidencias registradas'),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: controller.evidences.length,
                itemBuilder: (context, index) {
                  final evidence = controller.evidences[index];
                  return _buildEvidenceItem(evidence);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEvidenceItem(Evidence evidence) {
    final bool isImage = evidence.file?.fileType?.contains('image') ?? false;

    return InkWell(
      onTap: () => _handleEvidencePress(evidence),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: isImage
              ? Image.network(
                  evidence.file?.accessUrl ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildEvidenceErrorPlaceholder(),
                )
              : _buildFileTypeIcon(evidence.file?.fileType),
        ),
      ),
    );
  }

  Widget _buildFileTypeIcon(String? fileType) {
    IconData icon;
    Color color;

    switch (fileType?.split('/').first) {
      case 'application':
        icon = Icons.insert_drive_file;
        color = Colors.blue;
        break;
      case 'video':
        icon = Icons.videocam;
        color = Colors.red;
        break;
      case 'audio':
        icon = Icons.audiotrack;
        color = Colors.green;
        break;
      default:
        icon = Icons.insert_drive_file;
        color = Colors.grey;
    }

    return Container(
      color: color.withOpacity(0.1),
      child: Center(
        child: Icon(icon, size: 40, color: color),
      ),
    );
  }

  Widget _buildEvidenceErrorPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Icon(
        Icons.broken_image,
        color: Colors.grey[400],
        size: 40,
      ),
    );
  }

  void _handleEvidencePress(Evidence evidence) {
    final bool isImage = evidence.file?.fileType?.contains('image') ?? false;

    if (isImage) {
      Get.dialog(
        Dialog(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: Get.width * 0.8,
              maxHeight: Get.height * 0.8,
            ),
            child: Image.network(
              evidence.file?.accessUrl ?? '',
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    } else {
      // Implementar apertura de archivos no imagen
      launchUrl(Uri.parse(evidence.file?.accessUrl ?? ''));
    }
  }
}
