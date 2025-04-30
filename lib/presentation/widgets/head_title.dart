import 'package:flutter/material.dart';
class HeadTitle extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  const HeadTitle({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.black,
        title: const Row(
          children: [
            Text(
              'Evo',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'FLIX',
              style: TextStyle(
                color: Color.fromARGB(255, 253, 0, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
    );
  }
}