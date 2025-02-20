// service_sheet_controller.dart
import 'package:get/get.dart';

import '../models/service_sheet_model.dart';
import '../services/providers/service_sheet_provider.dart';

class ServiceSheetController extends GetxController {
  final ServiceSheetProvider _provider = Get.find<ServiceSheetProvider>();
  final serviceSheets = <ServiceSheet>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getServiceSheets();
  }

  Future<void> getServiceSheets() async {
    try {
      isLoading.value = true;
      final response = await _provider.getServiceSheetsUser();

      if (response.status.isOk) {
        final apiResponse = response.body;
        serviceSheets.value = (apiResponse['data'] as List)
            .map((item) => ServiceSheet.fromJson(item))
            .toList();
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
