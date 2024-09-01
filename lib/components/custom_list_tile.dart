import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final void Function()? onTap; // Optional onTap function
  final String? itemId;
  final String itemName;

  const CustomListTile({
    super.key,
    this.onTap,
    this.itemId,
    required this.itemName,
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
          itemName,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
        onTap: () {
          if (onTap != null) {
            onTap!(); // Call the provided onTap function
          } else if (itemId != null) {
            Navigator.pushNamed(context, '/product_details', arguments: {
              'itemId': itemId,
            }); // Navigate to product details if itemId is provided
          } // Navigate to product details
        },
      ),
    );
  }
}
