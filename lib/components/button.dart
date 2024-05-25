import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final void Function()? onTap;
  final Widget child;
  const Button({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.all(15),
            // margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(50)),
            child: child));
  }
}
