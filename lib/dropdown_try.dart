import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class DropDownTry extends StatefulWidget {
  const DropDownTry({Key? key}) : super(key: key);

  @override
  _DropDownTryState createState() => _DropDownTryState();
}

class _DropDownTryState extends State<DropDownTry> {
  String _selectedWeight = "";

  // List<String> _weightList = ["500gm", "1kg", "2kg", "5kg"];
  List<String> _weightList = [
    "100gm",
    "100gm",
    "250gm",
    "500gm",
    "1kg",
    "2kg",
    "5kg",
    "5kg",
    "100gm"
  ].toSet().toList();

  CollectionReference _collRef =
      FirebaseFirestore.instance.collection(kProductCollection);

  @override
  void initState() {
    super.initState();
    _selectedWeight = _weightList[0];
  }

  updateRepeatedUnitSetListInFirebase() async {
    try {
      QuerySnapshot querySnapshot = await _collRef.get();

      querySnapshot.docs.forEach((element) {
        Map myDataMap = element.data() as Map<String, dynamic>;
        var unitSet = myDataMap["unitset"];

        if (unitSet != null) {
          var unitList = unitSet as List<dynamic>;
          unitList = unitList.toSet().toList();
          print(unitList);

          _collRef.doc(element.id).update({
            "unitset": unitList,
          });
        }

        // print(unitSet);
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dropdown Try"),
      ),
      body: Container(
        child: DropdownButton<String>(
          value: _selectedWeight,
          items: _weightList.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? val) {
            setState(() {
              _selectedWeight = val!;
            });
          },
        ),
      ),
    );
  }
}
