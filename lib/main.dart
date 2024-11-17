import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:babyparadise/firebase_options.dart';
import 'package:babyparadise/utils/firebase_utils.dart';
import 'package:get/get.dart';
import 'package:babyparadise/services/user_controller.dart';

import 'package:babyparadise/screens/shop_screen.dart';
import 'package:babyparadise/screens/cart_screen.dart';
import 'package:babyparadise/screens/intro_screen.dart';
import 'package:babyparadise/screens/admin_screen.dart';
import 'package:babyparadise/screens/staff_screen.dart';
import 'package:babyparadise/auth/login_screen.dart';
import 'package:babyparadise/themes/light_mode.dart';
import 'package:babyparadise/auth/signup_screen.dart';
import 'package:babyparadise/screens/admin/product_screen.dart';
import 'package:babyparadise/screens/products/product_detail_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: 'babyparadise', options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser = auth.currentUser;
  final UserController userController = Get.put(UserController());
  Map<String, dynamic>? userData = await getUserDetails();

  if (currentUser != null) {
    // ignore: avoid_print
    print("user-data exists: $userData");
    userData = await getUserDetails();
    userController.setUserDetails(
        isLoggedIn: true,
        id: userData != null ? userData['userId'] ?? '' : '',
        role: userData != null ? userData['role'] ?? '' : '',
        name: userData?['name'] ?? '',
        email: userData?['email'] ?? '');
  }
  Get.put(UserController()); // Bind UserController to GetX
  runApp(App(userData: userData));
}

class App extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const App({
    super.key,
    this.userData,
  });

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget buildHomePage(Map<String, dynamic>? userData) {
      if (userData == null) {
        return const LoginScreen();
      }
      String? userRole = userData['role'] ?? 'user';
      switch (userRole) {
        case 'admin':
          return const AdminPage();
        case 'staff':
          return const StaffPage();
        case 'user':
          return const ShopPage();
        default:
          return const LoginScreen();
      }
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Baby Paradise',
        theme: lightMode,
        home: userData != null ? buildHomePage(userData!) : const LoginScreen(),
        routes: {
          '/register': (context) => const SignUpScreen(),
          '/login': (context) => const LoginScreen(),
          '/intro': (context) => const IntroPage(),
          '/admin': (context) => const AdminPage(),
          '/staff': (context) => const StaffPage(),
          '/shop': (context) => const ShopPage(),
          '/cart': (context) => const CartPage(),
          '/admin_product': (context) => const ProductPage(),
          '/product_details': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments; // Get the arguments
            if (args is Map<String, dynamic>) {
              // Check if args is a Map
              final itemId =
                  args['itemId'] as String; // Extract itemId from the map
              return ProductDetailPage(
                  productId: itemId); // Pass the product ID to the page
            } else {
              // TODO: Change defaultId and do a fix for error handling
              return const ProductDetailPage(productId: 'defaultId');
            }
          },
        });
  }
}
