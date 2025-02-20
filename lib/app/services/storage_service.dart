import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  final storage = GetStorage();

  Future<StorageService> init() async {
    await GetStorage.init();
    await initializeSession();
    return this;
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int userId,
    bool rememberSession = false,
  }) async {
    await storage.write('accessToken', accessToken);
    await storage.write('refreshToken', refreshToken);
    await storage.write('rememberSession', rememberSession);
    await storage.write('userId', userId);
  }

  String? getAccessToken() => storage.read('accessToken');
  String? getRefreshToken() => storage.read('refreshToken');
  bool get isRememberSession => storage.read('rememberSession') ?? false;
  int? getCurrentUserId() => storage.read('userId');

  Future<void> clearTokens() async {
    await storage.remove('accessToken');
    await storage.remove('refreshToken');
    await storage.remove('rememberSession');
    await storage.remove('userId');
  }

  bool hasValidSession() {
    final hasToken = getAccessToken() != null;
    final shouldRemember = storage.read('rememberSession') ?? false;

    return hasToken && shouldRemember;
  }

  Future<void> initializeSession() async {
    if (!isRememberSession) {
      await clearTokens();
    }
  }
}
