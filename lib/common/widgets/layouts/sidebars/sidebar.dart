import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../images/t_circular_image.dart';
import 'menu/menu_item.dart';

/// Sidebar widget for navigation menu
class TSidebar extends StatelessWidget {
  const TSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
          color: TColors.white,
          border: Border(right: BorderSide(width: 1, color: TColors.grey)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  SizedBox(height: TSizes.spaceBtwSections),
                  SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
              Row(
                children: [
                  const TCircularImage(
                    width: 60,
                    height: 60,
                    padding: 0,
                    margin: TSizes.sm,
                    backgroundColor: Colors.transparent,
                    imageType: ImageType.asset,
                    image: TImages.emcubeLogo,
                  ),
                  Text('Emcube',
                      style: Theme.of(context).textTheme.headlineLarge),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('MENU',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(letterSpacingDelta: 1.2)),
                    // Menu Items
                    const TMenuItem(
                      route: TRoutes.dashboard,
                      icon: Iconsax.receipt_add,
                      itemName: 'Make Sales',
                    ),

                    const TMenuItem(
                      route: TRoutes.salesHistory,
                      icon: Iconsax.arrow_swap,
                      itemName: 'Sales History',
                    ),

                    const SizedBox(height: TSizes.spaceBtwItems),
                    Text('OTHER',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(letterSpacingDelta: 1.2)),
                    // Other menu items
                    const TMenuItem(
                      route: TRoutes.profile,
                      icon: Iconsax.user,
                      itemName: 'Profile',
                    ),
                    const TMenuItem(
                      route: TRoutes.settings,
                      icon: Iconsax.setting_2,
                      itemName: 'Settings',
                    ),
                    const TMenuItem(
                      route: TRoutes.logout,
                      icon: Iconsax.logout,
                      itemName: 'Logout',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
