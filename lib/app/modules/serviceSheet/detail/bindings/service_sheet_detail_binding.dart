import 'package:alltech_app/app/modules/serviceSheet/services/providers/evidence_provider.dart';
import 'package:alltech_app/app/modules/serviceSheet/services/providers/file_upload_provider.dart';
import 'package:get/get.dart';

import '../controllers/service_sheet_detail_controller.dart';

class ServiceSheetDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FileUploadProvider>(() => FileUploadProvider());
    Get.lazyPut<EvidenceProvider>(() => EvidenceProvider());

    Get.lazyPut<ServiceSheetDetailController>(
      () => ServiceSheetDetailController(),
    );
  }
}
