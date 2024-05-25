import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final IconData icon;
  const DrawerListTile(
      {super.key, required this.onTap, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:20.0),
      child: ListTile(
          title: Text(text),
          onTap: onTap,
          leading: Icon(
            icon,
            color: Colors.grey,
          )),
    );
  }
}
