import 'package:fassla_consumer/states/CartRepository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = "/cart-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart Screen"),
      ),
      body: Container(
        child: Consumer<CartRepository>(
          builder: (context, cart, child) {
            return Text("Cart length: ${cart.items.length}");
          },
        ),
      ),
    );
  }
}
