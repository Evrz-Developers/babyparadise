import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marginpoint/components/custom_list_tile.dart';
import 'package:marginpoint/components/drawer.dart';
import 'package:marginpoint/pages/profile_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Hide the text initially and show it after 2 seconds
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String? email = _auth.currentUser!.email;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0), 
          children: [
          const SizedBox(height: 10),
            Column(
              children: [
                const SizedBox(height: 20),
              CustomListTile(
                itemName: 'Products',
                onTap: () {
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
      bottomNavigationBar: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: const Duration(seconds: 2),
        child: Padding(
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
      ),
      drawer: DrawerWidget(),
    );
  }
}
