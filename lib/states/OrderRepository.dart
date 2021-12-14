import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fassla_consumer/states/CartModel.dart';
import 'package:fassla_consumer/states/ProductsRepository.dart';
import 'package:fassla_consumer/states/UserRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

Future<bool> checkIfAddressAdded(BuildContext context) async {
  var user = Provider.of<UserRepository>(context, listen: false);

  DocumentSnapshot data = await user.getCurrentUserData();

  // print("Address Check: " + data.data().toString());

  Map<String, dynamic> dataMap = data.data() as Map<String, dynamic>;

  if (dataMap.containsKey("address1")) {
    var address = dataMap["address1"];

    if (address.toString().isNotEmpty) {
      return true;
    }
  }

  return false;
}

Future<List<MyOrderModel>> getMyOrders() async {
  List<MyOrderModel> myOrdersList = [];
  try {
    var query = await FirebaseFirestore.instance
        .collection(kOrderCollection)
        .where("user_id", isEqualTo: UserRepository.instance().currentUID)
        .orderBy('timestamp', descending: true)
        .get();

    // print("Number of Orders: ${query.size}");

    // Parsing multiple orders with multiple products
    for (var singleOrder in query.docs) {
      var status = singleOrder.get("status");
      var total_price = singleOrder.get("total_price");
      var timestamp = singleOrder.get("timestamp");
      var orderId = singleOrder.id;
      var products = singleOrder.get("products") as List<dynamic>;
      List<CartModel> myProductsList = [];
      for (var prod in products) {
        DocumentSnapshot prodDoc =
            await ProductsRepository().getProductDetails(prod["product_id"]);
        CartModel item = CartModel(
            productDoc: prodDoc,
            quantity: prod["quantity"],
            weight: prod["sel_weight"],
            finalPrice: prod["product_price"]);
        myProductsList.add(item);
      }
      var orderItem = MyOrderModel(
        cart_price: total_price,
        timestamp: timestamp,
        cartModelList: myProductsList,
        status: status,
        orderId: orderId,
      );
      myOrdersList.add(orderItem);
    }
  } catch (e) {
    print("Error while getting my orders from db: $e");
  }

  return myOrdersList;
}

class MyOrderModel {
  List<CartModel> cartModelList;
  Timestamp timestamp;
  int cart_price;
  int status;
  String orderId;

  MyOrderModel({
    required this.cart_price,
    required this.timestamp,
    required this.cartModelList,
    required this.status,
    required this.orderId,
  });

  // Map<String, dynamic> toJson() {
  //   return {
  //     "products": productList,
  //     "status": 0,
  //     "total_price": cart_price,
  //     "user_id": user.currentUID,
  //     "timestamp": FieldValue.serverTimestamp(),
  //   };
  // }
}
