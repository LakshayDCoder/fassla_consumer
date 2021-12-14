import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fassla_consumer/states/CartRepository.dart';
import 'package:fassla_consumer/states/OrderRepository.dart';
import 'package:fassla_consumer/states/SharedPrefsRepo.dart';
import 'package:fassla_consumer/states/UserRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import 'item_tile.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = "/cart-screen";

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _razorpay = Razorpay();
  var _isLoggedIn = true;

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print("Razorpay payment success, Signature: ${response.signature}");

    paymentSuccessful();

    showMySnackbar(
      ctx: context,
      text: "Placed Order Successfully",
      type: SnackbarTypes.Success,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("Razorpay payment Failed, Message: ${response.message}");
    showMySnackbar(
        ctx: context, text: response.message!, type: SnackbarTypes.Fail);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    print("Selected external wallet");
  }

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    if (FirebaseAuth.instance.currentUser == null) {
      _isLoggedIn = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart Screen"),
      ),
      body: SafeArea(
        child: _isLoggedIn ? myConsumerWidget() : notLoggedIn(),
      ),
    );
  }

  Widget notLoggedIn() {
    return Center(
      child: Text("Please log in first"),
    );
  }

  Widget myConsumerWidget() {
    return Consumer<CartRepository>(builder: (context, cart, child) {
      return cartList(cart);
    });
  }

  Widget cartList(CartRepository cart) {
    var myItems = cart.items;
    if (myItems.length <= 0) {
      return Center(child: Text("Add some health to your basket"));
    } else {
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
          if (myItems.length > 0) checkoutButton(cart.cartTotal.toString()),
        ],
      );
    }
  }

  Widget checkoutButton(String totalPrice) {
    return ElevatedButton(
      onPressed: () async {
        if (await checkIfAddressAdded(context)) {
          doPayment();
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
            "₹ $totalPrice",
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
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
    );
  }

  doPayment() async {
    var cart = Provider.of<CartRepository>(context, listen: false);

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var mobile = _prefs.getString(sMobile);
    var email = _prefs.getString(sEmail);

    var options = {
      'key': 'rzp_test_FnLxSJGeN471v2',
      'amount': cart.cartTotal * 100, // For eg price = 20 , write it like 2000
      'currency': 'INR',
      'name': 'Fassla',
      'description': 'Payment for your items',
      'prefill': {'contact': mobile, 'email': email},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error: $e (from RazorpayRepo)');
    }
  }

  paymentSuccessful() {
    var cart = Provider.of<CartRepository>(context, listen: false);

    addOrderToDB(context);
    cart.removeAllItems();
  }

  Future<bool> addOrderToDB(BuildContext context) async {
    // print("Running add data to db");
    var cart = Provider.of<CartRepository>(context, listen: false);
    var user = Provider.of<UserRepository>(context, listen: false);

    FirebaseFirestore db = FirebaseFirestore.instance;

    List productList = [];

    for (var i in cart.items) {
      var myMap = {
        "product_id": i.productDoc.id,
        "sel_weight": i.weight,
        "quantity": i.quantity,
        "product_price": i.finalPrice,
      };
      productList.add(myMap);
    }

    Map<String, dynamic> myData = {
      "products": productList,
      "status": 0,
      "total_price": cart.cartTotal,
      "user_id": user.currentUID,
      "timestamp": FieldValue.serverTimestamp(),
    };

    bool retVal = false;

    await db
        .collection(kOrderCollection)
        .doc()
        .set(myData)
        .then((value) => retVal = true)
        .catchError((err) {
      print(
          "Error while adding data to user order to db(from OrderRepo): $err");
      retVal = false;
    });

    return retVal;
  }
}

/*Widget myStreamWidget() {
    var cart = Provider.of<CartRepository>(context, listen: false);
    var product = Provider.of<ProductsRepository>(context, listen: false);

    return StreamBuilder(
      stream: cart.getItems(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        var myItems = snapshot.data!.docs;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator.adaptive());
        } else {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: myItems.length,
                  itemBuilder: (context, pos) {
                    // Fetching product document
                    return FutureBuilder(
                      future: product.getProductDetails(myItems[pos].id),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        var cartItem = CartModel(
                          productDoc: snapshot.data!,
                          quantity: myItems[pos].get("quantity"),
                          weight: myItems[pos].get("selected_weight"),
                          finalPrice: myItems[pos].get("product_price"),
                        );

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator.adaptive());
                        } else {
                          return ItemTile(item: cartItem);
                        }
                      },
                    );
                  },
                ),
              ),
              if (myItems.length > 0) checkoutButton(cart.cartTotal.toString()),
            ],
          );
        }
      },
    );
  }*/
