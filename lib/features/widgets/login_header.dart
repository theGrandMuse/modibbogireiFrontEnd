import 'package:modibbogirei/common/widgets/images/t_rounded_image.dart';
import 'package:modibbogirei/utils/constants/enums.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: TSizes.spaceBtwSections),
          const SizedBox(height: TSizes.spaceBtwSections),
          const SizedBox(height: TSizes.spaceBtwSections),
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            TRoundedImage(
              width: 70,
              padding: 0,
              height: 70,
              imageType: ImageType.asset,
              image: TImages.emcubeLogo,
              applyImageRadius: true,
              borderRadius: 20,
              backgroundColor: Colors.black,
              border: Border(
                  bottom: BorderSide(width: 2),
                  top: BorderSide(width: 2),
                  left: BorderSide(width: 2),
                  right: BorderSide(width: 2)),
            ),
          ]),
          const SizedBox(height: TSizes.spaceBtwSections),
          Text(TTexts.loginTitle,
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: TSizes.sm),
          Text(TTexts.loginSubTitle,
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
