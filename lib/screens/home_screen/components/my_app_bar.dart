import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Home Screen"),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.favorite)),
        IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart)),
        IconButton(onPressed: () {}, icon: Icon(Icons.person)),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
