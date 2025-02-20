import 'package:alltech_app/app/modules/auth/services/providers/auth_service_provider.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthServiceProvider>(() => AuthServiceProvider());

    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
