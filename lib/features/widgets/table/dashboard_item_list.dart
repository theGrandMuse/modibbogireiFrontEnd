import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:modibbogirei/common/widgets/images/t_rounded_image.dart';
import 'package:modibbogirei/features/models/products_model.dart';
import 'package:modibbogirei/features/providers/actions_provider.dart';
import 'package:modibbogirei/utils/constants/enums.dart';

import 'package:modibbogirei/routes/routes.dart';

import '../../../../common/widgets/containers/rounded_container.dart';

class DashboardItemList extends ConsumerWidget {
  final List<ProductsModel> productsData;

  const DashboardItemList({super.key, required this.productsData});

  void _tappedProduct(String productId, WidgetRef ref) {
    ref.read(tappedProductProvider.notifier).state = productId;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final monthTotal = ref.read(historyProvider.notifier).getMonthTotal();
    return SingleChildScrollView(
      child: Column(
        children: [
          TRoundedContainer(
            //padding: const EdgeInsets.all(3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        InkWell(
                          onDoubleTap: () {
                            _tappedProduct(productsData[index].productId, ref);
                            context.go(TRoutes.addToCartPage);
                          },
                          child: ListTile(
                            leading: TRoundedImage(
                              height: 100,
                              padding: 0,
                              fit: BoxFit.fill,
                              imageType: ImageType.asset,
                              image: productsData[index].categoryImage,
                            ),
                            title: Text(
                                '${productsData[index].productName}\n${productsData[index].formattedSellingPrice}'),
                            subtitle: Text(
                              productsData[index].categoryName!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            trailing: TextButton.icon(
                              onPressed: () {
                                _tappedProduct(
                                    productsData[index].productId, ref);
                                context.go(TRoutes.addToCartPage);
                              },
                              label: Text('Add to Cart'),
                              icon: Icon(Icons.arrow_forward),
                              iconAlignment: IconAlignment.end,
                            ),
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                  itemCount: productsData.length,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
