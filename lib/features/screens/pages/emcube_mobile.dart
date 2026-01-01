import 'package:modibbogirei/features/screens/pages/dashboard.dart';
import 'package:modibbogirei/routes/routes.dart';
import 'package:modibbogirei/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class modibbogireiMobileScreen extends StatelessWidget {
  const modibbogireiMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Dashboard(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TColors.darkBlueColor.withAlpha(50),
        onPressed: () => context.go(TRoutes.cart),
        child: const Icon(
          Iconsax.shopping_cart,
          color: TColors.darkBlueColor,
        ),
      ),
    );
  }
}
