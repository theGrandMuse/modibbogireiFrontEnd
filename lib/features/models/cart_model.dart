import 'package:modibbogirei/features/models/products_model.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();


class CartModel {
  String? cartId;
  int quantity;
  ProductsModel product;
  String productId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String transactionId;
  String servedBy;
  String? servedByName;
  CartModel(
      {this.cartId,
      required this.product,
      required this.quantity,
      required this.productId,
      required this.servedBy,
      this.servedByName})
      : transactionId = uuid.v4();

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
        cartId: map['cartId'] as String,
        productId: map['productId'] as String,
        quantity: map['quantity'] as int,
        servedBy: map["servedBy"] as String,
        servedByName: map["servedByName"] ?? '',
        product: ProductsModel.fromMap(map['product']));
  }

  double get totalPrice => product.sellingPrice * quantity;
  String get formattedTotalPrice {
    return NumberFormat.decimalPattern().format(totalPrice);
  }

  String get formattedSellingPrice {
    return NumberFormat.decimalPattern().format(product.sellingPrice);
  }
}

class CartBucket {
  final List<CartModel> cartItem;
  CartBucket({required this.cartItem});

  int get cartItemCount {
    return cartItem.length;
  }

  double get totalCart {
    double gSum = 0.0;
    for (var item in cartItem) {
      gSum += item.totalPrice;
    }
    return gSum;
  }

  String get formattedTotalCart {
    return NumberFormat.decimalPattern().format(totalCart);
  }
}
