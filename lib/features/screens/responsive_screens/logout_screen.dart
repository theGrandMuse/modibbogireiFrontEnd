import 'package:modibbogirei/features/screens/pages/logout_mobile.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/widgets/layouts/templates/site_layout.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      mobile: LogoutMobile(),
      desktop: LogoutMobile(),
      tablet: LogoutMobile(),
    );
  }
}
