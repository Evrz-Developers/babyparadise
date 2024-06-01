import 'package:flutter/material.dart';
import 'package:marginpoint/models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.shopping_basket),
        Text(product.name),
        Text(product.description),
        Text(product.price.toStringAsFixed(2)),
      ],
    );
  }
}
