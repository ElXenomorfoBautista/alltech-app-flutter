import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';

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
                _buildEvidenceActions(),
              ],
            ),
            Divider(),
            // Mostrar archivos seleccionados
            Obx(() {
              if (controller.selectedFiles.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Archivos seleccionados (${controller.selectedFiles.length}):',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.selectedFiles.length,
                      itemBuilder: (context, index) {
                        final fileWithName = controller.selectedFiles[index];
                        return _buildSelectedFileItem(index, fileWithName);
                      },
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          icon: Icon(Icons.clear),
                          label: Text('Limpiar'),
                          onPressed: () => controller.clearSelectedFiles(),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton.icon(
                          icon: Icon(Icons.cloud_upload),
                          label: Text('Subir todos'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () => controller.uploadFiles(),
                        ),
                      ],
                    ),
                    Divider(),
                  ],
                );
              }
              return SizedBox();
            }),
            // Mostrar progreso de carga si está subiendo
            Obx(() {
              if (controller.isUploading.value) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Text(
                        'Subiendo archivos...',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: controller.uploadProgress.value,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ],
                  ),
                );
              }
              return SizedBox();
            }),
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

  Widget _buildSelectedFileItem(int index, FileWithName fileWithName) {
    final file = fileWithName.file;
    final fileName = fileWithName.name;

    // Extraer nombre sin extensión para mostrar en el campo de texto
    final String nameWithoutExtension = fileName.contains('.')
        ? fileName.substring(0, fileName.lastIndexOf('.'))
        : fileName;

    final isImage = fileName.toLowerCase().endsWith('.jpg') ||
        fileName.toLowerCase().endsWith('.jpeg') ||
        fileName.toLowerCase().endsWith('.png');

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isImage
                ? Colors.blue.withOpacity(0.1)
                : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isImage ? Icons.image : Icons.insert_drive_file,
            color: isImage ? Colors.blue : Colors.orange,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: nameWithoutExtension,
              onChanged: (value) => controller.updateFileName(index, value),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                border: InputBorder.none,
                hintText: 'Nombre del archivo',
              ),
            ),
            // Mostrar la extensión en un texto pequeño de color gris
            if (fileName.contains('.'))
              Text(
                fileName.substring(fileName.lastIndexOf('.')),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
          ],
        ),
        subtitle: Text('${_formatFileSize(file.lengthSync())}'),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => controller.removeFileFromSelection(index),
        ),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  Widget _buildEvidenceActions() {
    // Solo mostrar botones si el usuario es ejecutor o aprobador
    if (!controller.isExecutor.value && !controller.isApproval.value) {
      return SizedBox();
    }

    return PopupMenuButton<String>(
      icon: Icon(Icons.add_a_photo),
      tooltip: 'Agregar evidencia',
      onSelected: (value) {
        switch (value) {
          case 'camera':
            controller.takePhoto();
            break;
          case 'gallery':
            controller.pickImage();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'camera',
          child: Row(
            children: [
              Icon(Icons.camera_alt, color: Colors.blue),
              SizedBox(width: 8),
              Text('Tomar foto'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'gallery',
          child: Row(
            children: [
              Icon(Icons.photo_library, color: Colors.green),
              SizedBox(width: 8),
              Text('Seleccionar imágenes'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'file',
          child: Row(
            children: [
              Icon(Icons.attach_file, color: Colors.orange),
              SizedBox(width: 8),
              Text('Seleccionar archivos'),
            ],
          ),
        ),
      ],
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
        child: Stack(
          children: [
            ClipRRect(
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
            // Mostrar fecha en la esquina inferior
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  _formatShortDate(evidence.createdOn),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatShortDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yy').format(date);
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: Text('Evidencia'),
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.download),
                      onPressed: () => _downloadEvidence(evidence),
                    ),
                  ],
                ),
                Expanded(
                  child: Image.network(
                    evidence.file?.accessUrl ?? '',
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
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
      );
    } else {
      // Implementar apertura de archivos no imagen
      _downloadEvidence(evidence);
    }
  }

  void _downloadEvidence(Evidence evidence) {
    if (evidence.file?.accessUrl != null) {
      launchUrl(Uri.parse(evidence.file!.accessUrl!));
    }
  }
}
