import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/users_profile_controller.dart';

class UsersProfileView extends GetView<UsersProfileController> {
  const UsersProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
            () => Text(controller.user.value?.username ?? 'Perfil de Usuario')),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.user.value;
        if (user == null) {
          return const Center(child: Text('No se encontró el usuario'));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    user.imageUrl != null ? NetworkImage(user.imageUrl!) : null,
                child: user.imageUrl == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                user.fullName,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Username: ${user.username}'),
              if (user.email != null) Text('Email: ${user.email}'),
              if (user.phone != null) Text('Teléfono: ${user.phone}'),
              const SizedBox(height: 16),
              Text(
                  'Última conexión:  ${user.lastLogin == null ? 'Ninguna' : user.lastLogin.toString()}'),
            ],
          ),
        );
      }),
    );
  }
}
