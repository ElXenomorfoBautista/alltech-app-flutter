import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../services/storage_service.dart';
import '../../models/evidence_model.dart';
import '../../models/service_sheet_model.dart';
import '../../services/providers/evidence_provider.dart';
import '../../services/providers/file_upload_provider.dart';

class FileWithName {
  final File file;
  final String name;

  FileWithName({required this.file, required this.name});
}

class ServiceSheetDetailController extends GetxController {
  final serviceSheet = Rxn<ServiceSheet>();
  final evidences = <Evidence>[].obs;
  final isLoading = false.obs;
  final isUploading = false.obs;
  final uploadProgress = 0.0.obs;
  final currentUserId = Get.find<StorageService>().getCurrentUserId();
  final EvidenceProvider _evidenceProvider = Get.find<EvidenceProvider>();
  final FileUploadProvider _fileUploadProvider = Get.find<FileUploadProvider>();
  final isApproval = false.obs;
  final isExecutor = false.obs;

  // Lista de archivos seleccionados
  final selectedFiles = <FileWithName>[].obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    serviceSheet.value = Get.arguments as ServiceSheet;
    loadEvidences();
    getRoleApproval();
  }

  getRoleApproval() {
    isApproval.value =
        serviceSheet.value?.approvalResponsibleId == currentUserId;
    isExecutor.value =
        serviceSheet.value?.executionResponsibleId == currentUserId;
  }

  Future<void> loadEvidences() async {
    try {
      isLoading.value = true;
      final response = await _evidenceProvider.getEvidencesByEntity(
          2, // entityTypeId para ServiceSheet
          serviceSheet.value?.id ?? 0);

      if (response.status.isOk) {
        final apiResponse = response.body;
        evidences.value = (apiResponse as List)
            .map((item) => Evidence.fromJson(item))
            .toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Error al cargar evidencias');
    } finally {
      isLoading.value = false;
    }
  }

  double calculateTotal() {
    double total = 0;
    serviceSheet.value?.serviceSheetItems?.forEach((item) {
      final price = item.workOrderItem?.price ?? 0;
      final quantity = item.workOrderItem?.quantity ?? 0;
      total += price * quantity;
    });
    return total;
  }

  Future<void> markAsExecuted() async {
    try {
      isLoading.value = true;
      // Aquí iría tu lógica para marcar como ejecutado
      /*  await _serviceSheetProvider.updateStatus(serviceSheet.value?.id ?? 0,
          {'statusId': 3} // ID del estado "Ejecutado"
          ); */

      Get.snackbar(
        'Éxito',
        'Hoja de servicio marcada como ejecutada',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      await loadServiceSheet(); // Recargar datos
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo actualizar el estado',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsApproved() async {
    try {
      isLoading.value = true;
      // Aquí iría tu lógica para aprobar
      /*   await _serviceSheetProvider.updateStatus(serviceSheet.value?.id ?? 0,
          {'statusId': 6} // ID del estado "Aprobado"
          ); */

      Get.snackbar(
        'Éxito',
        'Hoja de servicio aprobada',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );

      await loadServiceSheet(); // Recargar datos
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo aprobar la hoja de servicio',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Métodos para la gestión de evidencias
  Future<void> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (photo != null) {
      addFileToSelection(File(photo.path), photo.name);
    }
  }

  Future<void> pickImage() async {
    final List<XFile>? images = await _picker.pickMultiImage(
      imageQuality: 80,
    );
    if (images != null && images.isNotEmpty) {
      for (var image in images) {
        addFileToSelection(File(image.path), image.name);
      }
    }
  }

  void addFileToSelection(File file, String fileName) {
    selectedFiles.add(FileWithName(file: file, name: fileName));
  }

  void removeFileFromSelection(int index) {
    if (index >= 0 && index < selectedFiles.length) {
      selectedFiles.removeAt(index);
    }
  }

  void updateFileName(int index, String newName) {
    if (index >= 0 && index < selectedFiles.length) {
      final file = selectedFiles[index].file;
      final currentName = selectedFiles[index].name;

      // Extraer la extensión del archivo
      final extension = currentName.contains('.')
          ? currentName.substring(currentName.lastIndexOf('.'))
          : '';

      // Asegurarse de que el nuevo nombre mantenga la extensión
      final nameWithExtension =
          newName.endsWith(extension) ? newName : newName + extension;

      selectedFiles[index] = FileWithName(file: file, name: nameWithExtension);
    }
  }

  void clearSelectedFiles() {
    selectedFiles.clear();
  }

  Future<void> uploadFiles() async {
    if (selectedFiles.isEmpty || serviceSheet.value?.id == null) {
      Get.snackbar(
        'Advertencia',
        'No hay archivos seleccionados para subir',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isUploading.value = true;
      uploadProgress.value = 0.0;

      // Simular progreso
      _simulateProgress();

      final files =
          selectedFiles.map((fileWithName) => fileWithName.file).toList();
      final customNames =
          selectedFiles.map((fileWithName) => fileWithName.name).toList();

      final response = await _fileUploadProvider.uploadMultipleFiles(
        files: files,
        serviceSheetId: serviceSheet.value!.id!,
        customNames: customNames,
      );

      if (response.status.isOk) {
        Get.snackbar(
          'Éxito',
          'Archivos subidos correctamente',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Recargar las evidencias
        await loadEvidences();

        // Limpiar archivos seleccionados
        clearSelectedFiles();
      } else {
        throw Exception('Error al subir los archivos: ${response.statusText}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudieron cargar los archivos: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0.0;
    }
  }

  void _simulateProgress() {
    // Esta función simula el progreso de la carga
    Future.delayed(Duration(milliseconds: 300), () {
      if (isUploading.value && uploadProgress.value < 1.0) {
        uploadProgress.value += 0.1;
        if (uploadProgress.value < 1.0) {
          _simulateProgress();
        }
      }
    });
  }

  Future<void> loadServiceSheet() async {
    // Implementa la lógica para recargar la hoja de servicio
  }
}
