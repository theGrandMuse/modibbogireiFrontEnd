import 'package:flutter/material.dart';

import '../../../common/widgets/layouts/templates/site_layout.dart';
import '../responsive_screens/forget_password_desktop.dart';

/// Screen for handling the forget password process
class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(useLayout: false, desktop: ForgetPasswordScreenDesktop());
  }
}
