import 'dart:convert';

import 'package:modibbogirei/features/providers/actions_provider.dart';
import 'package:modibbogirei/features/services/http_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:http_status/http_status.dart';

import 'package:modibbogirei/features/services/database_service.dart';

import 'package:modibbogirei/utils/popups/loaders.dart';

final dbService = DatabaseService();

class SyncCategoriesNotifier extends StateNotifier<bool> {
  SyncCategoriesNotifier() : super(false);

  Future<dynamic> syncCategoriesToLocalDb() async {
    const String endpoint = 'product_category.php';

    final response = await HttpService.get(endpoint);
    dynamic categoryList = jsonDecode(response.body);
    categoryList.forEach((row) {
      dbService.insert('product_category', {
        'categoryId': row['categoryId'],
        'categoryName': row['categoryName']
      });
    });
    state = true;
  }
}

class SyncProductsToOnlineNotifier extends StateNotifier<bool> {
  SyncProductsToOnlineNotifier(this.ref) : super(false);

  Ref ref;

  Future<void> syncProductsToOnlineDb() async {
    final salesList = await dbService
        .rawQuery('SELECT * FROM mobile_sales_details WHERE statusId = ?', [1]);
    if (salesList.isNotEmpty) {
      bool isConnected = await InternetConnection().hasInternetAccess;
      if (isConnected) {
        state = true;
        for (var data in salesList) {
          var serialNo = data['serialNo'] as int;
          var receiptId = data['receiptId'];
          var quantity = data['quantity'];
          var sellingPrice = data['sellingPrice'];
          var productId = data['productId'];
          var transactionDate = DateTime.fromMillisecondsSinceEpoch(
              data['transactionDate'] as int);
          var paymentMethod = data['paymentMethod'];
          var postedBy = data['postedBy'];
          var cartId = data['cartId'];
          var transactionId = data['transactionId'];
          var shopId = data['shopId'] ?? '';
          var servedBy = data['servedBy'] ?? '';

          var toUpload = {
            "productId": productId as String,
            "quantity": quantity.toString(),
            "sellingPrice": sellingPrice.toString(),
            "transactionDate": transactionDate.toString(),
            "receiptId": receiptId as String,
            "paymentMethod": paymentMethod as String,
            "postedBy": postedBy as String,
            "cartId": cartId as String,
            "transactionId": transactionId as String,
            "shopId": shopId as String,
            "servedBy": servedBy as String,
          };

          String endpoint = 'receipt_add.php';
          final response = await HttpService.post(endpoint, toUpload);

          final httpStatusResponse = HttpStatus.fromCode(response.statusCode);

          if (httpStatusResponse.isSuccessfulHttpStatusCode) {
            final String sql =
                "UPDATE mobile_sales_details SET statusId = ? WHERE serialNo = ?";
            dbService.rawQuery(sql, [2, serialNo]);
          }
        }
        ref.read(unsyncedRecordsProvider.notifier).unsynced();
        state = false;
      } else {
        TLoaders.errorSnackBar(title: 'Error!');
      }
    }
  }

  Future<void> syncProductsToOnlineDbAuto() async {
    final salesList = await dbService
        .rawQuery('SELECT * FROM mobile_sales_details WHERE statusId = ?', [1]);
    if (salesList.isNotEmpty) {
      state = true;
      for (var data in salesList) {
        var serialNo = data['serialNo'] as int;
        var receiptId = data['receiptId'];
        var quantity = data['quantity'];
        var sellingPrice = data['sellingPrice'];
        var productId = data['productId'];
        var transactionDate =
            DateTime.fromMillisecondsSinceEpoch(data['transactionDate'] as int);
        var paymentMethod = data['paymentMethod'];
        var postedBy = data['postedBy'];
        var cartId = data['cartId'];
        var transactionId = data['transactionId'];
        var shopId = data['shopId'] ?? '';
        var servedBy = data['servedBy'] ?? '';

        var toUpload = {
          "productId": productId as String,
          "quantity": quantity.toString(),
          "sellingPrice": sellingPrice.toString(),
          "transactionDate": transactionDate.toString(),
          "receiptId": receiptId as String,
          "paymentMethod": paymentMethod as String,
          "postedBy": postedBy as String,
          "cartId": cartId as String,
          "transactionId": transactionId as String,
          "shopId": shopId as String,
          "servedBy": servedBy as String,
        };

        String endpoint = 'receipt_add.php';
        final response = await HttpService.post(endpoint, toUpload);
        final httpStatusResponse = HttpStatus.fromCode(response.statusCode);

        if (httpStatusResponse.isSuccessfulHttpStatusCode) {
          final String sql =
              "UPDATE mobile_sales_details SET statusId = ? WHERE serialNo = ?";
          dbService.rawQuery(sql, [2, serialNo]);
          ref.read(unsyncedRecordsProvider.notifier).unsynced();
        }
        state = false;
      }
    }
  }
}

class SyncProductsToLocalNotifier extends StateNotifier<bool> {
  SyncProductsToLocalNotifier() : super(false);

  Future<dynamic> syncProductsToLocalDb() async {
    const String endpoint = 'product_details.php';
    final response = await HttpService.get(endpoint);
    dynamic productList = jsonDecode(response.body);
    //log(response.body);
    productList.forEach((row) async {
      final List<Map<String, dynamic>> existing = await dbService.getWhere(
          'product_details', 'productId', row['productId']);

      if (existing.isNotEmpty) {
        await dbService.rawQuery(
            "UPDATE product_details SET sellingPrice = ?, purchasePrice = ? WHERE productId = ?",
            [row['sellingPrice'], row['purchasePrice'], row['productId']]);
      } else {
        await dbService.insert('product_details', {
          'categoryId': row['categoryId'],
          'productId': row['productId'],
          'productName': row['productName'],
          'statusId': row['statusId'],
          'sellingPrice': row['sellingPrice'],
          'purchasePrice': row['purchasePrice']
        });
      }
    });
    state = true;  
  }
}

class SyncStaffListToLocalNotifier extends StateNotifier<bool> {
  SyncStaffListToLocalNotifier() : super(false);

  Future<dynamic> syncStaffListToLocalDb() async {
    const String endpoint = 'staff_details.php';
    final response = await HttpService.get(endpoint);
    dynamic categoryList = jsonDecode(response.body);
    //log(response.body);
    categoryList.forEach((row) async {
      final List<Map<String, dynamic>> existing =
          await dbService.getWhere('staff_details', 'staffId', row['staffId']);

      if (existing.isNotEmpty) {
        dbService.rawQuery(
            "UPDATE staff_details SET shopId = ? WHERE staffId = ?",
            [row['shopId'], row['staffId']]);
      } else {
        dbService.insert('staff_details', {
          'staffId': row['staffId'],
          'shopId': row['shopId'],
          'staffName': row['staffName'],
        });
      }
    });
    state = true;
  }
}

final syncStaffListToLocalProvider =
    StateNotifierProvider<SyncStaffListToLocalNotifier, bool>((ref) {
  return SyncStaffListToLocalNotifier();
});

final syncCategoriesProvider =
    StateNotifierProvider<SyncCategoriesNotifier, bool>((ref) {
  return SyncCategoriesNotifier();
});

final syncProductsToOnlineProvider =
    StateNotifierProvider<SyncProductsToOnlineNotifier, bool>((ref) {
  return SyncProductsToOnlineNotifier(ref);
});

final syncProductsToLocalProvider =
    StateNotifierProvider<SyncProductsToLocalNotifier, bool>((ref) {
  return SyncProductsToLocalNotifier();
});
