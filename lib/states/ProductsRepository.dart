import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fassla_consumer/constants.dart';
import 'package:fassla_consumer/states/ProductModal.dart';
import 'package:fassla_consumer/states/enums.dart';

class ProductsRepository {
  CollectionReference _prodCollectionRef =
      FirebaseFirestore.instance.collection(kProductCollection);

  Future<QuerySnapshot> get20ProductsByCategory(
      {required ProductType type}) async {
    // print("My type is: ${type.toString()} => ${ProductTypeMap[type]}");

    return _prodCollectionRef
        .where("Categories", isEqualTo: ProductTypeMap[type])
        .limit(20)
        .get();
  }

  Future<List<QueryDocumentSnapshot>> fetchFirstListByCategory(
      {required ProductType type}) async {
    // print("Getting First List Data");
    try {
      QuerySnapshot querySnapshot = await _prodCollectionRef
          .where("Categories", isEqualTo: ProductTypeMap[type])
          .limit(20)
          .get();

      return querySnapshot.docs;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<QueryDocumentSnapshot>> fetchNextListByCategory(
      {required ProductType type, required DocumentSnapshot myLastDoc}) async {
    try {
      QuerySnapshot querySnapshot = await _prodCollectionRef
          .where("Categories", isEqualTo: ProductTypeMap[type])
          .startAfterDocument(myLastDoc)
          .limit(20)
          .get();

      return querySnapshot.docs;
    } catch (e) {
      throw Exception(e);
    }
  }

  List<ProductModal> parseQuerySnapshotList(
      List<QueryDocumentSnapshot> myList, ProductType type) {
    List<ProductModal> myProductsList = [];

    myList.forEach((element) {
      var myJson = element.data() as Map<String, dynamic>;

      ProductModal myProd = ProductModal(
        docId: element.id,
        type: type,
        subCategory: myJson["subCat"],
        title: myJson["Product"],
        categoryId: myJson["cat_id"],
        image: myJson["image"],
        meta: myJson["meta"],
        price: myJson["price"],
        unit: myJson["unit"],
        unitSet: myJson["unitset"] == null ? [] : myJson["unitset"],
      );
      myProductsList.add(myProd);
    });

    return myProductsList;
  }
}
