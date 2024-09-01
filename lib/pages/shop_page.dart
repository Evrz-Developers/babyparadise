import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marginpoint/components/custom_list_tile.dart';
import 'package:marginpoint/components/drawer.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userName;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _fetchProducts();
  }

  // Fetch logged in user details if required:
  Future<void> _fetchUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _userName = userDoc['name'];
        _userRole = userDoc['role'];
      });
    }
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
              'Margin Point',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Spacer(),
            GestureDetector(
              onTap: () {
                if (_userRole == 'admin') {
                  Navigator.pushNamed(context, '/admin');
                }
              },
              child: Text(
                '$_userName',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context)
                      .colorScheme
                      .inversePrimary
                      .withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
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
              return _userName == null
                  ? const Center(
                      child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
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
