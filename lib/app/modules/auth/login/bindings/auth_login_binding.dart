import 'package:get/get.dart';
import '../../services/providers/auth_service_provider.dart';
import '../controllers/auth_login_controller.dart';

class AuthLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthLoginController>(
      () => AuthLoginController(),
    );
    Get.lazyPut<AuthServiceProvider>(() => AuthServiceProvider());
  }
}
