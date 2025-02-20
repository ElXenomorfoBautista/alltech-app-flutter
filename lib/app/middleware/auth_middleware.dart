import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';
import '../services/storage_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final storage = Get.find<StorageService>();
    final hasToken = storage.getAccessToken() != null;

    if (!hasToken && route != Routes.AUTH_LOGIN) {
      return const RouteSettings(name: Routes.AUTH_LOGIN);
    }

    if (hasToken && route == Routes.AUTH_LOGIN) {
      return const RouteSettings(name: Routes.HOME);
    }

    return null;
  }
}
