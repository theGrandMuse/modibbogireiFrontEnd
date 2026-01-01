import 'package:modibbogirei/features/providers/sync_provider.dart';
import 'package:modibbogirei/routes/routes.dart';
import 'package:modibbogirei/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Populate extends ConsumerStatefulWidget {
  const Populate({super.key});

  @override
  ConsumerState<Populate> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends ConsumerState<Populate> {
  Future<void> loadData() async {
    await Future.delayed(const Duration(seconds: 7), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go(TRoutes.dashboard);
        }
      });
    });
  }

  @override
  void initState() {
    ref.read(syncStaffListToLocalProvider.notifier).syncStaffListToLocalDb();
    ref.read(syncCategoriesProvider.notifier).syncCategoriesToLocalDb();
    ref.read(syncProductsToLocalProvider.notifier).syncProductsToLocalDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSynced = ref.watch(syncProductsToLocalProvider);
    if (isSynced) {
      loadData();
    }
     
    return const Scaffold(
      backgroundColor: TColors.white,
      body: Center(
        child: CircularProgressIndicator(color: TColors.darkGreenColor),
      ),
    );
  }
}
