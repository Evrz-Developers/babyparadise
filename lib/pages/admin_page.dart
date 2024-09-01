import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marginpoint/components/custom_list_tile.dart';
import 'package:marginpoint/components/drawer.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    String? email = _auth.currentUser!.email;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Admin Dashboard'),
        centerTitle: true,
      ),
      body: Center(
        child:
            // padding: EdgeInsets.zero,
            Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                ColoredListTile(
                  title: 'Products',
                  onTap: () {
                    // Navigate to products section
                    if (mounted) {
                      Navigator.pushNamed(context, '/admin_product');
                    }
                  },
                ),
              CustomListTile(
                itemName: 'Categories',
                  onTap: () {
                  // TODO: Navigate to categories section
                  },
                ),
              CustomListTile(
                itemName: 'Users',
                  onTap: () {
                  // TODO: Navigate to users section
                  },
                ),
              ],
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Logged in as: $email',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      drawer: DrawerWidget(),
    );
  }
}
