import 'package:modibbogirei/features/widgets/table/dashboard_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:modibbogirei/features/providers/list_provider.dart';

class DashboardTable extends ConsumerStatefulWidget {
  const DashboardTable({super.key});
  @override
  ConsumerState<DashboardTable> createState() {
    return _DashboardTableState();
  }
}

class _DashboardTableState extends ConsumerState<DashboardTable> {
  late Future<void> _products;

  @override
  void initState() {
    super.initState();
    _products = ref.read(productListProvider.notifier).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productData = ref.watch(productListProvider);
    productData.shuffle();
    return FutureBuilder(
        future: _products,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : DashboardItemList(productsData: productData));
  }
}
