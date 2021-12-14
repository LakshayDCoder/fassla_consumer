import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fassla_consumer/states/ProductsRepository.dart';
import 'package:fassla_consumer/states/UserRepository.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'CartModel.dart';

class CartRepository extends ChangeNotifier {
  List<CartModel> _items = [];

  List<CartModel> get items => _items;
  int get cartTotal => calculateCartTotal();

  var _cartCollection = FirebaseFirestore.instance
      .collection(kUserCollection)
      .doc(UserRepository.instance().currentUID)
      .collection(kUserCartCollection);

  CartRepository() {
    print("Cart Repo Init");
    getItems();
  }

  Future getItems() async {
    var query = await _cartCollection.get();

    for (var doc in query.docs) {
      DocumentSnapshot productDoc =
          await ProductsRepository().getProductDetails(doc.id);
      var cartItem = CartModel(
          productDoc: productDoc,
          quantity: doc.get("quantity"),
          weight: doc.get("selected_weight"),
          finalPrice: doc.get("product_price"));
      _items.add(cartItem);
    }
    print("Got cart successfully");
    notifyListeners();
  }

  void addItem(CartModel myItem) async {
    var _isPresent = _items
        .where((element) => element.productDoc.id == myItem.productDoc.id);

    if (_isPresent.isEmpty) {
      // Same product does not exist
      myItem.finalPrice = calculateItemFinalCost(myItem);
      _items.add(myItem);
      await _cartCollection.doc(myItem.productDoc.id).set(myItem.toJson());
    } else {
      // Same product does exist
      updateCartItem(myItem);
    }

    print(
        "Added Item: ${myItem.productDoc["Product"]}, List Length: ${_items.length}");

    notifyListeners();
  }

  updateCartItem(CartModel currentItem) async {
    var index = _items.indexWhere(
        (element) => element.productDoc.id == currentItem.productDoc.id);

    // If quantity == 0 then delete item
    if (currentItem.quantity == 0) {
      _items.removeAt(index);

      _items.removeWhere(
          (item) => item.productDoc.id == currentItem.productDoc.id);

      await _cartCollection.doc(currentItem.productDoc.id).delete();
    } else {
      currentItem.finalPrice = calculateItemFinalCost(currentItem);
      _items[index] = currentItem;
      await _cartCollection
          .doc(currentItem.productDoc.id)
          .set(currentItem.toJson());
    }

    notifyListeners();
  }

  void removeAllItems() async {
    _items.clear();

    var snapshots = await _cartCollection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }

    notifyListeners();
  }

  int calculateCartTotal() {
    int total = 0;

    for (var item in _items) {
      total += item.finalPrice;
    }

    return total;
  }

  int calculateItemFinalCost(CartModel myItem) {
    var item = myItem.productDoc;

    var priceUnit = item["unit"].toString().trim();
    double price = double.parse(item["price"]);

    double pricePerGram;
    double selectedWeightInGrams;
    double quantity = myItem.quantity.toDouble();

    if (priceUnit == "Kg") {
      pricePerGram = price / 1000;
    } else if (priceUnit == "gm") {
      pricePerGram = price;
    } else {
      pricePerGram = price;
    }

    if (myItem.weight.contains("No Weights Found")) {
      selectedWeightInGrams = 1;
    } else {
      selectedWeightInGrams = calculateSelectedWeightInGrams(myItem.weight);
    }

    return (pricePerGram * selectedWeightInGrams * quantity).floor();
  }

  double calculateSelectedWeightInGrams(String selWeight) {
    // This is the function to calc how many grams are selected in the dropdown.
    // If the kg is selected multiply num by 1000 to convert it into grams
    // If it's the piece the it won't trigger this func as no weights are found

    var selectedWeight = selWeight.trim();
    var selWeightUnit =
        selectedWeight.substring(selectedWeight.length - 2).toLowerCase();
    var selWeightNum =
        double.parse(selectedWeight.substring(0, selectedWeight.length - 2));

    // print("selWeightUnit: $selWeightUnit");
    // print("selWeightNum: $selWeightNum");

    if (selWeightUnit == "kg") {
      return selWeightNum * 1000;
    }

    return selWeightNum;
  }
}
