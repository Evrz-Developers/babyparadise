import 'package:flutter/material.dart';
import 'package:babyparadise/screens/admin/add_product_form.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Product List'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 10,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProductForm()),
              );
            },
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Center(
                child: Text(
                  'Add Product',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Scrollbar(
                child: Center(
                  child: ListView(
                    children: const [
                      // TODO: Add product list here
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
