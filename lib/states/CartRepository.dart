import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartRepository extends ChangeNotifier {
  final List<QueryDocumentSnapshot> _items = [];

  List<QueryDocumentSnapshot> get items => _items;

  void add(QueryDocumentSnapshot doc) {
    _items.add(doc);
    notifyListeners();
  }

  void removeAll() {
    _items.clear();
    notifyListeners();
  }
}
