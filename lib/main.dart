import 'package:flutter/material.dart';
import 'package:marginpoint/utils/firebase_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:marginpoint/auth/login_screen.dart';
import 'package:marginpoint/auth/signup_screen.dart';
import 'package:marginpoint/firebase_options.dart';
import 'package:marginpoint/pages/admin/product_page.dart';
import 'package:marginpoint/pages/admin_page.dart';
import 'package:marginpoint/pages/cart_page.dart';
import 'package:marginpoint/pages/intro_page.dart';
import 'package:marginpoint/pages/shop_page.dart';
import 'package:marginpoint/pages/staff_page.dart';
import 'package:marginpoint/themes/light_mode.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Map<String, dynamic>? userData = await getUserDetails();
  print("user-data: $userData");
  runApp(App());
}

class App extends StatelessWidget {
  final Map<String, dynamic>? userData;

  App({
    super.key,
    this.userData,
  });

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget buildHomePage(Map<String, dynamic> userData) {
      String? userRole = userData['role'] ?? 'user';
      switch (userRole) {
        case 'admin':
          return AdminPage();
        case 'staff':
          return StaffPage();
        case 'user':
          return ShopPage();
        default:
          return LoginScreen();
      }
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Margin-Point',
        theme: lightMode,
        // home:
        //     _auth.currentUser != null ? const ShopPage() : const LoginScreen(),
        home: userData != null ? buildHomePage(userData!) : LoginScreen(),
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
