import 'package:fassla_consumer/screens/components/my_scroll_row.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  List<String> categoryList = [
    "Vegetables",
    "Fruits",
    "Spices",
    "Grains",
    "Bakery",
    "Tools",
  ];

  @override
  Widget build(BuildContext context) {
    var categoryGrid = GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: categoryList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return CircleAvatar(
          backgroundImage:
              NetworkImage("https://picsum.photos/200/300/?blur?random=$index"),
          radius: 10,
          child: Text(
            categoryList[index],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            MyScrollRow(heading: "Fruits"),
            MyScrollRow(heading: "vegetables"),
            MyScrollRow(heading: "Spices"),
            MyScrollRow(heading: "Carbs"),
            MyScrollRow(heading: "Bakery Items"),
            Divider(color: Colors.black),
            Text("Offer Panel"),
            Divider(color: Colors.black),
            categoryGrid,
          ],
        ),
      ),
    );
  }
}
