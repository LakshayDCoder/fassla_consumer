import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  QueryDocumentSnapshot doc;
  int quantity;
  String weight;
  int finalPrice;

  CartModel(
      {required this.doc,
      required this.quantity,
      required this.weight,
      required this.finalPrice});
}
