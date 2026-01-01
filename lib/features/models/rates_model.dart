import 'package:modibbogirei/utils/formatters/formatter.dart';

class RatesModel{
  String productId;
  double purchasePrice;
  double sellingPrice;
  DateTime effectiveDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  // Not Mapped
  RatesModel(
      {required this.productId,
     required this.purchasePrice,
     required this.sellingPrice,
     required this.effectiveDate});

  String get formattedDate => TFormatter.formatDate(createdAt);

  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);

}