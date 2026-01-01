import 'package:modibbogirei/utils/formatters/formatter.dart';

class CategoriesModel{
  String categoryId;
  String categoryName;
  DateTime? createdAt;
  DateTime? updatedAt;
  // Not Mapped
  CategoriesModel(
      {required this.categoryId,
     required this.categoryName});

  String get formattedDate => TFormatter.formatDate(createdAt);

  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);

}