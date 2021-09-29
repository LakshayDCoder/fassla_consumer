import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fassla_consumer/constants.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';

class ProductTile extends StatefulWidget {
  final QueryDocumentSnapshot d;

  const ProductTile({Key? key, required this.d}) : super(key: key);

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  late Map<String, dynamic> myDataMap;
  int _quantity = 0;
  String _selectedWeight = "";
  List<String> _weightList = [];

  @override
  void initState() {
    super.initState();

    myDataMap = widget.d.data() as Map<String, dynamic>;
    var unitSet = myDataMap["unitset"];

    if (unitSet != null) {
      var weightList = unitSet as List<dynamic>;
      weightList.forEach((e) => _weightList.add(e.toString()));
    } else {
      _weightList.add("No Weights Found");
    }
    _selectedWeight = _weightList[0];

    // print("$_weightList, Name: ${myDataMap["Product"]}, Uid: ${widget.d.id}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      height: 160,
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.network(
                widget.d["image"],
                width: getProportionateScreenWidth(80),
                height: getProportionateScreenHeight(90),
                fit: BoxFit.contain,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 19, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.d["Product"],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          myDropdownSelector(),
                          myCounter(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              wishlistButton,
              cartButton,
            ],
          ),
        ],
      ),
    );
  }

  var wishlistButton = OutlinedButton.icon(
    onPressed: () {},
    icon: Icon(Icons.favorite),
    label: Text("Add to Wishlist"),
    style: TextButton.styleFrom(
      primary: kPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    ),
  );

  var cartButton = OutlinedButton.icon(
    onPressed: () {},
    icon: Icon(Icons.shopping_cart),
    label: Text("Add to Cart"),
    style: TextButton.styleFrom(
      primary: kPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    ),
  );

  Widget myDropdownSelector() => Container(
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
      );

  void updateCount(int addValue) {
    if (_quantity + addValue >= 0) {
      setState(() {
        _quantity += addValue;
      });
    }
  }

  Widget myCounter() => SizedBox(
        width: 90.0,
        height: 44.0,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xddFFFFFF),
                border: Border.all(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.circular(22.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    updateCount(-1);
                  },
                  child: Container(
                    width: 30.0,
                    child: Center(
                      child: Text(
                        '-',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Center(
                      child: Text(
                    '$_quantity',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                        decoration: TextDecoration.none),
                  )),
                ),
                GestureDetector(
                  onTap: () {
                    updateCount(1);
                  },
                  child: Container(
                    width: 30.0,
                    child: Center(
                      child: Text(
                        '+',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
