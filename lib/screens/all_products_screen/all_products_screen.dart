import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fassla_consumer/components/my_app_bar.dart';
import 'package:fassla_consumer/screens/all_products_screen/product_tile.dart';
import 'package:fassla_consumer/size_config.dart';
import 'package:fassla_consumer/states/ProductsRepository.dart';
import 'package:fassla_consumer/states/enums.dart';
import 'package:flutter/material.dart';

class AllProductsScreen extends StatefulWidget {
  static const routeName = "/all-product-screen";

  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  _AllProductsScreenState createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  ProductsRepository _productsRepo = ProductsRepository();
  late ProductType _type;

  List<QueryDocumentSnapshot> productList = [];

  var scrollController = ScrollController();

  var _isLoading = true;
  var _isMoreDataPresent = true;

  var _noData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _type = ModalRoute.of(context)!.settings.arguments as ProductType;
    // _type = ProductType.Carbs;

    getInitData();
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0)
          print('ListView scroll at top');
        else {
          print('ListView scroll at bottom');
          if (_isLoading) {
            print("Still Loading");
          } else {
            if (_isMoreDataPresent) {
              getNextData();
              // print("Still more data present");
            } else {
              print("Reached End");
            }
          }
        }
      }
    });
  }

  setIsLoading(bool val) {
    setState(() {
      _isLoading = val;
    });
  }

  Future getInitData() async {
    productList.clear();
    setIsLoading(true);

    await _productsRepo.fetchFirstListByCategory(type: _type).then((myData) {
      // print("Got first list data successfully: $myData");
      productList.addAll(myData);

      if (myData.isEmpty) {
        _noData = true;
      }
    }).catchError((e) {
      print("My Error While getting first list: $e");
    });

    setIsLoading(false);
  }

  getNextData() async {
    setIsLoading(true);

    await _productsRepo
        .fetchNextListByCategory(type: _type, myLastDoc: productList.last)
        .then((myData) {
      // print("Got next list data successfully: $myData");

      if (myData.length == 0) {
        _isMoreDataPresent = false;
      } else {
        productList.addAll(myData);
      }
    }).catchError((e) {
      print("My Error While getting next list: $e");
    });

    setIsLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: MyAppBar(title: ProductTypeMap[_type]!),
      body: Center(
        child: productList.length != 0
            ? RefreshIndicator(
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  itemCount: productList.length + 1,
                  itemBuilder: (context, pos) {
                    // print("Index: $pos");
                    // print("List Length: ${productList.length}");

                    if (pos == productList.length) {
                      if (!_isMoreDataPresent) {
                        return Container(
                          margin: EdgeInsets.all(12),
                          child: Center(
                            child: Text("Reached the End"),
                          ),
                        );
                      } else {
                        return Container(
                          margin: EdgeInsets.all(12),
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        );
                      }
                    }

                    return ProductTile(d: productList[pos]);
                  },
                ),
                onRefresh: getInitData, // Refresh entire list
              )
            : _noData
                ? Container(
                    child: Text("No Data Found"),
                  )
                : CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
