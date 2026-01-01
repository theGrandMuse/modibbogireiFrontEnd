import 'package:modibbogirei/features/providers/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/link.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class TMenuItem extends ConsumerWidget {
  const TMenuItem(
      {super.key,
      required this.route,
      required this.itemName,
      required this.icon});

  final String route;
  final IconData icon;
  final String itemName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(activeItemProvider);
    ref.watch(hoverItemProvider);
    return Link(
      uri: route != 'logout' ? Uri.parse(route) : null,
      builder: (_, __) => InkWell(
        onTap: () => ref.read(menuProvider.notifier).menuOnTap(route),
        onHover: (value) => value
            ? ref.read(menuProvider.notifier).changeHoverItem(route)
            : ref.read(menuProvider.notifier).changeHoverItem(''),
        child:
            // Decoration Box
            Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          child: Container(
            decoration: BoxDecoration(
              color: ref.read(menuProvider.notifier).isHovering(route)
                  ? TColors.white
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
            ),

            // Icon and Text Row
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon
                Padding(
                  padding: const EdgeInsets.only(
                      left: TSizes.lg,
                      top: TSizes.md,
                      bottom: TSizes.md,
                      right: TSizes.md),
                  child: ref.read(menuProvider.notifier).isActive(route)
                      ? Icon(icon, size: 22, color: TColors.grayColor)
                      : Icon(icon,
                          size: 22,
                          color:
                              ref.read(menuProvider.notifier).isHovering(route)
                                  ? TColors.black
                                  : TColors.darkGrey),
                ),
                // Text
                if (ref.read(menuProvider.notifier).isHovering(route) )
                  Flexible(
                    child: Text(itemName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .apply(color: TColors.black)),
                  )
                else
                  Flexible(
                    child: Text(itemName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .apply(color: TColors.darkGrey)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
