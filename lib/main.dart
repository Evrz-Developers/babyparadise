import 'package:flutter/material.dart';
import 'package:marginpoint/utils/firebase_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:marginpoint/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:marginpoint/auth/login_screen.dart';
import 'package:marginpoint/auth/signup_screen.dart';
import 'package:marginpoint/pages/admin/product_page.dart';
import 'package:marginpoint/pages/admin_page.dart';
import 'package:marginpoint/pages/cart_page.dart';
import 'package:marginpoint/pages/intro_page.dart';
import 'package:marginpoint/pages/shop_page.dart';
import 'package:marginpoint/pages/staff_page.dart';
import 'package:marginpoint/themes/light_mode.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: 'marginpoint', options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser = auth.currentUser;
  Map<String, dynamic>? userData = await getUserDetails();

  if (currentUser != null) {
    print("user-data exists: $userData");
    userData = await getUserDetails();
  }
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
        title: 'Margin-Point',
        theme: lightMode,
        // home:
        //     _auth.currentUser != null ? const ShopPage() : const LoginScreen(),
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
        });
  }
}
