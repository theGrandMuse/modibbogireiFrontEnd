import 'package:modibbogirei/features/screens/responsive_screens/login_desktop.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/layouts/templates/site_layout.dart';
import '../responsive_screens/login_mobile.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(useLayout: false, mobile: LoginScreenMobile(), desktop: LoginScreenDesktop(),);
  }
}
