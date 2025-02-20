import 'package:get/get.dart';

import '../controllers/users_controller.dart';
import '../services/providers/user_service_provider.dart';

class UsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserProvider>(() => UserProvider());

    Get.lazyPut<UsersController>(
      () => UsersController(),
    );
  }
}
