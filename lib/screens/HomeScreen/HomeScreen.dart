import 'package:fassla_consumer/screens/HomeScreen/my_scroll_row.dart';
import 'package:fassla_consumer/screens/all_products_screen/all_products_screen.dart';
import 'package:fassla_consumer/states/enums.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // late ProductsRepository _productsRepository;

  @override
  void initState() {
    super.initState();
    // _productsRepository = ProductsRepository();
  }

  @override
  Widget build(BuildContext context) {
    var categoryGrid = GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: ProductTypeMap.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                "https://picsum.photos/200/300/?blur?random=$index"),
            radius: 10,
            child: Text(
              ProductTypeMap.values.elementAt(index),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, AllProductsScreen.routeName,
                arguments: ProductTypeMap.keys.elementAt(index));
          },
        );
      },
    );

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            MyScrollRow(type: ProductType.Vegetables),
            MyScrollRow(type: ProductType.Fruits),
            MyScrollRow(type: ProductType.Spices),
            MyScrollRow(type: ProductType.Carbs),
            MyScrollRow(type: ProductType.Bakery),
            Divider(color: Colors.black),
            Text("Categories"),
            Divider(color: Colors.black),
            categoryGrid,
          ],
        ),
      ),
    );
  }
}
