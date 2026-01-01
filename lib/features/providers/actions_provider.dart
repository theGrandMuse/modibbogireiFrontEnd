import 'dart:async';
import 'package:modibbogirei/features/services/database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';

class UnSyncedNumberNotifier extends StateNotifier<int> {
  final dbService = DatabaseService();
  UnSyncedNumberNotifier(this.ref) : super(0);
  //static const String _baseUrl = "https://emcube.com.ng/portal/api";
  Ref ref;

  Future<int> unsynced() async {
    final String query =
        "SELECT * FROM mobile_sales_details WHERE statusId = ?";
    final data = await dbService.rawQuery(query, [1]);
    int unsynced = data.length;
    state = unsynced;
    return unsynced;
  }
}

class DailyTotalNotifier extends StateNotifier<double> {
  DailyTotalNotifier(this.ref) : super(0);
  //static const String _baseUrl = "https://emcube.com.ng/portal/api";
  Ref ref;
  final dbService = DatabaseService();

  Future<void> totalToday() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = startOfDay.add(Duration(days: 1));

    int startOfDayMillis = startOfDay.millisecondsSinceEpoch;
    int endOfDayMillis = endOfDay.millisecondsSinceEpoch;

    final String query =
        "SELECT SUM(quantity*sellingPrice) total FROM mobile_sales_details WHERE transactionDate >= ? AND transactionDate < ?";
    double total = 0;
    final data =
        await dbService.rawQuery(query, [startOfDayMillis, endOfDayMillis]);
    if (data.isNotEmpty) {
      total = data.first['total'] ?? 0.0;
    }

    state = total;
  }
}

final totalTodayProvider =
    StateNotifierProvider<DailyTotalNotifier, double>((ref) {
  return DailyTotalNotifier(ref);
});

final selectedHistoryMonthProvider = StateProvider<String?>((ref) {
  final DateTime now = DateTime.now();
  String formattedMonth = DateFormat('MMM').format(now);
  return formattedMonth;
});
final selectedPaymentMethodProvider = StateProvider<String?>((ref) => null);
final tappedProductProvider = StateProvider<String?>((ref) => null);
final cartIdProvider = StateProvider<String?>((ref) => null);

final unsyncedRecordsProvider =
    StateNotifierProvider<UnSyncedNumberNotifier, int>((ref) {
  //ref.watch(syncProductsToOnlineProvider);
  return UnSyncedNumberNotifier(ref);
});
