import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/storage_service.dart';
import '../../models/evidence_model.dart';
import '../../models/service_sheet_model.dart';
import '../../services/providers/evidence_provider.dart';

class ServiceSheetDetailController extends GetxController {
  final serviceSheet = Rxn<ServiceSheet>();
  final evidences = <Evidence>[].obs;
  final isLoading = false.obs;
  final currentUserId = Get.find<StorageService>().getCurrentUserId();
  final EvidenceProvider _evidenceProvider = Get.find<EvidenceProvider>();
  final isApproval = false.obs;
  final isExecutor = true.obs;
  @override
  void onInit() {
    super.onInit();
    serviceSheet.value = Get.arguments as ServiceSheet;
    loadEvidences();
    //getRoleApproval();
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

  Future<void> loadServiceSheet() async {}
}
