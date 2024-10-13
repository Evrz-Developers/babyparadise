import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marginpoint/services/user_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: Text('User ID: ${userController.userId}'),
          ),
          ListTile(
            title: Text(
                'Status: ${userController.isLoggedIn ? 'Logged In' : 'Logged Out'}'),
          ),
          ListTile(
            title: Text('User Role: ${userController.userRole}'),
          ),
          ListTile(
            title: Text('User Name: ${userController.userName}'),
          ),
          ListTile(
            title: Text('User Email: ${userController.userEmail}'),
          ),
        ],
      ),
    );
  }
}
