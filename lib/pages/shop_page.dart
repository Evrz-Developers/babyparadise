import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marginpoint/components/custom_list_tile.dart';
import 'package:marginpoint/components/drawer.dart';
import 'package:marginpoint/pages/profile_page.dart';
import 'package:get/get.dart';
import 'package:marginpoint/services/user_controller.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserController userController = Get.find();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  // Fetch products{}
  List<Map<String, dynamic>> _products = [];
  Future<void> _fetchProducts() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        QuerySnapshot productDocs =
            await FirebaseFirestore.instance.collection('products').get();
        if (productDocs.docs.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No products found.")),
            );
          }
        } else {
          _products = productDocs.docs.map((doc) {
            return {
              'id': doc.id,
              'name': doc['name'] ?? 'Unknown Item',
            };
          }).toList();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading products: $e')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Not logged in.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            const Text(
              'Baby Paradise',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Spacer(),
            // Cart icon
            if (userController.userRole != 'admin')
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),

            // Dashboard icon
            if (userController.userRole == 'admin')
              GestureDetector(
                  onTap: () {
                    if (userController.userRole == 'admin') {
                  Navigator.pushNamed(context, '/admin');
                }
              },
                  child: const Row(
                    children: [
                      Text(
                        'Dashboard ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ), // Add this linebetween text and icon
                      Icon(Icons.dashboard_rounded, size: 20),
                    ],
                  )),
  
          ],
        ),
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
        // centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchProducts,
        child: FutureBuilder<void>(
          future: _fetchProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return !userController.isLoggedIn
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        Text(userController.userName),
                        const SizedBox(height: 10),
                        const SizedBox(height: 20),
                        ..._products.map(
                          (product) => CustomListTile(
                            itemName: product['name'],
                            itemId: product['id'],
                          ),
                        ),
                      ],
                    );
            }
          },
        ),
      ),
      drawer: DrawerWidget(),
    );
  }
}
