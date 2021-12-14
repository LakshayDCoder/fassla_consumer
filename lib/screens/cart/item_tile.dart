import 'package:fassla_consumer/states/CartModel.dart';
import 'package:fassla_consumer/states/CartRepository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../size_config.dart';

class ItemTile extends StatefulWidget {
  final CartModel item;

  const ItemTile({Key? key, required this.item}) : super(key: key);

  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  int _quantity = 0;
  String _selectedWeight = "";
  List<String> _weightList = [];

  @override
  void initState() {
    super.initState();

    var myDataMap = widget.item.productDoc.data() as Map<String, dynamic>;
    var unitSet = myDataMap["unitset"];

    if (unitSet != null) {
      var weightList = unitSet as List<dynamic>;
      weightList.forEach((e) => _weightList.add(e.toString()));
    } else {
      _weightList.add("No Weights Found");
    }
    _selectedWeight = widget.item.weight;
    _quantity = widget.item.quantity;

    // print("$_weightList, Name: ${myDataMap["Product"]}, Uid: ${widget.d.id}");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return tile2();
  }

  Widget tile2() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        isThreeLine: true,
        leading: myProductImage(),
        title: myProductTitle(),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myProductPricePerUnit(),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                myDropdownSelector(),
                SizedBox(width: 10),
                myCounter(),
              ],
            )
          ],
        ),
        trailing: myProductTotalPrice(),
      ),
    );
  }

  Widget myProductTitle() => Text(widget.item.productDoc["Product"]);

  Widget myProductPricePerUnit() => Text(
        "₹ ${widget.item.productDoc["price"]} / ${widget.item.productDoc["unit"]}",
        textAlign: TextAlign.start,
      );

  Widget myProductImage() => Image.network(
        widget.item.productDoc["image"],
        width: getProportionateScreenWidth(80),
        height: getProportionateScreenHeight(90),
        fit: BoxFit.contain,
      );

  Widget myProductTotalPrice() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "₹\n${widget.item.finalPrice}",
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget myDropdownSelector() => Container(
        width: SizeConfig.screenWidth! * 0.2,
        child: DropdownButton<String>(
          value: _selectedWeight,
          items: _weightList.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: SizedBox(
                width: SizeConfig.screenWidth! * 0.12,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? val) {
            _selectedWeight = val!;
            updateCartList();
          },
        ),
      );

  void updateCount(int addValue) {
    if (_quantity + addValue >= 0) {
      _quantity += addValue;
      updateCartList();
    }
  }

  updateCartList() {
    final myItem = CartModel(
      productDoc: widget.item.productDoc,
      quantity: _quantity,
      weight: _selectedWeight,
      finalPrice: widget.item.finalPrice,
    );
    var cart = context.read<CartRepository>();
    cart.updateCartItem(myItem);
  }

  Widget myCounter() {
    var counterWidth = 75.0;
    return SizedBox(
      width: counterWidth,
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
                  width: counterWidth * 0.33,
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
              SizedBox(
                width: counterWidth * 0.3,
                child: Center(
                    child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    '$_quantity',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                        decoration: TextDecoration.none),
                  ),
                )),
              ),
              GestureDetector(
                onTap: () {
                  updateCount(1);
                },
                child: Container(
                  width: counterWidth * 0.33,
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
}
