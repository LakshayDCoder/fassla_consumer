import 'package:fassla_consumer/screens/cart/cart_screen.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MyAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.favorite)),
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, CartScreen.routeName);
            },
            icon: Icon(Icons.shopping_cart)),
        // IconButton(onPressed: () {}, icon: Icon(Icons.person)),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
