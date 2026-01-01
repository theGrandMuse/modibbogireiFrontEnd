import 'package:modibbogirei/utils/formatters/formatter.dart';

class ProductsCartModel{
  String productId;
  String productName;
  double sellingPrice;
  DateTime? createdAt;
  DateTime? updatedAt;
  // Not Mapped
  ProductsCartModel(
      {required this.productId,
     required this.productName,
     required this.sellingPrice});

  String get formattedDate => TFormatter.formatDate(createdAt);

  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);

}