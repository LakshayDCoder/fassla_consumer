import 'package:fassla_consumer/states/enums.dart';

class ProductModal {
  String docId;
  ProductType type;
  String subCategory;
  String title;
  int categoryId;
  String image;
  String meta;
  String price;
  String unit;
  List<dynamic> unitSet;

  ProductModal({
    required this.docId,
    required this.type,
    required this.subCategory,
    required this.title,
    required this.categoryId,
    required this.image,
    required this.meta,
    required this.price,
    required this.unit,
    required this.unitSet,
  });
}
