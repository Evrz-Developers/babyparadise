import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marginpoint/components/colored_list_tile.dart';
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
                SizedBox(height: 20),
                ColoredListTile(
                  title: 'Products',
                  onTap: () {
                    // Navigate to products section
                    if (mounted) {
                      Navigator.pushNamed(context, '/admin_product');
                    }
                  },
                ),
                ColoredListTile(
                  title: 'Categories',
                  onTap: () {
                    // Navigate to categories section
                  },
                ),
                ColoredListTile(
                  title: 'Users',
                  onTap: () {
                    // Navigate to users section
                  },
                ),
              ],
            ),
            Center(
              child: ListTile(
                title: Text('Logged in as $email'),
              ),
            ),
          ],
        ),
      ),
      drawer: DrawerWidget(),
    );
  }
}
