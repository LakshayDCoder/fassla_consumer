import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fassla_consumer/states/ProductsRepository.dart';
import 'package:fassla_consumer/states/enums.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class MyScrollRow extends StatelessWidget {
  final ProductType type;
  MyScrollRow({Key? key, required this.type}) : super(key: key);

  final ProductsRepository _productsRepository = ProductsRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: FutureBuilder(
        future: _productsRepository.get20ProductsByCategory(type: type),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator.adaptive();
          }
          if (snapshot.hasError) {
            return Text("Some error occurred while getting data");
          }

          if (!snapshot.hasData) {
            return Text("No data found");
          }

          var myList = snapshot.data!.docs;
          // print("Num of data in list: ${myList.length}");

          return myList.length <= 0 ? noItemFound() : createRow(myList);
        },
      ),
    );
  }

  Widget noItemFound() => Padding(
        padding: const EdgeInsets.all(8),
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
            children: [
              TextSpan(text: "No Items available right now in "),
              TextSpan(
                text: "\"${ProductTypeMap[type]}\"",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              )
            ],
          ),
        ),
      );

  Widget createRow(List myList) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(ProductTypeMap[type]!),
        SizedBox(
          height: 100,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: myList.length + 1,
            itemBuilder: (_, index) {
              if (index == 20) {
                return Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    icon: Icon(Icons.arrow_forward),
                  ),
                );
              }
              return myCard(myList[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget myCard(QueryDocumentSnapshot doc) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: customNetworkImage(doc["image"]),
            radius: 30,
          ),
          Text(doc["Product"]),
        ],
      ),
    );
  }
}
