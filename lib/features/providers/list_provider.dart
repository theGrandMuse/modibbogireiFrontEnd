import 'dart:async';

import 'package:modibbogirei/features/models/servers_model.dart';
import 'package:modibbogirei/features/providers/actions_provider.dart';
import 'package:modibbogirei/features/providers/sync_provider.dart';
import 'package:modibbogirei/features/services/shared_prefs_service.dart';
import 'package:modibbogirei/routes/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:modibbogirei/features/services/database_service.dart';

import 'package:modibbogirei/features/models/categories_model.dart';
import 'package:modibbogirei/features/models/history_model.dart';
import 'package:modibbogirei/features/models/products_model.dart';
import 'package:modibbogirei/features/models/cart_model.dart';
import 'package:modibbogirei/features/models/receipt_model.dart';
import 'package:modibbogirei/features/models/user_model.dart';

import 'package:modibbogirei/utils/popups/loaders.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final dbService = DatabaseService();

class CategoriesListNotifier extends StateNotifier<List<CategoriesModel>> {
  CategoriesListNotifier() : super([]);

  Future<void> loadCategories() async {
    final data = await dbService.get('product_category');
    final categories = data
        .map((row) => CategoriesModel(
            categoryId: row['categoryId'] as String,
            categoryName: row['categoryName'] as String))
        .toList();
    state = categories;
  }
}

class ProductsListNotifier extends StateNotifier<List<ProductsModel>> {
  ProductsListNotifier(this.ref) : super([]);
  Ref ref;

  Future<List<ProductsModel>> loadProducts() async {
    final String query =
        "SELECT product_details.*,(SELECT categoryName FROM product_category WHERE categoryId = product_details.categoryId) AS categoryName FROM product_details WHERE statusId = ?";
    final data = await dbService.rawQuery(query, [1]);
    final products = data.map((row) => ProductsModel.fromMap(row)).toList();
    state = products;
    return products;
  }

  Future<List<ProductsModel>> searchProducts(String searchTerm) async {
    final String query =
        "SELECT *,(SELECT categoryName FROM product_category WHERE categoryId = product_details.categoryId) AS categoryName FROM product_details WHERE productName LIKE ? AND statusId= ?";
    final data = await dbService.rawQuery(query, ['%$searchTerm%', 1]);

    final searchedProducts =
        data.map((row) => ProductsModel.fromMap(row)).toList();
    state = searchedProducts;
    return searchedProducts;
  }
}

class HistoryListNotifier extends StateNotifier<HistoryBucket> {
  HistoryListNotifier(this.ref) : super(HistoryBucket(historyModel: []));
  Ref ref;
  HistoryBucket? historyBucket;
  final DateTime now = DateTime.now();
  String get thisMonth => DateFormat('MM').format(now);
  String get thisYear => DateFormat('yyyy').format(now);

  Future<HistoryBucket> loadHistory() async {
    String yearMonth = '$thisYear-$thisMonth';
    final String query =
        "SELECT  SUM(sellingPrice*quantity) AS amountPaid, sellingPrice,transactionDate,(SELECT productName FROM product_details WHERE product_details.productId = mobile_sales_details.productId LIMIT 1) productName,paymentMethod,cartId,quantity FROM mobile_sales_details WHERE strftime('%Y-%m', transactionDate / 1000, 'unixepoch') = ? GROUP BY cartId ORDER BY serialNo DESC";
    final data = await dbService.rawQuery(query, [yearMonth]);
   // log(data.toString());
    List<HistoryModel> historyList = [];

    for (var row in data) {
      Map<String, dynamic> json = {
        'productName': row['productName'],
        'sellingPrice': row['sellingPrice'],
        'quantity': row['quantity'],
        'transactionDate': row['transactionDate'],
        'paymentMethod': row['paymentMethod'],
        'cartId': row['cartId'],
        'amountPaid': row['amountPaid']
      };
      HistoryModel history = HistoryModel.fromMap(json);
      historyList.add(history);
    }
    //log('here');
    HistoryBucket historyBucket = HistoryBucket(historyModel: historyList);
    state = historyBucket;
    return state;
  }

  Future<HistoryBucket> searchHistory(String month, int year) async {
    String yearMonth = '$year-$month';
    final String query =
        "SELECT SUM(sellingPrice*quantity) AS amountPaid, sellingPrice,quantity,transactionDate,(SELECT productName FROM product_details WHERE product_details.productId = mobile_sales_details.productId LIMIT 1) productName,paymentMethod,cartId FROM mobile_sales_details WHERE strftime('%Y-%m', transactionDate / 1000, 'unixepoch') = ? GROUP BY cartId ORDER BY serialNo DESC";
    final data = await dbService.rawQuery(query, [yearMonth]);
    List<HistoryModel> historyList = [];
    for (var row in data) {
      Map<String, dynamic> json = {
        'productName': row['productName'],
        'sellingPrice': row['sellingPrice'],
        'quantity': row['quantity'],
        'transactionDate': row['transactionDate'],
        'paymentMethod': row['paymentMethod'],
        'cartId': row['cartId'],
        'amountPaid': row['amountPaid']
      };
      HistoryModel history = HistoryModel.fromMap(json);
      historyList.add(history);
    }

    HistoryBucket historyBucket = HistoryBucket(historyModel: historyList);
    state = historyBucket;
    return state;
  }
}

class CartListNotifier extends StateNotifier<CartBucket> {
  CartListNotifier(this.ref) : super(CartBucket(cartItem: []));
  String? selectedPaymentMethod;
  UserModel? currentUser;
  Ref ref;
  List<CartModel> _cartBucketList = [];
  String _servedBy = '';
  String get staffName {
    List<ServersModel> serversModel = ref.read(staffListProvider);
    ServersModel addedModel = serversModel.firstWhere((entity) {
      return entity.staffId == _servedBy;
    });
    return addedModel.staffName;
  }

