import 'package:modibbogirei/features/providers/login_provider.dart';
import 'package:modibbogirei/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:modibbogirei/routes/routes.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';

class LoginFormDesktopRightSide extends StatelessWidget {
  const LoginFormDesktopRightSide({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        decoration: BoxDecoration(
          color: TColors.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(150),
            bottomLeft: Radius.circular(150),
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          border: Border.all(color: TColors.primary),
          boxShadow: [
            BoxShadow(
              color: TColors.grey.withAlpha(10),
              spreadRadius: 5,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /* const Image(
              image: AssetImage(TImages.loginSettingsAnimation1),
            ) */
            const SizedBox(height: TSizes.sm),
            const Text(
              TTexts.emcubeDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: TSizes.defaultSpace),
            /* SizedBox(
              width: 200,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text(
                  TTexts.readMore,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ) */
          ],
        ),
      ),
    );
  }
}

class LoginFormDesktopLeftSide extends ConsumerStatefulWidget {
  const LoginFormDesktopLeftSide({super.key});

  @override
  ConsumerState<LoginFormDesktopLeftSide> createState() =>
      _LoginFormDesktopLeftSideState();
}

class _LoginFormDesktopLeftSideState
    extends ConsumerState<LoginFormDesktopLeftSide> {
  final _loginFormDesktopKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();

  void _signIn() async {
    String username = _username.text;
    String password = _password.text;
    if (username.isEmpty || username == '') {
      TLoaders.errorSnackBar(title: 'Username cannot be empty');
      return;
    }

    if (password.isEmpty || password == '') {
      TLoaders.errorSnackBar(title: 'Password cannot be empty');
      return;
    }
    bool isLogin = await ref
        .read(loginProvider.notifier)
        .signIn(_username.text, _password.text);
    if (isLogin) {
      if (mounted) {
        context.go(TRoutes.populationPage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Form(
        key: _loginFormDesktopKey,
        child: Container(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                width: 100,
                height: 100,
                image: AssetImage(TImages.emcubeLogo),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Text(
                TTexts.loginTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.sm),
              Text(
                TTexts.loginSubTitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Email
              TextFormField(
                controller: _username,
                validator: TValidator.validateEmail,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: TTexts.username,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              TextFormField(
                controller: _password,
                validator: (value) =>
                    TValidator.validateEmptyText('Password', value),
                decoration: InputDecoration(
                  labelText: TTexts.password,
                  prefixIcon: const Icon(Iconsax.password_check),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwInputFields / 2),

              /// Remember Me & Forget Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Remember Me

                  /// Forget Password
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // onPressed: () => Get.to(TRoutes.controllerParameter),
                  onPressed: () => _signIn(),
                  child: const Text(TTexts.signIn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
