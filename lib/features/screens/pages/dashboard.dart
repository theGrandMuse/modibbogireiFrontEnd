
import 'package:modibbogirei/features/providers/actions_provider.dart';
import 'package:modibbogirei/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import 'package:modibbogirei/features/providers/list_provider.dart';

import 'package:modibbogirei/utils/validators/validation.dart';
import '../../../../utils/constants/sizes.dart';

import '../../../../common/widgets/containers/rounded_container.dart';
import '../../widgets/table/dashboard_table.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends ConsumerState<Dashboard> {
  final _searchFormKey = GlobalKey<FormState>();
  final _searchTerm = TextEditingController();
  final FocusNode inputFocusNode = FocusNode();

  @override
  void initState() {
    ref.read(staffListProvider.notifier).getStaffList();
    ref.read(totalTodayProvider.notifier).totalToday();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //log('Building Dashboard');
    return Column(
      children: [
        TRoundedContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Form(
                      key: _searchFormKey,
                      child: TextFormField(
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        focusNode: inputFocusNode,
                        autofocus: false,
                        onChanged: (value) => ref
                            .read(productListProvider.notifier)
                            .searchProducts(value),
                        controller: _searchTerm,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Iconsax.search_normal,
                              color: TColors.darkerGrey,
                            ),
                            labelText: 'Search for product'),
                        validator: (value) =>
                            TValidator.validateEmptyText('Name', value),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Expanded(
          child: TRoundedContainer(
            child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [const DashboardTable()],
                  ),
                ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
