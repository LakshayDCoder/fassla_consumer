import 'package:flutter/material.dart';

import 'CartModel.dart';

class CartRepository extends ChangeNotifier {
  List<CartModel> _items = [];

  List<CartModel> get items => _items;
  int get cartTotal => calculateCartTotal();

  void addItem(CartModel myItem) {
    myItem.finalPrice = calculateItemFinalCost(myItem);
    _items.add(myItem);
    print(
        "Added Item: ${myItem.doc["Product"]}, List Length: ${_items.length}");

    notifyListeners();
  }

  updateCartItem(CartModel currentItem) {
    currentItem.finalPrice = calculateItemFinalCost(currentItem);
    var index =
        _items.indexWhere((element) => element.doc.id == currentItem.doc.id);
    _items[index] = currentItem;
    notifyListeners();
  }

  void removeAllItems() {
    _items.clear();
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
    var item = myItem.doc;

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
