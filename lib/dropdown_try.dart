import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class DropDownTry extends StatefulWidget {
  const DropDownTry({Key? key}) : super(key: key);

  @override
  _DropDownTryState createState() => _DropDownTryState();
}

class _DropDownTryState extends State<DropDownTry> {
  CollectionReference _collRef =
      FirebaseFirestore.instance.collection(kProductCollection);

  @override
  void initState() {
    super.initState();
  }

  updateRepeatedUnitSetListInFirebase() async {
    try {
      QuerySnapshot querySnapshot = await _collRef.get();

      querySnapshot.docs.forEach((element) {
        _collRef.doc(element.id).update({
          "is_available": true,
        });
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Try"),
      ),
      body: Container(
        child: Text("Hi"),
      ),
    );
  }
}
