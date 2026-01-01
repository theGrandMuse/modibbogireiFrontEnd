import 'package:modibbogirei/utils/constants/image_strings.dart';
import 'package:modibbogirei/utils/formatters/formatter.dart';
import 'package:intl/intl.dart';

class ProductsModel {
  String productId;
  String productName;
  String categoryId;
  double purchasePrice;
  double sellingPrice;
  int statusId;
  String? categoryName;
  DateTime? createdAt;
  DateTime? updatedAt;
  // Not Mapped
  ProductsModel(
      {required this.productId,
      required this.productName,
      required this.categoryId,
      required this.statusId,
      required this.purchasePrice,
      required this.sellingPrice,
      this.categoryName});

  factory ProductsModel.fromMap(Map<String, dynamic> map) {
    return ProductsModel(
      productId: map['productId'] as String,
      productName: map['productName'] as String,
      categoryId: map['categoryId'] as String,
      categoryName: map['categoryName'] ?? '',
      statusId: map['statusId'] as int,
      purchasePrice: map['purchasePrice'] ?? 0,
      sellingPrice: map['sellingPrice'] ?? 0,
    );
  }

  String get categoryImage {
    Map<String, String> category = TImages.categoryImage
        .firstWhere((category) => category['categoryId'] == categoryId);
    return category['image']!;
  }

  String get formattedDate => TFormatter.formatDate(createdAt);

  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);

  String get formattedSellingPrice {
    return NumberFormat.decimalPattern().format(sellingPrice);
  }
}
