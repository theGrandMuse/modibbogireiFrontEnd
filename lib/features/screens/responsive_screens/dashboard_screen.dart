import 'package:flutter/material.dart';

import '../../../common/widgets/layouts/templates/site_layout.dart';
import '../pages/dashboard_mobile.dart';

class ControlParametersScreen extends StatelessWidget {
  const ControlParametersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      mobile: MobileDashboardScreen(),
      desktop: MobileDashboardScreen(),
    );
  }
}