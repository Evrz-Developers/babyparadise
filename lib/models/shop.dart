import 'package:marginpoint/models/product.dart';

class Shop {
  // products for sale
  final List<Product> _shop = [
// product 1
    Product(
      name: "Product 1",
      price: 99.99,
      description: "Item description..",
    ),
// product 2
    Product(
      name: "Product 2",
      price: 99.99,
      description: "Item description..",
    ),
// product 3
    Product(
      name: "Product 3",
      price: 99.99,
      description: "Item description..",
    ),
// product 4
    Product(
      name: "Product 4",
      price: 99.99,
      description: "Item description..",
    ),
  ];
// user cart
  List<Product> _cart = [];
// get product list
  List<Product> get shop => _shop;
// get user cart
  List<Product> get cart => _cart;
// add item to cart
  void addToCart(Product item) {
    _cart.add(item);
  }

// remove item from cart
  void removeFromCart(Product item) {
    _cart.remove(item);
  }
}
