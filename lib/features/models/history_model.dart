import 'package:modibbogirei/utils/formatters/formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum PaymentMethod { card, cash, transfer, credit }

class HistoryModel {
  String productName;
  double sellingPrice;
  int quantity;
  DateTime transactionDate;
  String paymentMethod;
  String cartId;
  double? amountPaid;
  // Not Mapped
  HistoryModel(
      {required this.productName,
      required this.sellingPrice,
      required this.quantity,
      required this.transactionDate,
      required this.paymentMethod,
      required this.cartId,
      this.amountPaid});

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
        cartId: map['cartId'] as String,
        productName: map['productName'] as String,
        sellingPrice: map['sellingPrice'] as double,
        quantity: map['quantity'] as int,
        transactionDate:
            DateTime.fromMillisecondsSinceEpoch(map['transactionDate'] as int),
        paymentMethod: map['paymentMethod'] as String,
        amountPaid: map['amountPaid'] as double);
  }

  String get dateNow {
    return TFormatter.formatDate(transactionDate);
  }

  String get formattedAmountPaid {
    return NumberFormat.decimalPattern().format(amountPaid);
  }

  IconData get paymentIcon {
    switch (paymentMethod) {
      case 'Card':
        return Icons.credit_card;
      case 'Cash':
        return Icons.money;
      case 'Transfer':
        return Icons.swap_horiz;
      case 'Credit':
        return Icons.account_balance_wallet;
      default:
        return Icons.payment;
    }
  }

  double get totalAmount {
    return sellingPrice * quantity;
  }
}

class HistoryBucket {
  final List<HistoryModel> historyModel;
  HistoryBucket({required this.historyModel});

  double get totalCart {
    double gSum = 0.0;
    for (var item in historyModel) {
      gSum += item.totalAmount;
    }
    return gSum;
  }
}
