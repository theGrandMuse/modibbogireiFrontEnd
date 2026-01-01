import 'package:flutter/material.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';

/// A circular loader widget with customizable foreground and background colors.
class TLoaderAnimation extends StatelessWidget {
  const TLoaderAnimation({
    super.key,
    this.height = 300,
    this.width = 300,
  });

  final double height, width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image(image: const AssetImage(TImages.ridingIllustration), height: height, width: width),
          const SizedBox(height: TSizes.spaceBtwItems),
          const Text('Loading your data...'),
        ],
      ),
    );
  }
}
