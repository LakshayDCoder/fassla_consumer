import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fassla_consumer/components/product_tile.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String searchKey;
  late Stream<QuerySnapshot> streamQuery;

  Stream<QuerySnapshot> searchUsingKeyword(String myText) {
    try {
      return FirebaseFirestore.instance
          .collection(kProductCollection)
          .where('meta', isGreaterThanOrEqualTo: myText)
          .where('meta', isLessThan: myText + 'z')
          .limit(50)
          .snapshots();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    searchKey = "";
    streamQuery = searchUsingKeyword(searchKey);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        mySearchField(),
        Expanded(
          child: StreamBuilder(
            stream: streamQuery,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator.adaptive();
              }
              if (snapshot.hasData) {
                if (snapshot.data!.size > 0) {
                  return buildList(snapshot.data!.docs);
                }
              }

              return Center(child: Text("No Products Found"));
            },
          ),
        ),
      ],
    );
  }

  Widget mySearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          decoration: InputDecoration(
            hintText: "Search for a crop",
            labelText: "Search",
          ),
          onChanged: (value) {
            setState(() {
              searchKey = value.toLowerCase();
              streamQuery = searchUsingKeyword(searchKey);
            });
          }),
    );
  }

  Widget buildList(List productList) {
    print('Size of list: ${productList.length}');
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: productList.length,
      itemBuilder: (context, pos) {
        return ProductTile(
          d: productList[pos],
          type: ProductTileType.DetailPage,
        );
      },
    );
  }
}
