import 'package:get/get.dart';

import '../controllers/service_sheet_controller.dart';
import '../services/providers/service_sheet_provider.dart';

// bindings.dart
class ServiceSheetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServiceSheetProvider());
    Get.lazyPut(() => ServiceSheetController());
  }
}
