import 'package:modibbogirei/features/providers/login_provider.dart';
import 'package:modibbogirei/routes/routes.dart';
import 'package:modibbogirei/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Logout extends ConsumerStatefulWidget {
  const Logout({super.key});

  @override
  ConsumerState<Logout> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends ConsumerState<Logout> {
  Future<void> _logOut() async {
    await Future.delayed(const Duration(seconds: 2), () async {
      if (mounted) {
        bool isLogOut = await ref.read(loginProvider.notifier).logout();
        if (isLogOut) context.pop(TRoutes.dashboard);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _logOut;
    return Scaffold(
        backgroundColor: TColors.white,
        body:  Center(
                child: CircularProgressIndicator(),
              ));
  }
}
