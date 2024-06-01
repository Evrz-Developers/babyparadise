import 'package:flutter/material.dart';
import 'package:marginpoint/components/button.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Logo as icon
          Image.asset('assets/logo.png', width: 150, height: 150),
          // spacing
          const SizedBox(height: 25),
          // Title
          Text('Margin Point',
              style: TextStyle(
                  fontSize: 30,
                  color: Theme.of(context).colorScheme.inversePrimary)),
          const SizedBox(height: 10),
          // subtitle
          Text('Quick Find, Best Value',
              style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.inversePrimary)),
          const SizedBox(height: 40),
          // Button
          Button(
              onTap: () {
                Navigator.pushNamed(context, '/shop');
              },
              child: Icon(Icons.arrow_forward_ios_rounded,
                  size: 50,
                  color: Theme.of(context).colorScheme.inversePrimary)),
          const SizedBox(height: 15),
          // subtitle
          // Text("Let's Get Started",
          //     style: TextStyle(
          //         fontSize: 15,
          //         color: Theme.of(context).colorScheme.inversePrimary)),
        ]),
      ),
    );
  }
}
