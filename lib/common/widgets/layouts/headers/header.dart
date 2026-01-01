import 'package:modibbogirei/features/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../appbar/appbar.dart';
import '../../images/t_rounded_image.dart';

/// Header widget for the application
class THeader extends ConsumerWidget implements PreferredSizeWidget {
  const THeader({
    super.key,
    required this.scaffoldKey,
  });

  

  /// GlobalKey to access the Scaffold state
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModel = ref.watch(userModelProvider);
    return Container(
      /// Background Color, Bottom Border
      decoration: const BoxDecoration(
        color: TColors.white,
        border: Border(bottom: BorderSide(color: TColors.grey, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: TSizes.md, vertical: TSizes.sm),
      child: TAppBar(
        /// Mobile Menu
        leadingIcon: !TDeviceUtils.isDesktopScreen ? Iconsax.menu : null,
        leadingOnPressed: !TDeviceUtils.isDesktopScreen
            ? () => scaffoldKey.currentState?.openDrawer()
            : null,

        actions: [
          // Search Icon on Mobile
          if (!TDeviceUtils.isDesktopScreen)
            IconButton(
                icon: const Icon(Iconsax.search_normal), onPressed: () {}),

          // Notification Icon
          IconButton(icon: const Icon(Iconsax.notification), onPressed: () {}),
          const SizedBox(width: TSizes.spaceBtwItems / 2),

          /// User Data
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// User Profile Image
              const TRoundedImage(
                width: 40,
                padding: 2,
                height: 40,
                imageType: ImageType.asset,
                image: TImages.user,
              ),

              const SizedBox(width: TSizes.sm),

              /// User Profile Data [Hide on Mobile]
              if (!TDeviceUtils.isMobileScreen)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${userModel!.firstName} ${userModel.lastName}',
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(userModel.roleName,
                        style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight + 15);
}