  Future<dynamic> createReceipt() async {
    int transactionDate = DateTime.now().millisecondsSinceEpoch;
    selectedPaymentMethod = ref.read(selectedPaymentMethodProvider);

    String cartId = uuid.v4();
    String? userId = await SharedPrefsService.getUserId();
    String? shopId = await SharedPrefsService.getShopId();

    if (userId == null) {
      TRoutes.login;
      return;
    }

    for (CartModel cartItem in state.cartItem) {
      ReceiptModel receiptModel = ReceiptModel(
          servedBy: cartItem.servedBy,
          productId: cartItem.productId,
          quantity: cartItem.quantity,
          sellingPrice: cartItem.product.sellingPrice,
          transactionDate: DateTime.fromMillisecondsSinceEpoch(transactionDate),
          productName: cartItem.product.productName,
          postedBy: userId,
          paymentMethod: selectedPaymentMethod,
          shopId: shopId!);
      dbService.insert('mobile_sales_details', {
        'cartId': cartId,
        'receiptId': receiptModel.receiptId,
        'productId': cartItem.productId,
        'quantity': cartItem.quantity,
        'sellingPrice': cartItem.product.sellingPrice,
        'postedBy': userId,
        'statusId': 1,
        'transactionDate': transactionDate,
        'paymentMethod': selectedPaymentMethod,
        'transactionId': cartItem.transactionId,
        'shopId': shopId,
        'servedBy': cartItem.servedBy
      });
    }
    ref.read(selectedPaymentMethodProvider.notifier).state = null;

    bool isConnected = await InternetConnection().hasInternetAccess;
    if (isConnected) {
      ref
          .read(syncProductsToOnlineProvider.notifier)
          .syncProductsToOnlineDbAuto();
    }
    ref.read(unsyncedRecordsProvider.notifier).unsynced();
    ref.read(totalTodayProvider.notifier).totalToday();
  }

  void clearCart() {
    _cartBucketList = [];
    CartBucket cartBucket = CartBucket(cartItem: []);
    state = cartBucket;
  }

  void removeProduct(String transactionId) {
    _cartBucketList
        .where((item) => item.transactionId != transactionId)
        .toList();
    CartBucket cartBucket = CartBucket(cartItem: _cartBucketList);
    state = cartBucket;
    TLoaders.successSnackBar(title: 'Removed');
  }

  void addToCart(int addedQuantity, ProductsModel product, String servedBy) {
    _servedBy = servedBy;
    CartModel newModel = CartModel(
        servedBy: servedBy,
        product: product,
        quantity: addedQuantity,
        productId: product.productId,
        servedByName: staffName);
    _cartBucketList.add(newModel);
    CartBucket cartBucket = CartBucket(cartItem: _cartBucketList);
    state = cartBucket;
    TLoaders.successSnackBar(title: 'Added');
  }
}

class ReceiptListNotifier extends StateNotifier<List<ReceiptModel>> {
  ReceiptListNotifier(this.ref) : super([]);

  Ref ref;
  String? cartId;
  List<ReceiptModel> receiptList = [];

  Future<List<ReceiptModel>> getReceiptDetails() async {
    cartId = ref.read(cartIdProvider);
    final data = await dbService.rawQuery(
        'SELECT receiptId,quantity,productId,sellingPrice,transactionDate,(SELECT productName FROM product_details WHERE product_details.productId = mobile_sales_details.productId) AS productName,postedBy,shopId,servedBy FROM mobile_sales_details WHERE cartId =?',
        [cartId]);

    final items = data
        .map((row) => ReceiptModel(
            servedBy: row['servedBy'] as String,
            productId: row['productId'] as String,
            quantity: row['quantity'] as int,
            sellingPrice: row['sellingPrice'] as double,
            transactionDate: DateTime.fromMillisecondsSinceEpoch(
                row['transactionDate'] as int),
            productName: row['productName'] as String,
            postedBy: row['postedBy'] as String,
            paymentMethod: row['paymentMethod'] as String?,
            shopId: row['shopId'] as String))
        .toList();
    //log(items.toString());
    //return receiptList = items;
    return state = items;
    //log(state.toString());
  }

  void reset() {
    state = [];
    state = [...state];
  }
}

class StaffListNotifier extends StateNotifier<List<ServersModel>> {
  StaffListNotifier() : super([]);

  Future<void> getStaffList() async {
    final String query = "SELECT * FROM staff_details ";
    final data = await dbService.rawQuery(query);
    final staffList = data.map((row) => ServersModel.fromMap(row)).toList();
    state = staffList;
  }
}

final staffListProvider =
    StateNotifierProvider<StaffListNotifier, List<ServersModel>>((ref) {
  return StaffListNotifier();
});
final categoriesListProvider =
    StateNotifierProvider<CategoriesListNotifier, List<CategoriesModel>>((ref) {
  return CategoriesListNotifier();
});
final productListProvider =
    StateNotifierProvider<ProductsListNotifier, List<ProductsModel>>((ref) {
  return ProductsListNotifier(ref);
});

final historyListProvider =
    StateNotifierProvider<HistoryListNotifier, HistoryBucket>((ref) {
  return HistoryListNotifier(ref);
});

final receiptListProvider =
    StateNotifierProvider<ReceiptListNotifier, List<ReceiptModel>>((ref) {
  return ReceiptListNotifier(ref);
});

final cartListProvider =
    StateNotifierProvider<CartListNotifier, CartBucket>((ref) {
  return CartListNotifier(ref);
});
