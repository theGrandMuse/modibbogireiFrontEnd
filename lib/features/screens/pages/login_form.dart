
import 'package:modibbogirei/routes/routes.dart';
import 'package:modibbogirei/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/validators/validation.dart';
import '../../providers/login_provider.dart';

class TLoginForm extends ConsumerStatefulWidget {
  const TLoginForm({
    super.key,
  });
  @override
  ConsumerState<TLoginForm> createState() {
    return _TloginFormState();
  }
}

class _TloginFormState extends ConsumerState<TLoginForm> {
  var _hidePassword = true;
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();

  void _signIn() async {
    //log(_username.text);
    
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            /// Email
            TextFormField(
              controller: _username,
              validator: TValidator.validateEmail,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: TTexts.username),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Password
            TextFormField(
              obscureText: _hidePassword,
              controller: _password,
              validator: (value) =>
                  TValidator.validateEmptyText('Password', value),
              decoration: InputDecoration(
                labelText: TTexts.password,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _hidePassword = false;
                    });
                  },
                  icon: Icon(_hidePassword ? Iconsax.eye_slash : Iconsax.eye),
                ),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields / 2),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: _signIn, child: const Text(TTexts.signIn)),
            ),
          ],
        ),
      ),
    );
  }
}
