import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fassla_consumer/states/CartModel.dart';
import 'package:fassla_consumer/states/CartRepository.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../constants.dart';
import '../size_config.dart';

enum ProductTileType {
  HomePage,
  DetailPage,
}

class ProductTile extends StatefulWidget {
  final QueryDocumentSnapshot d;
  final ProductTileType type;

  const ProductTile({Key? key, required this.d, required this.type})
      : super(key: key);

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
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return widget.type == ProductTileType.DetailPage
        ? detailPageCard()
        : homePageCard();
  }

  Widget homePageCard() => GestureDetector(
        onTap: () => showWeightAndQuantitySelector(),
        child: Container(
          margin: EdgeInsets.only(right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: customNetworkImage(widget.d["image"]),
                radius: 30,
              ),
              Text(widget.d["Product"]),
            ],
          ),
        ),
      );

  Widget detailPageCard() => ListTile(
        title: myProductTitle(),
        subtitle: myProductPrice(),
        leading: myProductImage(),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // IconButton(
            //   icon: Icon(Icons.favorite),
            //   onPressed: () {},
            // ),
            IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                showWeightAndQuantitySelector();
              },
            ),
          ],
        ),
        onTap: () => showWeightAndQuantitySelector(),
      );

  Widget myProductTitle() => Text(widget.d["Product"]);

  Widget myProductPrice() =>
      Text("₹ ${widget.d["price"]} / ${widget.d["unit"]}");

  Widget myProductImage() => Image.network(
        widget.d["image"],
        width: getProportionateScreenWidth(80),
        height: getProportionateScreenHeight(90),
        fit: BoxFit.contain,
      );

  showWeightAndQuantitySelector() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
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
                    setModalState(() {
                      _selectedWeight = val!;
                    });
                  },
                ),
              );

          void updateCount(int addValue) {
            if (_quantity + addValue >= 0) {
              setModalState(() {
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

          return Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    widget.d["image"],
                    fit: BoxFit.fitWidth,
                  ),
                  ListTile(
                    title: Text(
                      widget.d["Product"],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    subtitle: Text(
                      "Other names: ${widget.d["meta"]} \nRs ${widget.d["price"]}/${widget.d["unit"]}",
                    ),
                  ),
                  ListTile(
                    title: Text("Weight"),
                    trailing: myDropdownSelector(),
                  ),
                  ListTile(
                    title: Text("Quantity"),
                    trailing: myCounter(),
                  ),
                  SizedBox(height: 14),
                  cartButton(),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget cartButton() => ElevatedButton.icon(
        icon: Icon(Icons.shopping_cart),
        label: Text("Add to Cart"),
        style: ElevatedButton.styleFrom(
          primary: kPrimaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(20),
          )),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        ),
        onPressed: () {
          Navigator.pop(context);
          if (_quantity <= 0) {
            _quantity++;
          }

          var cart = context.read<CartRepository>();

          final myItem = CartModel(
              doc: widget.d,
              quantity: _quantity,
              weight: _selectedWeight,
              finalPrice: 0);

          cart.addItem(myItem);
          showMySnackbar(ctx: context, text: "Added to Cart");
        },
      );
}
