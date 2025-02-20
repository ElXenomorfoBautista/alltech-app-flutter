import 'package:get/get.dart';

import '../../auth/services/providers/auth_service_provider.dart';

class HomeController extends GetxController {
  final AuthServiceProvider _authService = Get.find<AuthServiceProvider>();

  @override
  void onInit() {
    super.onInit();
  }

  void logout() async {
    await _authService.logout();
  }
}
