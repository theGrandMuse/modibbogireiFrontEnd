import 'package:data_table_2/data_table_2.dart';
import 'package:modibbogirei/features/models/products_model.dart';
import 'package:modibbogirei/features/providers/actions_provider.dart';
import 'package:modibbogirei/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../utils/constants/colors.dart';

class OrderRows extends DataTableSource {
  List<ProductsModel> data;
  BuildContext context;
  WidgetRef ref;

  void _tappedProduct(String productId) {
    ref.read(tappedProductProvider.notifier).state = productId;
    context.go(TRoutes.addToCartPage);
  }

  OrderRows({required this.data, required this.context, required this.ref});
  @override
  DataRow? getRow(int index) {
    return DataRow2(
      onTap: () => _tappedProduct(data[index].productId),
      selected: false,
      onSelectChanged: (value) {},
      cells: [
        DataCell(
          Text(
            data[index].productName,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.black),
          ),
        ),
        DataCell(
          Text(
            'NGN${data[index].formattedSellingPrice}',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.borderSecondary),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
