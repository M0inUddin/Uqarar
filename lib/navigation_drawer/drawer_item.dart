import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem(
      {Key? key,
      required this.name,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  final String name;
  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        height: 20,
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Color.fromARGB(255, 9, 36, 117),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 9, 36, 117),
              ),
            )
          ],
        ),
      ),
    );
  }
}
