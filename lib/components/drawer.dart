import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marginpoint/components/drawer_list_tile.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Drawer Header
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0, bottom: 20.0),
                child: Image.asset('assets/logo.png', width: 80, height: 80),
              ),
              const SizedBox(height: 10),

              // Shop tile
              DrawerListTile(
                  onTap: () {
                    // pop drawer
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/shop');
                  },
                  text: 'Shop',
                  icon: Icons.home),

              // Orders tile
              DrawerListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/cart');
                  },
                  text: 'Cart',
                  icon: Icons.shopping_cart),
            ],
          ),

          // exit tile
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: DrawerListTile(
                    onTap: () async {
                      // bool shouldExit = await showLogoutConfirmation(context);
                      // if (shouldExit) {
                      _auth.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                      // }
                    },
                    text: 'Logout',
                    icon: Icons.logout),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: DrawerListTile(
                    onTap: () async {
                      bool shouldExit = await showExitConfirmation(context);
                      if (shouldExit) {
                        SystemNavigator.pop();
                      }
                    },
                    text: 'Exit App',
                    icon: Icons.exit_to_app),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<bool> showLogoutConfirmation(BuildContext context) async {
  return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to log out of your Account?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.inversePrimary)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.inversePrimary)),
            ),
          ],
        ),
      ) ??
      false;
}

Future<bool> showExitConfirmation(BuildContext context) async {
  return await showDialog(
        context: context,
        builder: (context) => Padding(
          padding: const EdgeInsets.only(right: 70),
          child: AlertDialog(
            title: const Text('Leaving?'),
            content: const Text('Do you want to exit the App?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No',
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.inversePrimary)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes',
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.inversePrimary)),
              ),
            ],
          ),
        ),
      ) ??
      false;
}
