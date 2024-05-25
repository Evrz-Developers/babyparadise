import 'package:flutter/material.dart';

class ColoredListTile extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  const ColoredListTile({super.key, this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 16.0),
            Text(
              title,
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios),
            SizedBox(width: 16.0),
          ],
        ),
      ),
    );
  }
}
