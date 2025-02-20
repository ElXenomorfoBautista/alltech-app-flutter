import 'package:get/get.dart';

import '../../../../core/models/api_response.dart';
import '../../models/uuser_model.dart';
import '../../services/providers/user_service_provider.dart';

class UsersProfileController extends GetxController {
  final UserProvider _userProvider = Get.find<UserProvider>();
  final user = Rxn<User>();
  final isLoading = false.obs;
  final userId = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    userId.value = Get.arguments?['userId'];
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    if (userId.value == null) return;

    try {
      isLoading.value = true;
      final response = await _userProvider.getUserProfile(userId.value!);

      if (response.status.isOk) {
        final apiResponse = response.body as ApiResponse<User>;
        user.value = apiResponse.data;
      } else {
        Get.snackbar(
          'Error',
          response.statusText ?? 'Error al cargar perfil',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
