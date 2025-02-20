import 'package:get/get.dart';

import '../../services/providers/user_service_provider.dart';
import '../controllers/users_profile_controller.dart';

class UsersProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserProvider>(() => UserProvider());

    Get.lazyPut<UsersProfileController>(
      () => UsersProfileController(),
    );
  }
}
