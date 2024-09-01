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
    // String? email = _auth.currentUser!.email;
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
            Text(
              '$_userName',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.7),
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
        // Add RefreshIndicator
        onRefresh: _fetchProducts, // Call _fetchProducts on refresh
        child: _userName == null
            ? const Center(
                child: CircularProgressIndicator()) // Center loading indicator
            : ListView(
                // Use ListView for scrollable content
                padding: const EdgeInsets.all(16.0), // Add padding
                children: [
                  const SizedBox(height: 10),
                  const SizedBox(height: 20), // Add spacing
                  ..._products.map((product) => ProductListItem(
                      productId: product['id'],
                      productName: product['name'] ??
                          'Unknown Product')), // List products
                ],
              ),
      ),
      drawer: DrawerWidget(),
    );
  }
}
// TODO: Move the Widget to another Page
class ProductListItem extends StatelessWidget {
  final String productId; // Add a named parameter
  final String productName; // Add a named parameter

  const ProductListItem({
    super.key,
    required this.productId, // Mark it as required
    required this.productName, // Mark it as required
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        title: Text(
          productName,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
        onTap: () {
          Navigator.pushNamed(context, '/product_details', arguments: {
            'productId': productId
          }); // Navigate to product details
        },
      ),
    );
  }
}
