import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fassla_consumer/states/CartRepository.dart';
import 'package:fassla_consumer/states/UserRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

Future<bool> placeCartOrder(BuildContext context) async {
  var cart = Provider.of<CartRepository>(context, listen: false);

  // Go to checkout screen
  //verify payment
  // if payment successful

  bool dataAdded = await addOrderToDB(context);
  // print("Data Added ?? -> $dataAdded");
  cart.removeAllItems();

  if (dataAdded) {
    return true;
  } else {
    return false;
  }
}

Future<bool> checkIfAddressAdded(BuildContext context) async {
  var user = Provider.of<UserRepository>(context, listen: false);

  var data = await user.getCurrentUserData();
  var address = data.get("address");

  if (address != null) {
    if (address.toString().isNotEmpty) {
      return true;
    }
  }

  return false;
}

Future<bool> addOrderToDB(BuildContext context) async {
  // print("Running add data to db");
  var cart = Provider.of<CartRepository>(context, listen: false);
  var user = Provider.of<UserRepository>(context, listen: false);

  FirebaseFirestore db = FirebaseFirestore.instance;

  List productList = [];

  for (var i in cart.items) {
    var myMap = {
      "product_id": i.doc.id,
      "sel_weight": i.weight,
      "quantity": i.quantity,
      "product_price": i.finalPrice,
    };
    productList.add(myMap);
  }

  Map<String, dynamic> myData = {
    "products": productList,
    "Status": "Pending",
    "total_price": cart.cartTotal,
    "user_id": user.currentUID,
  };

  bool retVal = false;

  await db
      .collection(kOrderCollection)
      .doc()
      .set(myData)
      .then((value) => retVal = true)
      .catchError((err) {
    print("Error while adding data to user order to db(from OrderRepo): $err");
    retVal = false;
  });

  return retVal;
}
