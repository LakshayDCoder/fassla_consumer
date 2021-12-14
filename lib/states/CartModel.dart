import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  DocumentSnapshot productDoc;
  int quantity;
  String weight;
  int finalPrice;

  CartModel(
      {required this.productDoc,
      required this.quantity,
      required this.weight,
      required this.finalPrice});

  Map<String, dynamic> toJson() {
    return {
      "quantity": this.quantity,
      "selected_weight": this.weight,
      "product_price": this.finalPrice
    };
  }
}
