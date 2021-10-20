import 'package:fassla_consumer/states/CartRepository.dart';
import 'package:fassla_consumer/states/OrderRepository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'item_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = "/cart-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart Screen"),
      ),
      body: SafeArea(
        child: Container(
          child: Consumer<CartRepository>(builder: (context, cart, child) {
            var myItems = cart.items;

            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: myItems.length,
                    itemBuilder: (context, pos) {
                      return ItemTile(item: myItems[pos]);
                    },
                  ),
                ),
                if (myItems.length > 0)
                  ElevatedButton(
                    onPressed: () async {
                      if (await checkIfAddressAdded(context)) {
                        checkOutButtonClick(context);
                      } else {
                        showMySnackbar(
                          ctx: context,
                          text: "Please add your address to place the order.",
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Checkout",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Text(
                          "₹ ${cart.cartTotal}",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: kPrimaryColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  checkOutButtonClick(BuildContext context) {
    placeCartOrder(context).then((value) {
      if (value) {
        showMySnackbar(
            ctx: context,
            text: "Placed Order Successfully",
            type: SnackbarTypes.Success);
      } else {
        showMySnackbar(
            ctx: context,
            text: "Some error occurred while placing your order.",
            type: SnackbarTypes.Fail);
      }
    });
  }
}
