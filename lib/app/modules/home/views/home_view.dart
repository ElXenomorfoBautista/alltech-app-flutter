import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../services/storage_service.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.toNamed(
              Routes.USERS_PROFILE,
              arguments: {
                'userId': Get.find<StorageService>().getCurrentUserId()
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              controller.logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'HomeView is working',
              style: TextStyle(fontSize: 20),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                Get.toNamed(Routes.USERS);
              },
              child: Text('Ir a usuarios'),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                Get.toNamed(Routes.WORK_ORDER);
              },
              child: Text('Ir a ordenes de trabajo'),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                Get.toNamed(Routes.SERVICE_SHEET);
              },
              child: Text('Ir a hojas de servicio'),
            )
          ],
        ),
      ),
    );
  }
}
