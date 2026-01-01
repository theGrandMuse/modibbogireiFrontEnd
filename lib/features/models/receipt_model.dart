import 'package:modibbogirei/features/models/cart_model.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class ReceiptModel {
  String receiptId;
  String productId;
  String productName;
  int quantity;
  double sellingPrice;
  DateTime transactionDate;
  String postedBy;
  String shopId;
  String servedBy;
  String? paymentMethod;
  List<CartModel>? cart;
  // Not Mapped
  ReceiptModel(
      {required this.productId,
      required this.productName,
      required this.quantity,
      required this.sellingPrice,
      required this.transactionDate,
      required this.postedBy,
      required this.shopId,
      required this.servedBy,
      this.paymentMethod})
      : receiptId = uuid.v4();

  factory ReceiptModel.fromMap(Map<String, dynamic> map) {
    return ReceiptModel(
        productId: map['productId'] as String,
        productName: map['productName'] as String,
        servedBy: map['servedBy'] as String,
        quantity: map['quantity'] as int,
        sellingPrice: map['sellingPrice'] as double,
        transactionDate:
            DateTime.fromMillisecondsSinceEpoch(map['transactionDate'] as int),
        postedBy: map['postedBy'] as String,
        shopId: map['shopId'] as String);
  }

  Map<String, dynamic> toMap() {
    return {
      'receiptId': receiptId,
      'productId': productId,
      'servedBy': servedBy,
      'productName': productName,
      'quantity': quantity,
      'sellingPrice': sellingPrice,
      'transactionDate': transactionDate.millisecondsSinceEpoch,
      'postedBy': postedBy,
      'shopId': shopId
    };
  }

  double get totalPrice => sellingPrice * quantity;
}

class ReceiptBucket {
  final List<ReceiptModel> receiptItem;
  ReceiptBucket({required this.receiptItem});

  double get totalReceipt {
    double gSum = 0.0;
    for (var item in receiptItem) {
      gSum += item.totalPrice;
    }
    return gSum;
  }
}
