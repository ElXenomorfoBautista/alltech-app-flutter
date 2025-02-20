import 'package:get/get.dart';

import '../services/providers/user_service_provider.dart';

class UsersController extends GetxController {
  final UserProvider _userProvider = Get.find<UserProvider>();

  final isLoading = false.obs;
  final users = [].obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    getUsers();
    super.onInit();
  }

  Future<void> getUsers() async {
    try {
      isLoading.value = true;
      final response = await _userProvider.getUsers();

      if (response.status.isOk) {
        users.value = response.body;
      } else {
        errorMessage.value = response.statusText ?? 'Error al obtener usuarios';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshUsers() async {
    await getUsers();
  }
}
